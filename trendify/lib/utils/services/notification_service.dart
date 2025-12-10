import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_notifier.dart';
import '../../features/notification/models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  NotificationService();

  Future<void> requestPermission() async {
    try {
      final perm = await notifier.requestPermission();
      // ignore: avoid_print
      print('🔔 Browser permission: $perm');
    } catch (e, st) {
      // ignore: avoid_print
      print('🔔 requestPermission error: $e\n$st');
    }
  }

  Future<void> sendNotification({
    required String receiverId,
    required String title,
    required String body,
    String type = 'generic',
    String? parentId,
    bool isReply = false,
  }) async {
    final sender = _auth.currentUser?.uid ?? 'system';
    final path = NotificationModel.collectionPath(receiverId);
    final col = _firestore.collection(path);
    final doc = col.doc();
    final model = NotificationModel(
      id: doc.id,
      title: title,
      body: body,
      senderId: sender,
      receiverId: receiverId,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
      isSeen: false,
      parentId: parentId,
      isReply: isReply,
    );
    final data = model.toMap();
    try {
      await doc.set(data);
      // ignore: avoid_print
      print('🔔 Notification sent to $receiverId');
      // ignore: avoid_print
      print('🔔 Firestore document created at ${col.path}/${doc.id}');

      // show browser popup when possible
      try {
        notifier.showNotification(title, body: body);
      } catch (e, st) {
        // ignore: avoid_print
        print('🔔 showNotification error: $e\n$st');
      }
    } catch (e, st) {
      // ignore: avoid_print
      print('🔔 sendNotification failed: $e\n$st');
      rethrow;
    }
  }

  Stream<List<NotificationModel>> getNotificationsStream(String userId) {
    final path = NotificationModel.collectionPath(userId);
    final col = _firestore
        .collection(path)
        .orderBy('timestamp', descending: true);
    return col.snapshots().map((snap) {
      return snap.docs
          .map((d) => NotificationModel.fromMap(d.id, d.data()))
          .toList();
    });
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    final path = NotificationModel.collectionPath(userId);
    final doc = _firestore.collection(path).doc(notificationId);
    await doc.update({'isRead': true, 'isSeen': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final path = NotificationModel.collectionPath(userId);
    final col = _firestore.collection(path).where('isRead', isEqualTo: false);
    final snap = await col.get();
    final batch = _firestore.batch();
    for (final d in snap.docs) {
      batch.update(d.reference, {'isRead': true, 'isSeen': true});
    }
    await batch.commit();
  }
}
