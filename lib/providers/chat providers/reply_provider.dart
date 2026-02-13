import 'package:dating/models/message_models.dart';
import 'package:flutter/material.dart';

class ReplyProvider with ChangeNotifier {
  MessageModel? _replyMessage;
  String? _selectedMessageId;
  Map<String, List<Map<String, dynamic>>> _messageReactions = {};

  MessageModel? get replyMessage => _replyMessage;
  String? get selectedMessageId => _selectedMessageId;
  Map<String, List<Map<String, dynamic>>> get messageReactions => _messageReactions;

  void setReply(MessageModel message) {
    _replyMessage = message;
    notifyListeners();
  }

  void clearReply() {
    _replyMessage = null;
    notifyListeners();
  }

  void selectMessage(String messageId) {
    _selectedMessageId = messageId;
    notifyListeners();
  }

  void clearSelectedMessage() {
    _selectedMessageId = null;
    notifyListeners();
  }

  void addReaction(String messageId, String userId, String reaction) {
    if (!_messageReactions.containsKey(messageId)) {
      _messageReactions[messageId] = [];
    }
    
    // Remove existing reaction from same user
    _messageReactions[messageId]!.removeWhere((r) => r['userId'] == userId);
    
    // Add new reaction
    _messageReactions[messageId]!.add({
      'userId': userId,
      'reaction': reaction,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    notifyListeners();
  }

  void removeReaction(String messageId, String userId) {
    if (_messageReactions.containsKey(messageId)) {
      _messageReactions[messageId]!.removeWhere((r) => r['userId'] == userId);
      notifyListeners();
    }
  }

  List<String> getReactionsForMessage(String messageId) {
    if (!_messageReactions.containsKey(messageId)) return [];
    return _messageReactions[messageId]!
        .map((r) => r['reaction'] as String)
        .toList();
  }
}