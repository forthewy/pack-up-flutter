import 'package:flutter/material.dart';
import 'mindmap_screen.dart';

class MainMenuScreen extends StatelessWidget {

  const MainMenuScreen({
    super.key,
  });

  final List<IconData> menuIcons = const [
    Icons.airplanemode_active,
    Icons.school,
    Icons.shopping_bag,
    Icons.house,
    Icons.fitness_center,
    Icons.schedule,
    Icons.work,
    Icons.more_horiz,
  ];

  final List<String> menuTitles = const [
    "여행 준비",
    "시험 준비",
    "쇼핑 목록",
    "이사 체크",
    "운동 루틴",
    "하루 계획",
    "회사 준비",
    "기타 목록",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Pack Up!'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 1,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 480,
            height: 480,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                // 중앙 로고
                if (index == 4) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.blue.shade50,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                           <Widget>[
                            Icon(Icons.shopping_bag, color: Colors.black),
                            SizedBox(width: 6),
                            Text(
                              "Pack Up!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.blue,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                int menuIndex = index > 4 ? index - 1 : index;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MindMapScreen(
                          category: menuIndex,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            menuIcons[menuIndex],
                            size: 32,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            menuTitles[menuIndex],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
