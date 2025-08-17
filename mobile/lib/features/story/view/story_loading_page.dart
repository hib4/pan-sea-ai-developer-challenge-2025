import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/story/bloc/story_bloc.dart';
import 'package:kanca/features/story/story.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/utils.dart';

class StoryLoadingPage extends StatefulWidget {
  const StoryLoadingPage({super.key});

  @override
  State<StoryLoadingPage> createState() => _StoryLoadingPageState();
}

class _StoryLoadingPageState extends State<StoryLoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
