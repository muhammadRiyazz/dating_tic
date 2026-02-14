import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, video, audio, location, document, viewOnce }
enum MessageStatus { sending, sent, delivered, read, error }

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
  final bool isForwarded;
  final bool isDeleted;
  final double? uploadProgress; // 0.0-1.0, only for sending
  final Map<String, dynamic>? viewOnceData;
  final List<Reaction> reactions;
  final Map<String, DeliveryReceipt>? deliveryReceipts; // per user

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
    this.isForwarded = false,
    this.isDeleted = false,
    this.uploadProgress,
    this.viewOnceData,
    this.reactions = const [],
    this.deliveryReceipts,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'sending'),
        orElse: () => MessageStatus.sent,
      ),
      type: MessageType.values.firstWhere(
        (e) => e.name == (map['type'] ?? 'text'),
      ),
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      metadata: map['metadata'] as Map<String, dynamic>?,
      replyToId: map['replyToId'],
      isForwarded: map['isForwarded'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      uploadProgress: map['uploadProgress']?.toDouble(),
      viewOnceData: map['viewOnceData'] as Map<String, dynamic>?,
      reactions: (map['reactions'] as List? ?? [])
          .map((r) => Reaction.fromMap(r))
          .toList(),
      deliveryReceipts: map['deliveryReceipts'] != null
          ? Map.fromEntries(
              (map['deliveryReceipts'] as Map<String, dynamic>).entries.map(
                (e) => MapEntry(e.key, DeliveryReceipt.fromMap(e.value)),
              ),
            )
          : null,
    );
  }

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
      'isForwarded': isForwarded,
      'isDeleted': isDeleted,
      'uploadProgress': uploadProgress,
      'viewOnceData': viewOnceData,
      'reactions': reactions.map((r) => r.toMap()).toList(),
      'deliveryReceipts': deliveryReceipts?.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
    };
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
    bool? isForwarded,
    bool? isDeleted,
    double? uploadProgress,
    Map<String, dynamic>? viewOnceData,
    List<Reaction>? reactions,
    Map<String, DeliveryReceipt>? deliveryReceipts,
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
      isForwarded: isForwarded ?? this.isForwarded,
      isDeleted: isDeleted ?? this.isDeleted,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      viewOnceData: viewOnceData ?? this.viewOnceData,
      reactions: reactions ?? this.reactions,
      deliveryReceipts: deliveryReceipts ?? this.deliveryReceipts,
    );
  }
}

class Reaction {
  final String userId;
  final String reaction;
  final DateTime timestamp;

  Reaction({
    required this.userId,
    required this.reaction,
    required this.timestamp,
  });

  factory Reaction.fromMap(Map<String, dynamic> map) {
    return Reaction(
      userId: map['userId'] ?? '',
      reaction: map['reaction'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'reaction': reaction,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class DeliveryReceipt {
  final DateTime? deliveredAt;
  final DateTime? readAt;

  DeliveryReceipt({this.deliveredAt, this.readAt});

  factory DeliveryReceipt.fromMap(Map<String, dynamic> map) {
    return DeliveryReceipt(
      deliveredAt: (map['deliveredAt'] as Timestamp?)?.toDate(),
      readAt: (map['readAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deliveredAt': deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
    };
  }
}