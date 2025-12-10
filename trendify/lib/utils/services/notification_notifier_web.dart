// This file intentionally uses `dart:html` for web notifications.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

class NotificationNotifier {
  const NotificationNotifier();

  Future<String> requestPermission() async {
    try {
      final res = await html.Notification.requestPermission();
      // ignore: avoid_print
      print('🔔 Browser permission: $res');
      return res;
    } catch (e, st) {
      // Log permission errors
      // ignore: avoid_print
      print('Notification permission error: $e\n$st');
      return 'error';
    }
  }

  void showNotification(String title, {String? body}) {
    try {
      if (html.Notification.permission == 'granted') {
        html.Notification(title, body: body);
      } else {
        // ignore: avoid_print
        print(
          '🔔 Browser notification not shown - permission: ${html.Notification.permission}',
        );
      }
    } catch (e, st) {
      // Log notification errors
      // ignore: avoid_print
      print('Failed to show browser notification: $e\n$st');
    }
  }
}

const NotificationNotifier notifier = NotificationNotifier();
