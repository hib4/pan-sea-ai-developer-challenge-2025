import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanca/core/theme/app_theme.dart';
import 'package:kanca/features/dashboard/dashboard.dart';
import 'package:kanca/features/onboarding/onboarding.dart';
import 'package:kanca/features/story/bloc/story_bloc.dart';
import 'package:kanca/injector/injector.dart';
import 'package:kanca/l10n/l10n.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StoryBloc _storyBloc;

  @override
  void initState() {
    _storyBloc = Injector.instance<StoryBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StoryBloc>.value(
          value: _storyBloc,
        ),
      ],
      child: AppTheme(
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
      ),
    );
  }
}
