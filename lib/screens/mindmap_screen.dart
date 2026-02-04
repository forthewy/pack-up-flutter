import 'package:flutter/material.dart';
import '../services/isar_service.dart';
import '../models/item.dart';
import 'package:isar/isar.dart';
import 'dart:math';

class MindMapScreen extends StatefulWidget {
  final int category;


  const MindMapScreen({
    super.key,
    required this.category,
  });


  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}
//
class _MindMapScreenState extends State<MindMapScreen> {

  List<Item> items = [];
  int? selectedItemId; // null이면 가지 미선택
  bool rootSelected = false; // 중앙 선택 여부

  static double radius = 180;


  @override void initState() {
    // TODO: implement initState
    super.initState();
    _loadRootItems();
  }

  List<Item> rootNodes = [];
  Map<int, List<Item>> childNodes = {};
//
  Future<void> _loadRootItems() async {
    final result = await isar.items
        .filter()
        .categoryEqualTo(widget.category)
        .parentIdIsNull()
        .findAll();
    debugPrint('불러온 item 개수: ${result.length}');
    for (final i in result) {
      debugPrint('item: ${i.id}, title=${i.title}');
    }
    setState(() {
      items = result;
    });
  }


//
//   // ---------------- READ CHILDREN ----------------
//   Future<void> _loadChildren(int parentId) async {
//     final children = await widget.isarService.getChildren(parentId);
//     setState(() => childNodes[parentId] = children);
//   }
//
  // ---------------- CREATE NODE ----------------
  Future<void> _addNode(int? parentId) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("새 항목 추가"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "제목을 입력하세요",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              final item = Item()
                ..title = controller.text.trim()
                ..category = widget.category
                ..parentId = parentId
                ..createdAt = DateTime.now();

              await isar.writeTxn(() async {
                await isar.items.put(item);
              });

              Navigator.pop(context);
              _loadRootItems();
            },
            child: const Text("추가"),
          ),
        ],
      ),
    );
  }

//   // ---------------- UPDATE ----------------
//   Future<void> _editNode(Item item) async {
//     final controller = TextEditingController(text: item.title);
//
//     await showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("항목 수정"),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(hintText: "수정할 제목"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("취소"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               item.title = controller.text.trim();
//               await widget.isarService.updateItem(item);
//
//               Navigator.pop(context);
//
//               if (item.parentId == null) {
//                 _loadRootNodes();
//               } else {
//                 _loadChildren(item.parentId!);
//               }
//             },
//             child: const Text("저장"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------- DELETE ----------------
//   Future<void> _deleteNode(Item item) async {
//     await widget.isarService.deleteItem(item.id);
//
//     if (item.parentId == null) {
//       _loadRootNodes();
//     } else {
//       _loadChildren(item.parentId!);
//     }
//   }
//
//   // ---------------- 버블 UI ----------------
//   Widget _buildBubbleNode(Item node) {
//     final children = childNodes[node.id];
//
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   node.title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//
//               IconButton(
//                 icon: const Icon(Icons.add_circle_outline),
//                 onPressed: () => _addNode(node.id),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () => _editNode(node),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () => _deleteNode(node),
//               ),
//             ],
//           ),
//
//           if (children != null)
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Column(
//                 children:
//                     children.map((c) => _buildBubbleNode(c)).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildChildrenOfRoot() {
//     if (rootNodes.isEmpty) return [];
//
//     final root = rootNodes.first;
//
//     if (!childNodes.containsKey(root.id)) {
//       _loadChildren(root.id);
//       return [const Center(child: CircularProgressIndicator())];
//     }
//
//     return childNodes[root.id]!
//         .map((child) => _buildBubbleNode(child))
//         .toList();
//   }
//

  @override
  Widget build(BuildContext context) {
    final category = CategoryType.values[widget.category];
    final title = categoryTitles[category]!;

    return Scaffold(
      appBar: AppBar(
        title: Text("선택된 카테고리 - $title"),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            // 안내 멘트 / + 버튼
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: rootSelected
                  ? _addButton()
                  : _hintBanner(),
            ),
            // 가지 노드
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              final int count = items.length;
              final double startAngle = 0; // 오른쪽부터
              final double angleStep = 360 / count;

              final double angleDeg = startAngle + angleStep * index;
              final double angleRad = angleDeg * pi / 180;

              final double dx = radius * cos(angleRad);
              final double dy = radius * sin(angleRad);

              return Transform.translate(
                offset: Offset(dx, dy),
                child: _itemNodeWithAdd(item),
              );
            }).toList(),

            // 중앙 노드
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedItemId = null; // 중앙 선택 의미
                  rootSelected = true;
                });
              },
              child: Container(
                width: rootSelected ? 150 : 140,
                height: rootSelected ? 150 : 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rootSelected ? Colors.blueAccent : Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: rootSelected ? 16 : 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hintBanner() {
    return Container(
      key: const ValueKey('hint'),
      margin: const EdgeInsets.only(bottom: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '노드를 클릭해서 추가/삭제/수정하세요',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
  // 추가 버튼
  Widget _addButton() {
    return Container(
      key: const ValueKey('add'),
      margin: const EdgeInsets.only(bottom: 180),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () async {
            await _addNode(null); // 중앙 아래에 추가
            rootSelected = false;
          },
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
  // 가지 노드 그리기
  Widget _itemNode(Item item) {
    final bool isSelected = selectedItemId == item.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItemId = item.id;
          rootSelected = false; // 중앙 선택 해제
        });
      },
      child: Container(
        width: isSelected ? 100 : 90,
        height: isSelected ? 100 : 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.deepOrange : Colors.orange,
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.black38 : Colors.black26,
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemNodeWithAdd(Item item) {
    final bool isSelected = selectedItemId == item.id;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        _itemNode(item),

        if (isSelected)
          Positioned(
            top: -18,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  await _addNode(item.id);
                  setState(() {
                    selectedItemId = null;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.add, size: 16),
                ),
              ),
            ),
          ),
      ],
    );
  }



//       floatingActionButton: rootNodes.isEmpty
//           ? null
//           : FloatingActionButton(
//               onPressed: () => _addNode(rootNodes.first.id),
//               child: const Icon(Icons.add),
//             ),
//
//       body: rootNodes.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 Center(
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.blue.shade50,
//                     ),
//                     child: Text(
//                       rootNodes.first.title,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 ..._buildChildrenOfRoot(),
//               ],
//             ),
//     );
//   }
// }

}