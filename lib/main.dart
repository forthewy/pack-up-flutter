import 'package:flutter/material.dart';
import 'package:pack_up/screens/start_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<void> addFontLicense() async {
  final license = await rootBundle.loadString(
    'assets/fonts/kor/OFL.txt',
  );

  LicenseRegistry.addLicense(() {
    return Stream<LicenseEntry>.fromIterable([
      LicenseEntryWithLineBreaks(
        ['GowunDodum'],
        license,
      ),
    ]);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('items');
  await addFontLicense();

  runApp(
      const MyApp()
  );
}

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'GowunDodumKor',

          ),
          initialRoute: '/',
          routes: {
            '/': (context) => StartScreen(),
          }
      );
    }
  }