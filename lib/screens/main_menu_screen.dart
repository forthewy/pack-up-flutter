import 'package:flutter/material.dart';
import 'mindmap_screen.dart';
import '../services/progress_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

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
    // "여행 준비",
    // "시험 준비",
    // "쇼핑 목록",
    // "이사 체크",
    // "운동 루틴",
    // "하루 계획",
    // "회사 준비",
    // "기타 목록",
    "Travel",
    "Study",
    "Shopping",
    "Move",
    "Fitness",
    "Daily",
    "Work",
    "Etc",
  ];

  // 상단 메뉴 위젯
  Widget buildMenuItem(
    BuildContext context,
    int index,
    double percent,
    double itemHeight,
  ) {
    // 중앙 로고
    if (index == 4) {
      return Card(
        color: Colors.blue.shade50,
        child: const Center(child: Text("Pack Up!")),
      );
    }

    int menuIndex = index > 4 ? index - 1 : index;

    return GestureDetector(
      // 클릭시 해당 카테고리로 이동
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MindMapScreen(category: menuIndex)),
        );
      },
      // 카드 만들기
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(
            (8 * percent), // 내부 패딩
          ),
          child: ValueListenableBuilder(
            valueListenable: Hive.box('items').listenable(),
            builder: (context, Box box, _) {
              final progress = ProgressService.calculateCategoryProgress(
                box,
                menuIndex,
              );

              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 아이콘
                  Icon(
                    menuIcons[menuIndex],
                    // scale 따라 아이콘 사이즈 변경
                    size: (itemHeight * 0.3),
                  ),

                  // 아이콘 이외 진행도,타이틀
                  if (percent > 0.6)
                    Expanded(
                      child: Opacity(
                        opacity: ((percent - 0.6) / 0.4).clamp(0.0, 1.0),
                        child: LayoutBuilder(
                          builder: (context, innerConstraints) {
                            if (percent > 0.9) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(menuTitles[menuIndex]),
                                  SizedBox(
                                    height: (itemHeight * 0.03),
                                  ),
                                  LinearProgressIndicator(value: progress),
                                  SizedBox(
                                    height: (itemHeight * 0.03),
                                  ),
                                  Text("${(progress * 100).round()}%"),
                                ],
                              );
                            }
                            // 0.6 ~ 0.9 구간
                            return Center(
                              child: Text(
                                menuTitles[menuIndex],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildBottomList(BuildContext context, int index) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('items').listenable(),
      builder: (context, Box box, _) {
        final progress = ProgressService.calculateCategoryProgress(box, index);

        final total = box.values.where((item) {
          return item['category'] == index;
        }).length;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MindMapScreen(category: index)),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  /// 🔵 아이콘
                  Icon(menuIcons[index], size: 28),

                  const SizedBox(width: 16),

                  /// 🟡 텍스트 영역
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 이름 + 개수
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              menuTitles[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "total : $total",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// 🔥 진행도 (네모 10개)
                        Row(
                          children: List.generate(10, (i) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                height: 6,
                                decoration: BoxDecoration(
                                  color: i < (progress * 10).round()
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// 🔴 퍼센트
                  Text(
                    "${(progress * 100).round()}%",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final expandedHeight = screenHeight * 0.65;
    final collapsedHeight = screenHeight * 0.22;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Pack Up!'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 1,
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// 상단
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: expandedHeight,
              collapsedHeight: collapsedHeight,
              pinned: true,

              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final itemHeight = (constraints.maxHeight / 3)
                      .clamp(70, 200)
                      .toDouble();

                  final percent =
                      (constraints.maxHeight - collapsedHeight) /
                      (expandedHeight - collapsedHeight);

                  return Padding(
                    padding: EdgeInsets.all(4),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 9,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5 * percent,
                                  mainAxisSpacing: 5 * percent,
                                  mainAxisExtent: (constraints.maxHeight / 3.3)
                                      .clamp(30, 200)
                                      .toDouble(),
                                ),
                            itemBuilder: (context, index) {
                              return buildMenuItem(
                                context,
                                index,
                                percent,
                                itemHeight,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: buildBottomList(context, index),
                  ),
                );
              }, childCount: 8),
            ),
          ],
        ),
      ),
    );
  }
}
