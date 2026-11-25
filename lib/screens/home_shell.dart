import 'package:flutter/material.dart';

import '../theme/brand.dart';

/// The 4 tabs and the bottom tab bar. For now each tab is a placeholder;
/// Round 5 swaps in the real screens.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  void _go(int i) => setState(() => _tab = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [
          _ComingSoon('Today'),
          _ComingSoon('Pond'),
          _ComingSoon('Shop'),
          _ComingSoon('Stats'),
        ],
      ),
      bottomNavigationBar: _NavBar(index: _tab, onTap: _go),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          '$title\ncoming soon',
          textAlign: TextAlign.center,
          style: Brand.display(26, color: Brand.inkSoft),
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.water_drop_rounded, 'Today'),
    (Icons.waves_rounded, 'Pond'),
    (Icons.storefront_rounded, 'Shop'),
    (Icons.bar_chart_rounded, 'Stats'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Brand.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Brand.radiusL),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x141C64D8),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final (i, (icon, label)) in _items.indexed)
                _NavItem(
                  icon: icon,
                  label: label,
                  selected: i == index,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: Brand.medium,
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: selected ? 16 : 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: selected ? Brand.foam : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: selected ? Brand.water : Brand.inkSoft,
                  size: 24,
                ),
                AnimatedSize(
                  duration: Brand.medium,
                  curve: Curves.easeOutCubic,
                  child: selected
                      ? Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            label,
                            style: Brand.display(15, color: Brand.water),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}