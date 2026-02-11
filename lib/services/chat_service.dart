// // services/chat_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
  
//   // Get current user's Firebase UID
//   String getCurrentUserId() {
//     return _auth.currentUser?.uid ?? '';
//   }
  
//   // PUBLIC method to generate chat ID (was private before)
//   String generateChatId(String id1, String id2) {
//     List<String> ids = [id1, id2];
//     ids.sort();
//     return 'chat_${ids.join("_")}';
//   }
  
//   // Create or get existing chat room
//   Future<String> getOrCreateChatRoom(
//     String user1FirebaseId, 
//     String user2FirebaseId,
//     String user1Name,
//     String user2Name,
//     String user1Photo,
//     String user2Photo,
//   ) async {
//     String chatId = generateChatId(user1FirebaseId, user2FirebaseId); // Use public method
    
//     final chatRef = _firestore.collection('chats').doc(chatId);
//     final chatDoc = await chatRef.get();
    
//     if (!chatDoc.exists) {
//       await chatRef.set({
//         'participants': [user1FirebaseId, user2FirebaseId],
//         'participantNames': {
//           user1FirebaseId: user1Name,
//           user2FirebaseId: user2Name,
//         },
//         'participantPhotos': {
//           user1FirebaseId: user1Photo,
//           user2FirebaseId: user2Photo,
//         },
//         'createdAt': FieldValue.serverTimestamp(),
//         'lastMessage': '',
//         'lastMessageTime': FieldValue.serverTimestamp(),
//         'lastMessageSender': '',
//         'chatId': chatId,
//         'typingUsers': [],
//       });
//     }
    
//     return chatId;
//   }
  
//   // Send message
//   Future<void> sendMessage(String chatId, String message) async {
//     String currentUserId = getCurrentUserId();
    
//     // Add message
//     await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .add({
//           'senderId': currentUserId,
//           'text': message,
//           'timestamp': FieldValue.serverTimestamp(),
//           'type': 'text',
//           'readBy': [currentUserId],
//           'deliveredTo': [currentUserId],
//         });
    
//     // Update last message
//     await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .update({
//           'lastMessage': message,
//           'lastMessageTime': FieldValue.serverTimestamp(),
//           'lastMessageSender': currentUserId,
//         });
//   }
  
//   // Get messages stream
//   Stream<QuerySnapshot> getMessages(String chatId) {
//     return _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots();
//   }
  
//   // Get chat info stream
//   Stream<DocumentSnapshot> getChatInfo(String chatId) {
//     return _firestore.collection('chats').doc(chatId).snapshots();
//   }
  
//   // Mark messages as read
//   Future<void> markMessagesAsRead(String chatId) async {
//     String currentUserId = getCurrentUserId();
    
//     final messages = await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .where('readBy', arrayContains: currentUserId)
//         .get();
    
//     final batch = _firestore.batch();
    
//     for (var message in messages.docs) {
//       if (!(message.data()['readBy'] ?? []).contains(currentUserId)) {
//         batch.update(message.reference, {
//           'readBy': FieldValue.arrayUnion([currentUserId])
//         });
//       }
//     }
    
//     await batch.commit();
    
//     // Update last seen
//     await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .update({
//           'lastSeen.${currentUserId}': FieldValue.serverTimestamp(),
//         });
//   }
  
//   // Typing indicator
//   Future<void> setTyping(String chatId, bool isTyping) async {
//     String currentUserId = getCurrentUserId();
    
//     if (isTyping) {
//       await _firestore
//           .collection('chats')
//           .doc(chatId)
//           .update({
//             'typingUsers': FieldValue.arrayUnion([currentUserId])
//           });
//     } else {
//       await _firestore
//           .collection('chats')
//           .doc(chatId)
//           .update({
//             'typingUsers': FieldValue.arrayRemove([currentUserId])
//           });
//     }
//   }
  
//   // Get unread count
//   Future<int> getUnreadCount(String chatId) async {
//     String currentUserId = getCurrentUserId();
    
//     final messages = await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .where('senderId', isNotEqualTo: currentUserId)
//         .where('readBy', arrayContains: currentUserId)
//         .get();
    
//     return messages.docs.length;
//   }
  
//   // Delete message
//   Future<void> deleteMessage(String chatId, String messageId) async {
//     await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .doc(messageId)
//         .update({
//           'text': 'This message was deleted',
//           'isDeleted': true,
//         });
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:developer';

