import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendify/utils/constants/sizes.dart';
import 'package:trendify/utils/constants/image_strings.dart';
import 'package:trendify/features/profile/screens/profile_screen.dart';

class HomeAppBar extends StatefulWidget {
  final VoidCallback? onMenuPressed;
  const HomeAppBar({super.key, this.onMenuPressed});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString("profile_image_path");

    if (path != null && File(path).existsSync()) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  Future<void> _openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
    _loadProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.defaultSpace,
      ),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Menu Icon
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87, size: 28),
            onPressed: widget.onMenuPressed,
          ),

          // Center Logo
          Expanded(
            child: Center(
              child: Image.asset(
                TImages.appLogo,
                width: 140,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // ignore: avoid_print
                  print('Failed to load app logo asset: $error');
                  return const SizedBox(
                    width: 140,
                    height: 60,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          GestureDetector(
            onTap: _openProfile,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: _imagePath != null
                  ? FileImage(File(_imagePath!))
                  : null,
              // When no file image is available, render the bundled default
              // avatar via Image.asset so we can show an errorBuilder fallback.
              child: _imagePath == null
                  ? ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          'assets/images/default_avatar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // ignore: avoid_print
                            print(
                              'Failed to load default avatar asset: $error',
                            );
                            return const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
