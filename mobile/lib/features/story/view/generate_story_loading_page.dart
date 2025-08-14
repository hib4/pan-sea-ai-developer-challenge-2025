import 'package:flutter/material.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/story/story.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/utils.dart';

class GenerateStoryLoadingPage extends StatefulWidget {
  const GenerateStoryLoadingPage({super.key});

  @override
  State<GenerateStoryLoadingPage> createState() =>
      _GenerateStoryLoadingPageState();
}

class _GenerateStoryLoadingPageState extends State<GenerateStoryLoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.pushReplacement(const StoryPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            top: 32,
            right: 24,
            bottom: 24,
          ),
          child: Column(
            children: [
              Assets.mascots.thinking.image(
                width: 90,
                height: 120,
              ),
              20.vertical,
              RichText(
                text: TextSpan(
                  style: textTheme.h5.copyWith(
                    color: colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                  text: 'Tunggu sebentar... ',
                  children: [
                    TextSpan(
                      text: 'Bersiap untuk petualangan seru!',
                      style: TextStyle(
                        color: colors.primary[500],
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              32.vertical,
              Container(
                width: 181,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.neutral[600],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
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
    );
  }
}
