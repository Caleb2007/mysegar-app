import 'package:flutter/material.dart';

import 'screens/diary_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/home_screen.dart';
import 'screens/input1_screen.dart';
import 'screens/input2_screen.dart';
import 'screens/input3_screen.dart';
import 'screens/ml_demo_screen.dart';
import 'screens/progress_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const MySegarApp());
}

class MySegarApp extends StatelessWidget {
  const MySegarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MySegar',
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/input1': (context) => const Input1Screen(),
        '/input2': (context) => const Input2Screen(),
        '/input3': (context) => const Input3Screen(),
        '/diary': (context) => const DiaryScreen(),
        '/exercise1': (context) => const ExerciseScreen(),
        '/progress': (context) => const ProgressScreen(),
        MlDemoScreen.routeName: (context) => const MlDemoScreen(),
      },
    );
  }
}
