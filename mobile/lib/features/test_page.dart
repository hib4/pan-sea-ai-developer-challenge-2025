import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/dashboard/dashboard.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/utils.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.mascots.hooray.image(
                      width: 150,
                      height: 150,
                    ),
                    16.vertical,
                    Text(
                      'Core Value',
                      style: textTheme.h5.copyWith(
                        color: colors.secondary[900],
                      ),
                    ),
                    Text(
                      'Honesty',
                      style: textTheme.h4.copyWith(
                        color: colors.primary[500],
                      ),
                    ),
                    24.vertical,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondary[900],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Meaning',
                        style: GoogleFonts.fredoka(
                          color: colors.primary[50],
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                    12.vertical,
                    Text(
                      'Honesty means telling the truth and not taking other people’s belongings.',
                      style: textTheme.lexendBody.copyWith(
                        color: colors.secondary[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    24.vertical,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondary[900],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Real-life Example',
                        style: GoogleFonts.fredoka(
                          color: colors.primary[50],
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                    12.vertical,
                    Text(
                      'Honesty means telling the truth and not taking other people’s belongings.',
                      style: textTheme.lexendBody.copyWith(
                        color: colors.secondary[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    48.vertical,
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.pushAndRemoveUntil(
                            const DashboardPage(),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.neutral[500],
                          side: BorderSide(
                            color: colors.primary[500]!,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Home',
                          style: GoogleFonts.lexend(
                            color: colors.primary[500],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    12.horizontal,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement next action
                        },
                        child: const Text('New Story'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
