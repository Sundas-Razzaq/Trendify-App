import 'package:trendify/features/shop/screens/home/widgets/category_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [CategorySection(), SizedBox(height: 24)],
      ),
    );
  }
}
