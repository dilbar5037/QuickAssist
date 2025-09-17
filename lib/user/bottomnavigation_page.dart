import 'package:flutter/material.dart';

import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/user/homePage.dart';
import 'package:quickassitnew/user/mybookings.dart';
import 'package:quickassitnew/user/profilepage.dart';
import 'package:quickassitnew/user/settings_page.dart';

class BottomNavigationPage extends StatefulWidget {
  final dynamic data;
  const BottomNavigationPage({super.key, this.data});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<_BottomNavDestination> _destinations = const [
    _BottomNavDestination(icon: Icons.home, label: 'Home'),
    _BottomNavDestination(icon: Icons.bookmark, label: 'Bookings'),
    _BottomNavDestination(icon: Icons.settings, label: 'Settings'),
    _BottomNavDestination(icon: Icons.person, label: 'Profile'),
  ];

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      const Homepage(),
      MyBookings(),
      const Settingpage(),
      ProfilePage(data: widget.data),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 20,
      ),
      bottomNavigationBar: _QuickAssistBottomNavBar(
        destinations: _destinations,
        currentIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}

class _QuickAssistBottomNavBar extends StatelessWidget {
  const _QuickAssistBottomNavBar({
    required this.destinations,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final List<_BottomNavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color inactiveColor =
        theme.iconTheme.color?.withOpacity(0.6) ?? Colors.grey.shade500;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: List.generate(destinations.length, (index) {
              final destination = destinations[index];
              final bool isActive = index == currentIndex;
              final Color iconColor =
                  isActive ? AppColors.contColor5 : inactiveColor;

              return Expanded(
                child: _BottomNavItem(
                  icon: destination.icon,
                  label: destination.label,
                  isActive: isActive,
                  iconColor: iconColor,
                  onTap: () => onItemSelected(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: label,
      selected: isActive,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isActive
                ? AppColors.contColor5.withOpacity(0.12)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 26,
                color: iconColor,
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 4,
                width: isActive ? 20 : 8,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.contColor5 : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavDestination {
  const _BottomNavDestination({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}
