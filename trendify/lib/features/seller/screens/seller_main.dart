import 'package:flutter/material.dart';
import 'package:trendify/features/seller/widgets/seller_drawer.dart';
import 'package:trendify/features/seller/widgets/seller_bottom_nav.dart';
import 'package:trendify/features/seller/screens/seller_add_product.dart';
import 'package:trendify/features/seller/screens/seller_orders.dart';
// Note: additional seller screens are registered in routes and can be
// navigated to; imports below are removed to avoid unused-import warnings.

class SellerMain extends StatefulWidget {
  const SellerMain({super.key});

  @override
  State<SellerMain> createState() => _SellerMainState();
}

class _SellerMainState extends State<SellerMain> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    Center(child: Text('Seller Dashboard')),
    SellerOrders(),
    SellerAddProduct(),
    Center(child: Text('Seller Analytics')),
    Center(child: Text('Seller Profile')),
  ];

  void _onTabTapped(int idx) {
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller Panel')),
      drawer: const SellerDrawer(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: SellerBottomNav(
        selectedIndex: _selectedIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
