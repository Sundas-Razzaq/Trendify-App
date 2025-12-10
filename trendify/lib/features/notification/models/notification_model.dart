import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String senderId;
  final String receiverId;
  final String type;
  final DateTime? timestamp;
  final bool isRead;
  final bool isSeen;
  final String? parentId;
  final bool isReply;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.senderId,
    required this.receiverId,
    required this.type,
    this.timestamp,
    this.isRead = false,
    this.isSeen = false,
    this.parentId,
    this.isReply = false,
  });

  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    DateTime? ts;
    final v = map['timestamp'];
    if (v is Timestamp) ts = v.toDate();
    if (v is DateTime) ts = v;

    return NotificationModel(
      id: id,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      receiverId: map['receiverId'] as String? ?? '',
      type: map['type'] as String? ?? 'generic',
      timestamp: ts,
      isRead: map['isRead'] as bool? ?? false,
      isSeen: map['isSeen'] as bool? ?? false,
      parentId: map['parentId'] as String?,
      isReply: map['isReply'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type,
      'timestamp': timestamp != null
          ? Timestamp.fromDate(timestamp!)
          : FieldValue.serverTimestamp(),
      'isRead': isRead,
      'isSeen': isSeen,
      'parentId': parentId,
      'isReply': isReply,
    };
  }

  static String collectionPath(String userId) => 'users/$userId/notifications';
}
