import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../utils/services/notification_service.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = NotificationService();

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat.yMMMd().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final uid = _uid;
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: const Center(child: Text('Please sign in to see notifications')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await _service.markAllAsRead(uid);
              if (mounted) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Marked all as read')),
                );
              }
            },
            child: const Text(
              'Mark all as read',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: _service.getNotificationsStream(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No notifications'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final n = items[i];
              return ListTile(
                leading: n.isRead
                    ? null
                    : const CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.red,
                      ),
                title: Text(n.title),
                subtitle: Text(n.body),
                trailing: Text(_timeAgo(n.timestamp)),
                onTap: () async {
                  await _service.markAsRead(uid, n.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