// class ChatService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   String getCurrentUserId() => _auth.currentUser?.uid ?? '';

//   String generateChatId(String id1, String id2) {
//     List<String> ids = [id1, id2];
//     ids.sort();
//     return 'chat_${ids.join("_")}';
//   }

//   Future<String> getOrCreateChatRoom(
//     String user1Id, 
//     String user2Id,
//     String user1Name,
//     String user2Name,
//     String user1Photo,
//     String user2Photo,
//   ) async {
//     try {
//       String chatId = generateChatId(user1Id, user2Id);
//       final chatRef = _firestore.collection('chats').doc(chatId);
//       final chatDoc = await chatRef.get();

//       if (!chatDoc.exists) {
//         await chatRef.set({
//           'participants': [user1Id, user2Id],
//           'participantNames': {user1Id: user1Name, user2Id: user2Name},
//           'participantPhotos': {user1Id: user1Photo, user2Id: user2Photo},
//           'createdAt': FieldValue.serverTimestamp(),
//           'lastMessage': 'Matched! Say hi 👋',
//           'lastMessageTime': FieldValue.serverTimestamp(),
//           'lastMessageSender': '',
//           'chatId': chatId,
//           'typingUsers': [],
//         });
//       }
//       return chatId;
//     } catch (e) {
//       log("Error in getOrCreateChatRoom: $e");
//       rethrow;
//     }
//   }

//   Future<void> sendMessage(String chatId, String text) async {
//     final uid = getCurrentUserId();
//     if (uid.isEmpty) return;

//     final batch = _firestore.batch();
//     final msgRef = _firestore.collection('chats').doc(chatId).collection('messages').doc();
//     final chatRef = _firestore.collection('chats').doc(chatId);

//     batch.set(msgRef, {
//       'senderId': uid,
//       'text': text,
//       'timestamp': FieldValue.serverTimestamp(),
//       'readBy': [uid],
//     });

//     batch.update(chatRef, {
//       'lastMessage': text,
//       'lastMessageTime': FieldValue.serverTimestamp(),
//       'lastMessageSender': uid,
//     });

//     await batch.commit();
//   }

//   Stream<QuerySnapshot> getMessages(String chatId) {
//     return _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }

//   Stream<DocumentSnapshot> getChatInfo(String chatId) {
//     return _firestore.collection('chats').doc(chatId).snapshots();
//   }

//   Future<void> markMessagesAsRead(String chatId) async {
//     final uid = getCurrentUserId();
//     final messages = await _firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .get();

//     final batch = _firestore.batch();
//     bool hasUpdates = false;

//     for (var doc in messages.docs) {
//       List readBy = doc.data()['readBy'] ?? [];
//       if (!readBy.contains(uid)) {
//         batch.update(doc.reference, {
//           'readBy': FieldValue.arrayUnion([uid])
//         });
//         hasUpdates = true;
//       }
//     }

//     if (hasUpdates) await batch.commit();
    
//     await _firestore.collection('chats').doc(chatId).update({
//       'lastSeen.$uid': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> setTyping(String chatId, bool isTyping) async {
//     final uid = getCurrentUserId();
//     await _firestore.collection('chats').doc(chatId).update({
//       'typingUsers': isTyping 
//           ? FieldValue.arrayUnion([uid]) 
//           : FieldValue.arrayRemove([uid])
//     });
//   }
// }// services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'dart:async';

