import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/colors.dart';

class TrendyBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;
  const TrendyBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  final List<_NavTab> _tabs = const [
    _NavTab(icon: Icons.home, label: 'Home', route: '/home'),
    _NavTab(icon: Icons.favorite_border, label: 'Wishlist', route: '/wishlist'),
    _NavTab(icon: Icons.shopping_cart, label: '', route: '/cart', isCart: true),
    _NavTab(icon: Icons.search, label: 'Search', route: '/search'),
    _NavTab(icon: Icons.settings, label: 'Setting', route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabs.length, (index) {
          final tab = _tabs[index];
          final selected = selectedIndex == index;

          if (tab.isCart) {
            // Center floating cart icon
            return GestureDetector(
              onTap: () {
                if (selectedIndex != index) onTabTapped(index);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                child: Material(
                  elevation: 8,
                  shape: const CircleBorder(),
                  color: Colors.white,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        tab.icon,
                        color: selected ? TColors.primary : Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Regular tab icon
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (selectedIndex != index) onTabTapped(index);
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.icon,
                      color: selected ? TColors.primary : Colors.black,
                      size: 28,
                    ),
                    if (selected)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          tab.label,
                          style: TextStyle(
                            color: TColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class _NavTab {
  final IconData icon;
  final String label;
  final String route;
  final bool isCart;
  const _NavTab({
    required this.icon,
    required this.label,
    required this.route,
    this.isCart = false,
  });
}
