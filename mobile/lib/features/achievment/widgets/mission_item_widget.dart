import 'package:flutter/material.dart';
import 'package:kanca/core/theme/app_theme.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/utils.dart';

class MissionItemWidget extends StatelessWidget {
  const MissionItemWidget({
    required this.title,
    required this.xpReward,
    required this.currentProgress,
    required this.totalProgress,
    required this.isCompleted,
    super.key,
  });

  final String title;
  final String xpReward;
  final int currentProgress;
  final int totalProgress;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final progressFactor = currentProgress / totalProgress;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: colors.primary[500]!,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textTheme.lexendBody.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                xpReward,
                style: textTheme.lexendBody.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          8.vertical,
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: colors.grey[50],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressFactor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.primary[500],
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '$currentProgress / $totalProgress',
                    style: textTheme.lexendCaption.copyWith(
                      color: currentProgress / totalProgress > 0.5
                          ? Colors.white
                          : colors.grey[200],
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