import 'package:dating/services/auth_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

    final authService = AuthService();

  /// Generates a unique, deterministic Chat ID between two users
  String generateChatId(String id1, String id2) {
    if (id1.isEmpty || id2.isEmpty) return 'invalid_chat_id';
    List<String> ids = [id1, id2];
    ids.sort(); // Sorting ensures the ID is the same regardless of who starts the chat
    return 'chat_${ids.join("_")}';
  }

  /// Creates a chat room if it doesn't exist.
  /// Includes retry logic to handle [cloud_firestore/unavailable]
  Future<String> getOrCreateChatRoom(
    String user1Id, 
    String user2Id,
    String user1Name,
    String user2Name,
    String user1Photo,
    String user2Photo,
  ) async {
    // Safety check for empty IDs
    if (user1Id.isEmpty || user2Id.isEmpty) {
      throw Exception("User IDs cannot be empty");
    }

    String chatId = generateChatId(user1Id, user2Id);
    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final chatRef = _firestore.collection('chats').doc(chatId);
        final chatDoc = await chatRef.get().timeout(const Duration(seconds: 8));

        if (!chatDoc.exists) {
          await chatRef.set({
            'participants': [user1Id, user2Id],
            'participantNames': {
              user1Id: user1Name,
              user2Id: user2Name,
            },
            'participantPhotos': {
              user1Id: user1Photo,
              user2Id: user2Photo,
            },
            'createdAt': FieldValue.serverTimestamp(),
            'lastMessage': 'Matched! Say hi 👋',
            'lastMessageTime': FieldValue.serverTimestamp(),
            'lastMessageSender': '',
            'chatId': chatId,
            'typingUsers': [],
            'lastSeen': {
              user1Id: FieldValue.serverTimestamp(),
              user2Id: FieldValue.serverTimestamp(),
            }
          });
        }
        return chatId;
      } catch (e) {
        retryCount++;
        log("Firestore connection attempt $retryCount failed: $e");
        if (retryCount >= maxRetries) rethrow;
        await Future.delayed(Duration(seconds: retryCount)); // Exponential backoff
      }
    }
    return chatId;
  }

  /// Sends a message and updates the chat summary in one operation
  Future<void> sendMessage(String chatId, String text) async {

      final uid = await authService.getUserId();
    if ( chatId.isEmpty || text.trim().isEmpty) return;

    try {
      final batch = _firestore.batch();
      
      // 1. Create message document
      final msgRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(); // Auto-generated ID

      batch.set(msgRef, {
        'senderId': uid,
        'text': text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
        'readBy': [uid],
        'isDeleted': false,
      });

      // 2. Update chat root info
      final chatRef = _firestore.collection('chats').doc(chatId);
      batch.update(chatRef, {
        'lastMessage': text.trim(),
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSender': uid,
      });

      await batch.commit();
    } catch (e) {
      log("Error sending message: $e");
    }
  }

  /// Stream of messages for a specific chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Stream of chat metadata (typing status, last message, etc.)
  Stream<DocumentSnapshot> getChatInfo(String chatId) {
    return _firestore.collection('chats').doc(chatId).snapshots();
  }

  /// Updates the 'readBy' array for all unread messages and updates user's last seen
  Future<void> markMessagesAsRead(String chatId) async {
      final uid = await authService.getUserId();
    
    // SAFETY GUARD: Prevent FieldPath error (ending with dot)
    if ( chatId.isEmpty) {
      log("Skipping markMessagesAsRead: UID or ChatId is empty");
      return;
    }

    try {
      // 1. Get messages that I haven't read yet
      final unreadQuery = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      final batch = _firestore.batch();
      bool hasUpdates = false;

      for (var doc in unreadQuery.docs) {
        final data = doc.data();
        List readBy = data['readBy'] ?? [];
        if (!readBy.contains(uid)) {
          batch.update(doc.reference, {
            'readBy': FieldValue.arrayUnion([uid])
          });
          hasUpdates = true;
        }
      }

      if (hasUpdates) {
        await batch.commit();
      }
      
      // 2. Update last seen timestamp with safe path string
      final String lastSeenPath = 'lastSeen.$uid';
      await _firestore.collection('chats').doc(chatId).update({
        lastSeenPath: FieldValue.serverTimestamp(),
      });
      
    } catch (e) {
      log("Error in markMessagesAsRead: $e");
    }
  }

  /// Toggles the typing indicator for the current user
  Future<void> setTyping(String chatId, bool isTyping) async {
      final uid = await authService.getUserId();
    if ( chatId.isEmpty) return;

    try {
      await _firestore.collection('chats').doc(chatId).update({
        'typingUsers': isTyping 
            ? FieldValue.arrayUnion([uid]) 
            : FieldValue.arrayRemove([uid])
      });
    } catch (e) {
      log("Error updating typing status: $e");
    }
  }

  /// Soft deletes a message
  Future<void> deleteMessage(String chatId, String messageId) async {
    if (chatId.isEmpty || messageId.isEmpty) return;
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
            'text': 'This message was deleted',
            'isDeleted': true,
          });
    } catch (e) {
      log("Error deleting message: $e");
    }
  }
}