import 'package:flutter/material.dart';
import 'package:pack_up/screens/start_screen.dart';
import 'services/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initIsar(); // DB 준비
  
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