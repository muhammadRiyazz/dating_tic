import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dating/services/chat_service.dart';

class OnlineStatusProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final Map<String, bool> _onlineStatus = {};
  final Map<String, DateTime?> _lastSeen = {};
  StreamSubscription? _statusSubscription;
  List<String> _currentUserIds = [];

  Map<String, bool> get onlineStatus => _onlineStatus;
  Map<String, DateTime?> get lastSeen => _lastSeen;

  void startListeningToUsers(List<String> userIds) {
    // Remove duplicates
    final uniqueUserIds = userIds.toSet().toList();
    
    // Check if the list changed
    if (_currentUserIds.length == uniqueUserIds.length &&
        _currentUserIds.every((id) => uniqueUserIds.contains(id))) {
      return;
    }

    _currentUserIds = uniqueUserIds;
    
    _statusSubscription?.cancel();
    
    if (uniqueUserIds.isEmpty) return;
    
    _statusSubscription = _chatService
        .getMultipleUsersOnlineStatus(uniqueUserIds)
        .listen((statusMap) {
          bool hasChanges = false;
          
          statusMap.forEach((userId, isOnline) {
            if (_onlineStatus[userId] != isOnline) {
              _onlineStatus[userId] = isOnline;
              hasChanges = true;
            }
          });
          
          if (hasChanges) {
            notifyListeners();
          }
        });
  }

  bool isOnline(String userId) {
    return _onlineStatus[userId] ?? false;
  }

  void stopListening() {
    _statusSubscription?.cancel();
    _statusSubscription = null;
    _onlineStatus.clear();
    _currentUserIds.clear();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}