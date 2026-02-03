import 'package:flutter/material.dart';
import '../services/isar_service.dart';
import '../models/item.dart';

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

  bool rootSelected = false;

  @override void initState() {
    // TODO: implement initState
    super.initState();
  }

//   List<Item> rootNodes = [];
//   Map<int, List<Item>> childNodes = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _ensureCategoryRoot();
//   }
//
//   // ---------------- 중앙 루트 자동 생성 ----------------
//   Future<void> _ensureCategoryRoot() async {
//     final roots = await widget.isarService.getRootItems(widget.category);
//
//     if (roots.isNotEmpty) {
//       setState(() => rootNodes = roots);
//       return;
//     }
//
//     final root = Item()
//       ..title = _categoryName(widget.category)
//       ..category = widget.category
//       ..parentId = null;
//
//    // await widget.isarService.createItem(root);
//
//     _loadRootNodes();
//   }
//
//   String _categoryName(int category) {
//     const names = [
//       "여행 준비",
//       "시험 준비",
//       "쇼핑 목록",
//       "이사 체크",
//       "운동 루틴",
//       "하루 계획",
//       "회사 준비",
//       "기타 목록",
//     ];
//     return names[category];
//   }
//
//   // ---------------- READ ROOT ----------------
//   Future<void> _loadRootNodes() async {
//     final nodes = await widget.isarService.getRootItems(widget.category);
//     setState(() => rootNodes = nodes);
//   }
//
//   // ---------------- READ CHILDREN ----------------
//   Future<void> _loadChildren(int parentId) async {
//     final children = await widget.isarService.getChildren(parentId);
//     setState(() => childNodes[parentId] = children);
//   }
//
//   // ---------------- CREATE NODE ----------------
//   Future<void> _addNode(int? parentId) async {
//     final controller = TextEditingController();
//
//     await showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("새 항목 추가"),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(hintText: "제목을 입력하세요"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("취소"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (controller.text.trim().isEmpty) return;
//
//               final item = Item()
//                 ..title = controller.text.trim()
//                 ..category = widget.category
//                 ..parentId = parentId
//                 ..createdAt = DateTime.now();
//
//               await widget.isarService.createItem(item);
//
//               Navigator.pop(context);
//
//               if (parentId == null) {
//                 _loadRootNodes();
//               } else {
//                 _loadChildren(parentId);
//               }
//             },
//             child: const Text("추가"),
//           ),
//         ],
//       ),
//     );
//   }
//
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

            // 🔹 현수막 / + 버튼
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: rootSelected
                  ? _plusButton()
                  : _hintBanner(),
            ),

            // 🔹 중앙 노드
            GestureDetector(
              onTap: () {
                setState(() {
                  rootSelected = !rootSelected;
                });
              },
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
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
        '노드를 클릭해서 추가하세요',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _plusButton() {
    return Container(
      key: const ValueKey('plus'),
      margin: const EdgeInsets.only(bottom: 180),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            debugPrint('➕ root add');
          },
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.add),
          ),
        ),
      ),
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