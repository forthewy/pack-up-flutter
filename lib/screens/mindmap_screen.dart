import 'package:flutter/material.dart';
import '../services/isar_service.dart';
import '../models/item.dart';
import 'package:isar/isar.dart';

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

  List<Item> items = [];
  int? selectedItemId; // null이면 가지 미선택

  @override void initState() {
    super.initState();
    _loadRootItems();
  }

  List<Item> rootNodes = [];
  Map<int, List<Item>> childNodes = {};

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

  @override
  Widget build(BuildContext context) {
    final category = CategoryType.values[widget.category];
    final title = categoryTitles[category]!;

    return Scaffold(
        appBar: AppBar(
          title: Text("선택된 카테고리 - $title"),
        ),
        body: Center()
    );
  }
}