import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/models/message_models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dating/services/auth_service.dart';
import 'package:path/path.dart' as path;

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthService _authService = AuthService();

  String generateChatId(String id1, String id2) {
    List<String> ids = [id1, id2];
    ids.sort();
    return '${ids[0]}_${ids[1]}';
  }

  String generateMessageId() {
    return _firestore.collection('temp').doc().id;
  }

  Future<String> getOrCreateChatRoom({
    required String user1Id,
    required String user2Id,
    required String user1Name,
    required String user2Name,
    required String user1Photo,
    required String user2Photo,
  }) async {
    String chatId = generateChatId(user1Id, user2Id);
    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        'participants': [user1Id, user2Id],
        'participantNames': {user1Id: user1Name, user2Id: user2Name},
        'participantPhotos': {user1Id: user1Photo, user2Id: user2Photo},
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '👋 Matched! Say hi',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSender': user1Id,
        'lastMessageType': 'text',
        'unreadCount': {user1Id: 0, user2Id: 0},
        'typingUsers': [],
        'mutedBy': [],
        'pinnedBy': [],
        'archivedBy': [],
        'wallpaper': '',
        'theme': 'dark',
      });
    }
    return chatId;
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    final msgRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    final newMessage = message.copyWith(
      messageId: msgRef.id,
      status: MessageStatus.sent,
    );

    await msgRef.set(newMessage.toMap());

    await _updateChatLastMessage(chatId, newMessage);
  }

  Future<void> sendMediaMessage({
    required String chatId,
    required MessageModel message,
    required File file,
    Function(double)? onProgress,
  }) async {
    final msgRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.messageId.isEmpty ? null : message.messageId);

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final storageRef = _storage
        .ref()
        .child('chats')
        .child(chatId)
        .child(message.type.name)
        .child(fileName);

    // Upload with progress
    final uploadTask = storageRef.putFile(file);
    
    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });
    }

    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    final newMessage = message.copyWith(
      messageId: msgRef.id,
      status: MessageStatus.sent,
      mediaUrls: [downloadUrl],
      uploadProgress: null,
    );

    await msgRef.set(newMessage.toMap());
    await _updateChatLastMessage(chatId, newMessage);
  }
// Add these methods to your existing ChatService class

Future<void> updateChatSettings(String chatId, String userId, String action) async {
  final chatRef = _firestore.collection('chats').doc(chatId);
  
  switch (action) {
    case 'pin':
      await chatRef.update({
        'pinnedBy': FieldValue.arrayUnion([userId])
      });
      break;
    case 'unpin':
      await chatRef.update({
        'pinnedBy': FieldValue.arrayRemove([userId])
      });
      break;
    case 'mute':
      await chatRef.update({
        'mutedBy': FieldValue.arrayUnion([userId])
      });
      break;
    case 'unmute':
      await chatRef.update({
        'mutedBy': FieldValue.arrayRemove([userId])
      });
      break;
    case 'archive':
      await chatRef.update({
        'archivedBy': FieldValue.arrayUnion([userId])
      });
      break;
    case 'unarchive':
      await chatRef.update({
        'archivedBy': FieldValue.arrayRemove([userId])
      });
      break;
  }
}

Future<void> deleteChat(String chatId) async {
  // Delete all messages
  final messages = await _firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .get();
      
  final batch = _firestore.batch();
  for (var doc in messages.docs) {
    batch.delete(doc.reference);
  }
  
  // Delete chat document
  batch.delete(_firestore.collection('chats').doc(chatId));
  
  await batch.commit();
}

Stream<QuerySnapshot> getAllChats(String userId) {
  return _firestore
      .collection('chats')
      .where('participants', arrayContains: userId)
      .orderBy('lastMessageTime', descending: true)
      .snapshots();
}

Future<int> getTotalUnreadCount(String userId) async {
  final snapshot = await _firestore
      .collection('chats')
      .where('participants', arrayContains: userId)
      .get();
      
  int total = 0;
  for (var doc in snapshot.docs) {
    final data = doc.data();
    total += (int.parse(data['unreadCount']?[userId].toString()??'0')  );
  }
  return total;
}
  Future<void> _updateChatLastMessage(String chatId, MessageModel message) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    
    await chatRef.update({
      'lastMessage': message.text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastMessageSender': message.senderId,
      'lastMessageType': message.type.name,
      'unreadCount.${message.receiverId}': FieldValue.increment(1),
    });
  }
Stream<DocumentSnapshot> getChatInfo(String chatId) {
  return _firestore
      .collection('chats')
      .doc(chatId)
      .snapshots();
}

  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getChatStream(String chatId) {
    return _firestore.collection('chats').doc(chatId).snapshots();
  }

  Future<void> markMessagesAsRead(String chatId, String userId) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    
    // Update unread count
    await chatRef.update({'unreadCount.$userId': 0});

    // Mark messages as read
    final messages = await chatRef
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('status', whereIn: ['sent', 'delivered'])
        .get();

    final batch = _firestore.batch();
    for (var doc in messages.docs) {
      batch.update(doc.reference, {'status': 'read'});
    }
    await batch.commit();
  }

  Future<void> setTypingStatus(String chatId, String userId, bool isTyping) async {
    await _firestore.collection('chats').doc(chatId).update({
      'typingUsers': isTyping
          ? FieldValue.arrayUnion([userId])
          : FieldValue.arrayRemove([userId])
    });
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Future<void> addReaction(String chatId, String messageId, String reaction) async {
    final reactionData = {
      'userId': await _authService.getUId(),
      'reaction': reaction,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'reactions': FieldValue.arrayUnion([reactionData])
    });
  }

  Future<void> forwardMessage(String chatId, MessageModel message, String targetChatId) async {
    final forwardedMessage = message.copyWith(
      messageId: '',
      timestamp: DateTime.now(),
      isForwarded: true,
      status: MessageStatus.sending,
    );

    await sendMessage(targetChatId, forwardedMessage);
  }
// Add to ChatService class

// Get online status for a user
Stream<bool> getUserOnlineStatus(String userId) {
  return _firestore
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.data()?['online'] ?? false);
}

// Get online status for multiple users
Stream<Map<String, bool>> getMultipleUsersOnlineStatus(List<String> userIds) {
  if (userIds.isEmpty) return Stream.value({});
  
  return _firestore
      .collection('users')
      .where(FieldPath.documentId, whereIn: userIds)
      .snapshots()
      .map((snapshot) {
        final statusMap = <String, bool>{};
        for (var doc in snapshot.docs) {
          final data = doc.data();
          statusMap[doc.id] = data['online'] ?? false;
        }
        return statusMap;
      });
}

// Get last seen for a user
Future<DateTime?> getUserLastSeen(String userId) async {
  final doc = await _firestore.collection('users').doc(userId).get();
  final timestamp = doc.data()?['lastSeen'] as Timestamp?;
  return timestamp?.toDate();
}
  Future<void> updateOnlineStatus(bool isOnline) async {
    final uid = await _authService.getUId();
    await _firestore.collection('users').doc(uid).set({
      'online': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    }
}