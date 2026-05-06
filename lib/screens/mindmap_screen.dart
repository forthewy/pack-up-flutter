import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

class _MindMapScreenState extends State<MindMapScreen> {
  double get progress {
    final total = items.length;
    if (total == 0) return 0.0;

    final checked =
        items.where((e) => e.isChecked).length;

    return checked / total;
  }
  late Box box;

  List<Item> items = [];

  /// UI 상태 (접힘/펼침) Set --> 중복 방지
  final Set<int> expandedIds = {};

  @override
  void initState() {
    super.initState();
    box = Hive.box('items');
    _loadItems();
  }

  void _loadItems() {
    final allItems = box.toMap().entries.map((entry) {
      final key = entry.key as int;
      final value = Map<String, dynamic>.from(entry.value);

      return Item(
        id: key,
        category: value['category'],
        parentId: value['parentId'],
        title: value['title']?? '',
        note: value['note'],
        createdAt: value['createdAt'],
        isChecked: value['isChecked'] ?? false,
      );
    }).toList();

    final filtered =
    allItems.where((i) => i.category == widget.category).toList();

    // debugPrint('불러온 item 개수: ${filtered.length}');
    // for (final i in filtered) {
    //   debugPrint('item: ${i.id}, title=${i.title}');
    // }

    setState(() {
      items = filtered;
    });
  }

  void toggleExpanded(int id) {
    setState(() {
      if (expandedIds.contains(id)) {
        expandedIds.remove(id);
      } else {
        expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final parents = items.where((i) => i.parentId == null).toList();
    final categoryType = CategoryType.values[widget.category];
    // 카테고리타입
    // 아이템 카테고리는 widget.category == item.category
    final categoryTitle = categoryTitles[categoryType];


    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${categoryTitle}"),
            Text(
              "${(progress * 100).round()}%",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: _addButton,
              icon: const Icon(Icons.add)
          )
        ],
      ),
      // 하단 추가 버튼
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _addButton,
        backgroundColor: Color(0xFFFFE53B), // 노란 버튼
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50), // 반원 느낌
          ),
        ),
        child: const Icon(Icons.add, color: Colors.black),
      ),

      body: parents.isEmpty
          ? const Center(
        child: Text(
         // '아직 항목이 없어요 🙂\n+ 버튼으로 추가해보세요',
          'There are no items yet 🙂\nTap the + button to add one',
          textAlign: TextAlign.center,
          style:
            TextStyle(
                fontSize: 26
            ),
        ),
      )
          :
        ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 160),
        children: parents.map((parent) {
          final children =
          items.where((i) => i.parentId == parent.id).toList();
          final isExpanded = expandedIds.contains(parent.id);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                  ListTile(
                    leading: Checkbox(
                      value: parent.isChecked,
                      onChanged: (value) {
                        _toggleCheck(parent.id, value ?? false);
                      },
                    ),
                    title: Text(parent.title),
                    onLongPress: () => _deleteItem(parent.id),
                    trailing:
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, size:20),
                          onPressed: () => _addChild(parent.id),
                        ),
                        if (children.isNotEmpty)
                          IconButton(
                            icon: Icon(
                              isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          ),
                            onPressed: () => toggleExpanded(parent.id),
                        ),
                      ],
                    ),
                    onTap: () => _editItem(parent),
                  ),

                if (isExpanded)
                  ...children.map(
                        (child) => Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child:
                          ListTile(
                            leading: Checkbox(
                              value: child.isChecked,
                              onChanged: (value) {
                                _toggleCheck(child.id, value ?? false);
                              },
                            ),
                            title: Text(child.title),
                            onLongPress: () => _deleteItem(child.id),
                            subtitle: child.note != null
                                ? Text(child.note!)
                                : null,
                          onTap: () => _editItem(child),
                        ),
                        ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
    Future<void> _addButton() async{
      final controller = TextEditingController();
      final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter a new item',
                // '새 항목을 입력하세요'
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, controller.text.trim());
                },
                child: const Text('Add'),
              ),
            ],
          );
        }
        );
          // 추가 항목 저장
          if (result == null || result.isEmpty) return;
          await box.add({
            'category': widget.category,
            'parentId': null,
            'title': result,
            'note': null,
            'createdAt' : DateTime.now(),
            'isChecked': false,
          });
        _loadItems();
    }

    // 자식 추가
    Future<void> _addChild(int parentId) async{
      final controller = TextEditingController();

      final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add Item'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter a new item',
              //'새 항목을 입력하세요',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );

      if (result == null || result.isEmpty) return;
      await box.add({
        'category': widget.category,
        'parentId': parentId,
        'title': result,
        'note': null,
        'createdAt' : DateTime.now(),
        'isChecked': false,
      });
      expandedIds.add(parentId);
      _loadItems();
    }

    Future<void> _deleteItem(int id) async{
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
            const Text(
                //'정말로 삭제하시겠습니까?\n토글로 기재된 item 도 삭제됩니다!'),
              'Are you sure you want to delete?\nItems listed under this will also be deleted',
            ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Yes, Delete')
            ),
          ],
        )
      );

      if(confirm != true) return;
      // 현재 삭제 대상이 부모인지 확인
      final isParent =
      items.any((i) => i.parentId == id);

      if (isParent) {
        // 자식들 먼저 삭제
        final children =
        items.where((i) => i.parentId == id).toList();

        for (final child in children) {
          await box.delete(child.id);
        }
      }

      // 자기 자신 삭제
      await box.delete(id);
      expandedIds.remove(id);

      _loadItems();
    }

  Future<void> _toggleCheck(int id, bool newValue) async {
    final raw = box.get(id);
    final map = Map<String, dynamic>.from(raw);

    map['isChecked'] = newValue;
    await box.put(id, map);

    // 부모 체크시 자식 모두 반영
    final children =
    items.where((i) => i.parentId == id).toList();

    if (children.isNotEmpty) {
      for (final child in children) {
        final childRaw = box.get(child.id);
        final childMap = Map<String, dynamic>.from(childRaw);
        childMap['isChecked'] = newValue;
        await box.put(child.id, childMap);
      }
    }

    // 자식 모두 체크 시 부모도 체크
    final parentId = map['parentId'];

    if (parentId != null) {
      final siblings = items
          .where((i) => i.parentId == parentId)
          .toList();

      final allChecked =
      siblings.every((i) => i.id == id
          ? newValue
          : i.isChecked);

      final parentRaw = box.get(parentId);
      final parentMap = Map<String, dynamic>.from(parentRaw);

      parentMap['isChecked'] = allChecked;

      await box.put(parentId, parentMap);
    }
    _loadItems();
  }
  Future<void> _editItem(Item item) async {
    final controller =
    TextEditingController(text: item.title);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Edit Item',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text.trim());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    final raw = box.get(item.id);
    final map = Map<String, dynamic>.from(raw);

    map['title'] = result;

    await box.put(item.id, map);

    _loadItems();
  }
}

