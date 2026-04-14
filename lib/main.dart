import 'package:flutter/material.dart';

import 'app_state.dart';
import 'screens/app_shell_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'services/local_storage_service.dart';
import 'services/tflite_service.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MySegarApp());
}

class MySegarApp extends StatefulWidget {
  const MySegarApp({super.key});

  @override
  State<MySegarApp> createState() => _MySegarAppState();
}

class _MySegarAppState extends State<MySegarApp> {
  final TFLiteService _tfliteService = TFLiteService();
  late final AppState _state;
  late final Future<void> _loader;

  @override
  void initState() {
    super.initState();
    // Initialize ML service
    _initTFLite();
    // Initialize app state
    _state = AppState(LocalStorageService());
    _loader = _state.load();
  }

  Future<void> _initTFLite() async {
    await _tfliteService.init();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: AnimatedBuilder(
        animation: _state,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MySegar',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              scaffoldBackgroundColor: Colors.transparent,
              fontFamily: 'Roboto',
            ),
            home: FutureBuilder<void>(
              future: _loader,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.pageGradient(PageTone.green),
                    ),
                    child: const Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }
                if (!_state.hasSeenOnboarding) {
                  return OnboardingScreen(
                    onGetStarted: () {
                      _state.completeOnboarding();
                    },
                  );
                }
                if (_state.needsProfileSetup) return const ProfileSetupScreen();
                return const AppShellScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
