import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/chat/chat.dart';
import 'package:kanca/features/progress/progress.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/utils.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  Timer? _scrollTimer;

  // Dummy data for moral values
  final List<Map<String, String>> moralValuesData = const [
    {
      'level': 'Expert',
      'values': 'Honesty, Responsibility, Integrity, Leadership',
    },
    {
      'level': 'Advanced',
      'values': 'Teamwork, Empathy, Perseverance, Creativity',
    },
    {
      'level': 'Intermediate',
      'values': 'Respect, Kindness, Patience, Cooperation',
    },
    {
      'level': 'Beginner',
      'values': 'Sharing, Helping Others, Gratitude, Fairness',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation =
        Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _fabAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    _scrollController.addListener(_onScroll);
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fabAnimationController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    // Hide FAB when scrolling
    if (_fabAnimationController.status != AnimationStatus.reverse &&
        _fabAnimationController.status != AnimationStatus.dismissed) {
      _fabAnimationController.reverse();
    }

    // Cancel previous timer
    _scrollTimer?.cancel();

    // Show FAB after user stops scrolling for 1 second
    _scrollTimer = Timer(const Duration(seconds: 1), () {
      if (_fabAnimationController.status != AnimationStatus.forward &&
          _fabAnimationController.status != AnimationStatus.completed) {
        _fabAnimationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.only(
          left: 24,
          top: MediaQuery.of(context).viewPadding.top + 24,
          right: 24,
          bottom: 150,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.mascots.progressBanner.image(width: double.infinity),
            16.vertical,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ProgressCardWidget(
                    icon: Assets.icons.playingDuration.image(
                      width: 40,
                      height: 40,
                    ),
                    value: '30m',
                    label: 'Playing\nDuration',
                  ),
                ),
                12.horizontal,
                Expanded(
                  child: ProgressCardWidget(
                    icon: Assets.icons.completedStory.image(
                      width: 40,
                      height: 40,
                    ),
                    value: '12',
                    label: 'Completed\nStory',
                  ),
                ),
                12.horizontal,
                Expanded(
                  child: ProgressCardWidget(
                    icon: Assets.icons.successRate.image(
                      width: 40,
                      height: 40,
                    ),
                    value: '90%',
                    label: 'Success\nRate',
                  ),
                ),
              ],
            ),
            16.vertical,
            Text(
              'Playing Minutes',
              style: textTheme.h5.copyWith(
                color: colors.grey[700],
              ),
            ),
            8.vertical,
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: colors.neutral[100],
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            16.vertical,
            Text(
              'Success Rate',
              style: textTheme.h5.copyWith(
                color: colors.grey[700],
              ),
            ),
            8.vertical,
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: colors.neutral[100],
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            16.vertical,
            Text(
              'Moral Values',
              style: textTheme.h5.copyWith(
                color: colors.grey[700],
              ),
            ),
            8.vertical,
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: moralValuesData.length,
              itemBuilder: (context, index) {
                final moralValue = moralValuesData[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < moralValuesData.length - 1 ? 12 : 0,
                  ),
                  child: MoralValuesCardWidget(
                    level: moralValue['level']!,
                    values: moralValue['values']!,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: Opacity(
              opacity: _fabAnimation.value,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 110, right: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    context.push(const ChatPage());
                  },
                  child: Assets.mascots.helpCenter.image(
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
