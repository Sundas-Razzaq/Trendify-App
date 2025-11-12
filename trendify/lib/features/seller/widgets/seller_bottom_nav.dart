import 'package:flutter/material.dart';
import 'package:trendify/utils/constants/colors.dart';

class SellerBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;
  const SellerBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  final List<_TabItem> _tabs = const [
    _TabItem(icon: Icons.home, label: 'Dashboard'),
    _TabItem(icon: Icons.inventory_2, label: 'Orders'),
    _TabItem(icon: Icons.add, label: 'Add'),
    _TabItem(icon: Icons.bar_chart, label: 'Analytics'),
    _TabItem(icon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (!selected) onTabTapped(index);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab.icon,
                    color: selected ? TColors.primary : Colors.black,
                    size: 26,
                  ),
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        tab.label,
                        style: TextStyle(
                          color: TColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}
