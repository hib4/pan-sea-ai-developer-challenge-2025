import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/story/bloc/story_bloc.dart';
import 'package:kanca/features/story/story.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/utils.dart';

class GenerateStoryLoadingPage extends StatefulWidget {
  const GenerateStoryLoadingPage({super.key});

  @override
  State<GenerateStoryLoadingPage> createState() =>
      _GenerateStoryLoadingPageState();
}

class _GenerateStoryLoadingPageState extends State<GenerateStoryLoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Timer _captionTimer;
  int _currentCaptionIndex = 0;

  final List<String> _loadingCaptions = [
    'Creating your magical story...',
    'Generating beautiful illustrations...',
    'Adding voice narration...',
    'Crafting moral lessons...',
    'Building interactive choices...',
    'Polishing your adventure...',
    'Almost ready for you!',
    'Adding final touches...',
    'Preparing your journey...',
    'Making it perfect...',
    'Just a few more seconds...',
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startCaptionCycle();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController.forward();
  }

  void _startCaptionCycle() {
    _captionTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        setState(() {
          if (_currentCaptionIndex < _loadingCaptions.length - 1) {
            _currentCaptionIndex++;
          } else {
            // Stop the timer when we reach the last caption
            timer.cancel();
            return;
          }
        });
        _fadeController.reset();
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _captionTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return BlocListener<StoryBloc, StoryState>(
      listener: (context, state) {
        state.story.whenOrNull(
          data: (story) {
            if (mounted) {
              context.pushReplacement(StoryPage(story: story));
            }
          },
          error: (error) {
            logger.e(error);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    error,
                    style: context.textTheme.lexendBody.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: context.colors.primary[500],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
            context.pop();
          },
        );
      },
      child: Scaffold(
        backgroundColor: colors.neutral[500],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Animated mascot with smooth up and down animation
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        7 * _animationController.value,
                      ),
                      child: Assets.mascots.thinking.image(
                        width: 120,
                        height: 150,
                      ),
                    );
                  },
                ),

                32.vertical,

                // Main loading text with consistent design
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.primary[200]!,
                      width: 1.5,
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: textTheme.h5.copyWith(
                        color: colors.grey[500],
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      text: 'Please wait... ',
                      children: [
                        TextSpan(
                          text: 'Get ready for an exciting adventure!',
                          style: TextStyle(
                            color: colors.primary[500],
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                24.vertical,

                // Animated caption with swipe-up animation
                Container(
                  height: 70,
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 1.0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                              child: child,
                            ),
                          );
                        },
                    child: Container(
                      key: ValueKey<int>(_currentCaptionIndex),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colors.secondary[400]!.withOpacity(0.15),
                            colors.primary[400]!.withOpacity(0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colors.primary[300]!,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary[200]!.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colors.primary[500]!,
                                  colors.secondary[500]!,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colors.primary[300]!.withOpacity(0.5),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          16.horizontal,
                          Flexible(
                            child: Text(
                              _loadingCaptions[_currentCaptionIndex],
                              style: textTheme.lexendBody.copyWith(
                                color: colors.grey[600],
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                32.vertical,

                // Enhanced progress bar with subtle design
                Container(
                  width: 220,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors.neutral[600],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colors.primary[500]!,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Subtle footer message
                Text(
                  'Your personalized story is being crafted with care ✨',
                  style: textTheme.lexendCaption.copyWith(
                    color: colors.grey[400],
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
