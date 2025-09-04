import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/achievment/achievment.dart';
import 'package:kanca/features/home/home.dart';
import 'package:kanca/features/profile/profile.dart';
import 'package:kanca/features/progress/progress.dart';
import 'package:kanca/features/story/story.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/l10n/l10n.dart';
import 'package:kanca/utils/utils.dart';

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
    final l10n = context.l10n;

    Widget buildItem({
      required Widget icon,
      required String label,
      required bool isActive,
      VoidCallback? onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: Column(
          children: [
            icon,
            4.vertical,
            Text(
              label,
              style: textTheme.lexendCaption.copyWith(
                color: isActive ? colors.primary[500] : colors.grey[200],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      extendBody: true,
      bottomNavigationBar: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(110),
                topRight: Radius.circular(110),
              ),
              child: BackdropFilter(
                blendMode: BlendMode.screen,
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: double.infinity,
                  height: 115,
                  decoration: BoxDecoration(
                    color: const Color(0XFFFFF9ED).withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom,
            left: 0,
            right: 0,
            child: Assets.images.bottomNavigation.svg(
              width: double.infinity,
              height: 85,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom + 37,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                context.push(const GenerateStoryPage());
              },
              child: Center(
                child: Assets.images.generateStory.image(
                  width: 67,
                  height: 67,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom + 8,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: buildItem(
                      icon: Assets.icons.home.image(
                        width: 36,
                        height: 36,
                      ),
                      label: l10n.bottomNavHomeTitle,
                      isActive: _selectedIndex == 0,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                          _pageController.jumpToPage(0);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: buildItem(
                      icon: Assets.icons.achievment.image(
                        width: 36,
                        height: 36,
                      ),
                      label: l10n.bottomNavAchievementTitle,
                      isActive: _selectedIndex == 1,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                          _pageController.jumpToPage(1);
                        });
                      },
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(), // Space for the center button
                  ),
                  Expanded(
                    child: buildItem(
                      icon: Assets.icons.progress.image(
                        width: 36,
                        height: 36,
                      ),
                      label: l10n.bottomNavProgressTitle,
                      isActive: _selectedIndex == 2,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                          _pageController.jumpToPage(2);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: buildItem(
                      icon: Assets.icons.profile.image(
                        width: 36,
                        height: 36,
                      ),
                      label: l10n.bottomNavProfileTitle,
                      isActive: _selectedIndex == 3,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                          _pageController.jumpToPage(3);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
