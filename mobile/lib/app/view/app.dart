import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:kanca/core/theme/app_theme.dart';
import 'package:kanca/features/dashboard/dashboard.dart';
import 'package:kanca/features/onboarding/onboarding.dart';
import 'package:kanca/features/story/view/story_page.dart';
import 'package:kanca/features/test_page.dart';
import 'package:kanca/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTheme(
      colorTheme: AppColors.colors(),
      textTheme: AppTextStyles.textStyles(),
      child: MaterialApp(
        title: 'Kanca',
        theme: AppThemeData.themeData().themeData,
        darkTheme: AppThemeData.themeData().themeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return DeviceFrame(
            device: Devices.ios.iPhone15ProMax,
            screen: child ?? const SizedBox.shrink(),
          );
        },
        home: const OnboardingPage(),
      ),
    );
  }
}
