import 'package:flutter/material.dart';
import 'package:pack_up/screens/start_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('items');

  runApp(
      const MyApp()
  );
}

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
          theme: ThemeData(
            fontFamily: 'GowunDodumKor', // 영문 폰트는 이후 추가
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => StartScreen(),
          }
      );
    }
  }