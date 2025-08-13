import 'package:flutter/material.dart';
import 'package:kanca/core/theme/app_theme.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.neutral[500],
      appBar: AppBar(
        title: Text(
          'Progress',
          style: context.textTheme.lexendLargeBody.copyWith(
            color: context.colors.darkAccent[500],
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.colors.neutral[500],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: context.colors.darkAccent[500],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated progress indicator with chart icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      context.colors.secondary[300]!,
                      context.colors.support[300]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.secondary[200]!.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.neutral[500],
                    ),
                    child: Icon(
                      Icons.analytics_outlined,
                      size: 48,
                      color: context.colors.secondary[500],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Progress Tracking',
                style: context.textTheme.h4.copyWith(
                  color: context.colors.darkAccent[500],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Coming Soon',
                style: context.textTheme.lexendLargeBody.copyWith(
                  color: context.colors.secondary[500],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                "We're building comprehensive progress analytics to help you track your learning journey. Soon you'll be able to visualize your reading habits, story completion rates, and learning milestones!",
                style: context.textTheme.lexendBody.copyWith(
                  color: context.colors.grey[600],
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.colors.neutral[400],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.colors.secondary[200]!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.grey[200]!.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timeline_rounded,
                          color: context.colors.secondary[500],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Development Progress',
                            style: context.textTheme.lexendBody.copyWith(
                              color: context.colors.darkAccent[500],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '75%',
                          style: context.textTheme.lexendBody.copyWith(
                            color: context.colors.secondary[500],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.75,
                        backgroundColor: context.colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.colors.secondary[500]!,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Progress tracking features coming soon!',
                          style: context.textTheme.lexendBody.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: context.colors.secondary[500],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.secondary[500],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Notify Me When Ready',
                    style: context.textTheme.lexendBody.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
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
