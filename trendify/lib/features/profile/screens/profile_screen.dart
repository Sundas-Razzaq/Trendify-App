import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _imageData; // stores base64 or file path
  final String _prefsKey = 'profile_image_data';

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageData = prefs.getString(_prefsKey);
    });
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          // Convert web image to base64
          final bytes = await pickedFile.readAsBytes();
          _imageData = base64Encode(bytes);
        } else {
          // Save file path for mobile
          _imageData = pickedFile.path;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_prefsKey, _imageData!);

        setState(() {});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile image updated ✅")),
          );
        }
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  ImageProvider _getImageProvider() {
    if (_imageData == null) {
      return const AssetImage('assets/images/default_avatar.png');
    }

    if (kIsWeb) {
      return MemoryImage(base64Decode(_imageData!));
    } else {
      return FileImage(File(_imageData!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _getImageProvider(),
              ),
            ),
            const SizedBox(height: 12),
            const Text("Tap to change profile picture"),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid == null) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Not signed in')),
                    );
                  }
                  return;
                }
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await NotificationService().sendNotification(
                    receiverId: uid,
                    title: 'Test Notification',
                    body: 'This is a test notification sent to you.',
                  );
                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Test notification sent')),
                  );
                } catch (e) {
                  debugPrint('Failed to send test notification: $e');
                  if (!mounted) return;
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Failed to send notification'),
                    ),
                  );
                }
              },
              child: const Text('Send Test Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
