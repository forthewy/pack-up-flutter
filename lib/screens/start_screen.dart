import 'package:flutter/material.dart';
import 'main_menu_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title
                const Text(
                  'Pack Up!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  //'여행 준비부터 시험 준비까지\n모든 준비를 한 곳에서',
                  'All your prep, in one place —\nfrom trips to tests.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 48),

                // 메인 버튼
                SizedBox(
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainMenuScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child:
                    //const Text('시작하기'),
                    const Text('START'),
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'Pack Up',
                      applicationVersion: '1.0.0',
                    );
                  },
                  child: const Text(
                    'Licenses',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),

                // // 설정기타 메뉴
                // SizedBox(
                //   width: 150.0,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text('설정 화면은 아직 미구현 🙂'),
                //         ),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.white,
                //       foregroundColor: Colors.black,
                //       elevation: 0,
                //       padding: const EdgeInsets.symmetric(vertical: 16),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     child: const Text(
                //       //'설정 / 기타 메뉴',
                //       'SETTING',
                //       style: TextStyle(
                //           fontSize: 16,
                //         ),
                //       ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
