import 'package:flutter/material.dart';
import 'package:trendify/features/shop/screens/home/home_screen.dart';
import 'package:trendify/features/shop/screens/wishlist/wishlist_screen.dart';
import 'package:trendify/features/shop/screens/cart/cart_screen.dart';
import 'package:trendify/features/shop/screens/search/search_screen.dart';
import 'package:trendify/features/shop/screens/settings/settings_screen.dart';
import 'package:trendify/common/widgets/navigation/trendy_bottom_nav.dart';
import 'package:trendify/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:trendify/features/shop/screens/home/widgets/home_drawer.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    WishlistScreen(),
    CartScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Builder(
          builder: (context) => HomeAppBar(
            onMenuPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),

      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: TrendyBottomNav(
        selectedIndex: _selectedIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
