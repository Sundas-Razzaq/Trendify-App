class NotificationNotifier {
  const NotificationNotifier();

  /// Returns a permission status string for compatibility with web implementation.
  Future<String> requestPermission() async {
    return 'unsupported';
  }

  void showNotification(String title, {String? body}) {}
}

const NotificationNotifier notifier = NotificationNotifier();
