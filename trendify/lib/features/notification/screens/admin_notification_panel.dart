import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/services/notification_service.dart';

class AdminNotificationPanel extends StatefulWidget {
  const AdminNotificationPanel({super.key});

  @override
  State<AdminNotificationPanel> createState() => _AdminNotificationPanelState();
}

class _AdminNotificationPanelState extends State<AdminNotificationPanel> {
  final _formKey = GlobalKey<FormState>();
  final _userIdCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _loading = false;
  String? _currentUid;

  @override
  void initState() {
    super.initState();
    // Get initial user
    _currentUid = FirebaseAuth.instance.currentUser?.uid;

    // Listen for auth changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        setState(() {
          _currentUid = user?.uid;
        });
      }
    });
  }

  @override
  void dispose() {
    _userIdCtrl.dispose();
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    // Validate form
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);
    print('🚀 Attempting to send notification...');

    try {
      final receiverId = _userIdCtrl.text.trim();
      final title = _titleCtrl.text.trim();
      final body = _bodyCtrl.text.trim();

      print('📤 Sending to: $receiverId');
      print('📝 Title: $title');
      print('📄 Body: $body');

      await NotificationService().sendNotification(
        receiverId: receiverId,
        title: title,
        body: body,
      );

      print('✅ Notification sent successfully!');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Notification sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear only title and body, keep receiver ID for multiple sends
      _titleCtrl.clear();
      _bodyCtrl.clear();
    } catch (e) {
      print('❌ ERROR sending notification: $e');
      print('📋 Full error: ${e.toString()}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _sendToMyself() {
    if (_currentUid != null) {
      _userIdCtrl.text = _currentUid!;

      // Auto-fill test values
      if (_titleCtrl.text.isEmpty) {
        _titleCtrl.text = 'Test Notification';
      }
      if (_bodyCtrl.text.isEmpty) {
        _bodyCtrl.text = 'Sent at ${DateTime.now().toString()}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Receiver ID set to yourself')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Send Notification'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current User ID Card
            Card(
              color: Colors.blueGrey[50],
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Current User ID:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _currentUid ?? 'Not signed in',
                            style: const TextStyle(
                              fontSize: 10,
                              fontFamily: 'monospace',
                              color: Colors.blueGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          tooltip: 'Copy User ID',
                          onPressed: _currentUid == null
                              ? null
                              : () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: _currentUid!),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '📋 User ID copied to clipboard',
                                      ),
                                    ),
                                  );
                                },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Send to Myself Button
            ElevatedButton.icon(
              onPressed: _currentUid == null ? null : _sendToMyself,
              icon: const Icon(Icons.person),
              label: const Text('Send to Myself'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
                foregroundColor: Colors.blue[800],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Notification Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Receiver ID Field
                  TextFormField(
                    controller: _userIdCtrl,
                    decoration: InputDecoration(
                      labelText: 'Receiver User ID',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Paste user ID here...',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a User ID';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Title Field
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Notification Title',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter notification title...',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Body Field
                  TextFormField(
                    controller: _bodyCtrl,
                    decoration: InputDecoration(
                      labelText: 'Notification Message',
                      prefixIcon: const Icon(Icons.message),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter notification message...',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a message';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Send Button
                  ElevatedButton(
                    onPressed: _loading ? null : _send,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send),
                              SizedBox(width: 8),
                              Text(
                                'Send Notification',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Debug Info
                  if (_loading) ...[
                    const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Sending notification...',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
