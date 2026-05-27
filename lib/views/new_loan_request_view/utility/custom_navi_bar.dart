import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Bottom nav bar like the screenshot:
/// - pill container
/// - 4 items with labels
/// - center floating circular "scan" button
///
/// Indices:
/// 0 = Home, 1 = Search, 2 = Center(Scan), 3 = History, 4 = Profile

// void _handleNavTap(int i) {
//   setState(() => _navIndex = i);
// }
// bottomNavigationBar: FancyBottomNavBar(
//         currentIndex: _navIndex,
//         onTap: _handleNavTap,
//         // onCenterTap: () { ... }, // optional if you want different action for center button
//       ),

class FancyBottomNavBar extends StatelessWidget {
  const FancyBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onCenterTap,
    this.activeColor = const Color(0xFF5B2DFF),
    this.inactiveColor = const Color.fromARGB(218, 63, 63, 63),
    this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),
    this.elevationShadow = const Color(0x1A000000),
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// If provided, center button will call this; otherwise it calls onTap(2).
  final VoidCallback? onCenterTap;

  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final Color elevationShadow;

  @override
  Widget build(BuildContext context) {
    const double barHeight = 92;
    const double radius = 20;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Pill background
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(radius),
                boxShadow: [
                  BoxShadow(
                    color: elevationShadow,
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    active: currentIndex == 0,
                    label: 'Home',
                    activeIcon: PhosphorIconsFill.house,
                    inactiveIcon: Iconsax.home_2_copy,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    active: currentIndex == 1,
                    label: 'Search',
                    activeIcon: PhosphorIconsFill.magnifyingGlass,
                    inactiveIcon: Iconsax.search_favorite_copy,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    onTap: () => onTap(1),
                  ),
                  const SizedBox(width: 74),
                  _NavItem(
                    active: currentIndex == 3,
                    label: 'History',
                    activeIcon: PhosphorIconsFill.clockCounterClockwise,
                    inactiveIcon: Iconsax.safe_home_copy,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    onTap: () => onTap(3),
                  ),
                  _NavItem(
                    active: currentIndex == 4,
                    label: 'Profile',
                    activeIcon: PhosphorIconsFill.user,
                    inactiveIcon: Iconsax.user_copy,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
            // Center floating circle button
            Positioned(
              bottom: barHeight - 56,
              child: _CenterScanButton(
                color: activeColor,
                onTap: onCenterTap ?? () => onTap(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.active,
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  final bool active;
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final color = active ? activeColor : inactiveColor;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(active ? activeIcon : inactiveIcon, size: 25, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterScanButton extends StatelessWidget {
  const _CenterScanButton({required this.onTap, required this.color});

  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 6),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Icon(PhosphorIconsRegular.scan, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}
