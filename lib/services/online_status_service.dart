import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/services/auth_service.dart';

class OnlineStatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  
  // Stream to listen to online status changes for multiple users
  Stream<Map<String, bool>> getOnlineStatusStream(List<String> userIds) {
    if (userIds.isEmpty) return Stream.value({});
    
    // Create a stream that combines status for all users
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
  
  // Get single user online status stream
  Stream<bool> getUserOnlineStatus(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data()?['online'] ?? false);
  }
  
  // Update last seen timestamp
  Future<void> updateLastSeen(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }
  
  // Get user's last seen
  Future<DateTime?> getLastSeen(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    final timestamp = doc.data()?['lastSeen'] as Timestamp?;
    return timestamp?.toDate();
  }
  
  // Update online status
  Future<void> updateOnlineStatus(bool isOnline) async {
    final uid = await _authService.getUId();
    if (uid != null) {
      await _firestore.collection('users').doc(uid).set({
        'online': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}