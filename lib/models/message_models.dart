import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  video,
  audio,
  location,
  document,
  viewOnce,
  reply
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  error
}

class MessageModel {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final MessageStatus status;
  final MessageType type;
  final List<String> mediaUrls;
  final Map<String, dynamic>? metadata;
  final String? replyToId;
  final MessageModel? replyToMessage;
  final bool isDeleted;
  final bool isForwarded;
  final List<Map<String, dynamic>> reactions;
  final Map<String, dynamic>? viewOnceData;
  final double? uploadProgress;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.status,
    required this.type,
    this.mediaUrls = const [],
    this.metadata,
    this.replyToId,
    this.replyToMessage,
    this.isDeleted = false,
    this.isForwarded = false,
    this.reactions = const [],
    this.viewOnceData,
    this.uploadProgress,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.name,
      'type': type.name,
      'mediaUrls': mediaUrls,
      'metadata': metadata,
      'replyToId': replyToId,
      'isDeleted': isDeleted,
      'isForwarded': isForwarded,
      'reactions': reactions,
      'viewOnceData': viewOnceData,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map, {MessageModel? replyTo}) {
    return MessageModel(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => MessageStatus.sent,
      ),
      type: MessageType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => MessageType.text,
      ),
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      metadata: map['metadata'],
      replyToId: map['replyToId'],
      replyToMessage: replyTo,
      isDeleted: map['isDeleted'] ?? false,
      isForwarded: map['isForwarded'] ?? false,
      reactions: List<Map<String, dynamic>>.from(map['reactions'] ?? []),
      viewOnceData: map['viewOnceData'],
    );
  }

  MessageModel copyWith({
    String? messageId,
    String? senderId,
    String? receiverId,
    String? text,
    DateTime? timestamp,
    MessageStatus? status,
    MessageType? type,
    List<String>? mediaUrls,
    Map<String, dynamic>? metadata,
    String? replyToId,
    MessageModel? replyToMessage,
    bool? isDeleted,
    bool? isForwarded,
    List<Map<String, dynamic>>? reactions,
    Map<String, dynamic>? viewOnceData,
    double? uploadProgress,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      type: type ?? this.type,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      metadata: metadata ?? this.metadata,
      replyToId: replyToId ?? this.replyToId,
      replyToMessage: replyToMessage ?? this.replyToMessage,
      isDeleted: isDeleted ?? this.isDeleted,
      isForwarded: isForwarded ?? this.isForwarded,
      reactions: reactions ?? this.reactions,
      viewOnceData: viewOnceData ?? this.viewOnceData,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}