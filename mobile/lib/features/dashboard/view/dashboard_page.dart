import 'package:flutter/material.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/achievment/achievment.dart';
import 'package:kanca/features/home/home.dart';
import 'package:kanca/features/profile/profile.dart';
import 'package:kanca/features/progress/progress.dart';
import 'package:kanca/gen/assets.gen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = const [
    HomePage(),
    AchievmentPage(),
    ProgressPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    BottomNavigationBarItem buildItem({
      required Widget icon,
      required String label,
      required bool isActive,
    }) {
      return BottomNavigationBarItem(
        icon: icon,
        label: label,
      );
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colors.primary[500],
        unselectedItemColor: colors.grey[500],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: textTheme.lexendCaption.copyWith(
          color: colors.primary[500],
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: textTheme.lexendCaption.copyWith(
          color: colors.grey[200],
          fontWeight: FontWeight.w500,
        ),
        selectedFontSize: 12,
        items: [
          buildItem(
            icon: Assets.icons.home.image(
              width: 32,
              height: 32,
            ),
            label: 'Beranda',
            isActive: _selectedIndex == 0,
          ),
          buildItem(
            icon: Assets.icons.achievment.image(
              width: 32,
              height: 32,
            ),
            label: 'Prestasi',
            isActive: _selectedIndex == 1,
          ),
          buildItem(
            icon: Assets.icons.progress.image(
              width: 32,
              height: 32,
            ),
            label: 'Langkah',
            isActive: _selectedIndex == 2,
          ),
          buildItem(
            icon: Assets.icons.profile.image(
              width: 32,
              height: 32,
            ),
            label: 'Profil',
            isActive: _selectedIndex == 3,
          ),
        ],
      ),
    );
  }
}
