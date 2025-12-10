// Conditional export: re-export web implementation when running on web, otherwise stub.
export 'notification_notifier_stub.dart'
    if (dart.library.html) 'notification_notifier_web.dart';
