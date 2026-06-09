import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../l10n/app_localizations.dart';
import '../models/item.dart';
import 'package:flutter/services.dart';

class MindMapScreen extends StatefulWidget {
  final int category;

  const MindMapScreen({super.key, required this.category});

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> {
  double get progress {
    final total = items.length;
    if (total == 0) return 0.0;

    final checked = items.where((e) => e.isChecked).length;

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

    // 들어오면 세로 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    // 나가면 다시 전체 허용
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    super.dispose();
  }

  void _loadItems() {
    final allItems = box.toMap().entries.map((entry) {
      final key = entry.key as int;
      final value = Map<String, dynamic>.from(entry.value);

      return Item(
        id: key,
        category: value['category'],
        parentId: value['parentId'],
        title: value['title'] ?? '',
        note: value['note'],
        createdAt: value['createdAt'],
        isChecked: value['isChecked'] ?? false,
      );
    }).toList();

    final filtered = allItems
        .where((i) => i.category == widget.category)
        .toList();

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
  List<String> getMenuTitles(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      l10n.menuTitlesTravel,
      l10n.menuTitlesStudy,
      l10n.menuTitlesShopping,
      l10n.menuTitlesMove,
      l10n.menuTitlesFitness,
      l10n.menuTitlesDaily,
      l10n.menuTitlesWork,
      l10n.menuTitlesEtc,
    ];
  }



  @override
  Widget build(BuildContext context) {
    final parents = items.where((i) => i.parentId == null).toList();

    final menuTitles = getMenuTitles(context);
    final categoryTitle = menuTitles[widget.category];

    // 카테고리타입
    // 아이템 카테고리는 widget.category == item.category
    // final categoryTitle = categoryTitles[categoryType];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$categoryTitle"),
            Text(
              "${(progress * 100).round()}%", //소수점 반올림
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          ElevatedButton(child: Text(AppLocalizations.of(context)!.deleteAll), onPressed: () {_deleteAllItems();}),
          IconButton(onPressed: _addButton, icon: const Icon(Icons.add)),
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

      // 항목이 비어있다면
      body: parents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    AppLocalizations.of(context)!.emptyItemText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _suggestItems,
                        child: Text(AppLocalizations.of(context)!.suggestionBtnText),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 160),
              children: parents.map((parent) {
                final children = items
                    .where((i) => i.parentId == parent.id)
                    .toList();
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 수정
                            IconButton(onPressed: () {_editItem(parent);}, icon: Icon(Icons.edit)),
                            // 추가
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () => _addChild(parent.id),
                            ),

                            // 가지 항목 보여주기
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
                            child: ListTile(
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
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editItem(child),
                              ),
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

  Future<void> _addSuggestedItems(List<String> items) async {
    for (final title in items) {
      await box.add({
        'category': widget.category,
        'parentId': null,
        'title': title,
        'note': null,
        'createdAt': DateTime.now(),
        'isChecked': false,
      });
    }

    _loadItems();
  }


  Future<void> _suggestItems() async {
    final l10n = AppLocalizations.of(context)!;

    final suggestions = [
      [
        l10n.travelPassport,
        l10n.travelCharger,
        l10n.travelPowerBank,
        l10n.travelCurrency,
        l10n.travelInsurance,
      ],
      [
        l10n.studyPen,
        l10n.studyTextbook,
      ],
      [
        l10n.shoppingMilk,
        l10n.shoppingRice,
        l10n.shoppingToiletPaper,
        l10n.shoppingDetergent,
        l10n.shoppingTrashBags,
      ],
      [
        l10n.moveMold,
        l10n.moveDefects,
        l10n.moveSize,
        l10n.moveFloor,
        l10n.moveMoveInDate,
      ],
      [
        l10n.fitnessStretching,
        l10n.fitnessCardio,
        l10n.fitnessUpperBody,
        l10n.fitnessLowerBody,
        l10n.fitnessCoolDown,
      ],
      [
        l10n.dailyWakeUp,
        l10n.dailyExercise,
        l10n.dailyStudy,
        l10n.dailyCleaning,
        l10n.dailySleep,
      ],
      [
        l10n.workLaptop,
        l10n.workUsb,
      ],
      [
        l10n.etcPhone,
        l10n.etcWallet,
        l10n.etcKeys,
        l10n.etcEarphones,
        l10n.etcCharger,
      ],
    ];

    final categorySuggestions =
    suggestions[widget.category];

    final selected =
    List.filled(categorySuggestions.length, true);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.suggestions),
              content:
                  SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categorySuggestions.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(categorySuggestions[index]),
                          value: selected[index],
                          onChanged: (value) {
                            setDialogState(() {
                              selected[index] = value!;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () async {
                          final selectedItems = <String>[];

                          for (int i = 0; i < categorySuggestions.length; i++) {
                            if (selected[i]) {
                              selectedItems.add(categorySuggestions[i]);
                            }
                          }

                          await _addSuggestedItems(selectedItems);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.addItem),
                      ),
                  ],
            );
          },
        );
      },
    );
  }

  Future<void> _addButton() async {
    final controller = TextEditingController();
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.addItem),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.addItemHintText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: Text(AppLocalizations.of(context)!.add),
            ),
          ],
        );
      },
    );
    // 추가 항목 저장
    if (result == null || result.isEmpty) return;
    await box.add({
      'category': widget.category,
      'parentId': null,
      'title': result,
      'note': null,
      'createdAt': DateTime.now(),
      'isChecked': false,
    });
    _loadItems();
  }

  // 자식 추가
  Future<void> _addChild(int parentId) async {
    final controller = TextEditingController();

    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addItem),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.addItemHintText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text.trim());
            },
            child: Text(AppLocalizations.of(context)!.add),
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
      'createdAt': DateTime.now(),
      'isChecked': false,
    });
    expandedIds.add(parentId);
    _loadItems();
  }

  Future<void> _deleteAllItems() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAll),
        content: Text(AppLocalizations.of(context)!.deleteAllAlertText),
      actions: [
        TextButton(onPressed: () { Navigator.pop(context, false);}, child: Text(AppLocalizations.of(context)!.cancel),),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(AppLocalizations.of(context)!.confirmDelete),
        ),
      ]
      ),
    );
    if (confirm != true) return;
    final keysToDelete = items.map((e) => e.id).toList();

    await box.deleteAll(keysToDelete);

    expandedIds.clear();

    _loadItems();

  }

  Future<void> _deleteItem(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteItem),
        content: Text(
          AppLocalizations.of(context)!.deleteAlertText,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(AppLocalizations.of(context)!.confirmDelete),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    // 현재 삭제 대상이 부모인지 확인
    final isParent = items.any((i) => i.parentId == id);

    if (isParent) {
      // 자식들 먼저 삭제
      final children = items.where((i) => i.parentId == id).toList();

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
    final children = items.where((i) => i.parentId == id).toList();

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
      final siblings = items.where((i) => i.parentId == parentId).toList();

      final allChecked = siblings.every(
        (i) => i.id == id ? newValue : i.isChecked,
      );

      final parentRaw = box.get(parentId);
      final parentMap = Map<String, dynamic>.from(parentRaw);

      parentMap['isChecked'] = allChecked;

      await box.put(parentId, parentMap);
    }
    _loadItems();
  }

  Future<void> _editItem(Item item) async {
    final controller = TextEditingController(text: item.title);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editItem),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Edit Item'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, controller.text.trim());
            },
            child: Text(AppLocalizations.of(context)!.save),
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
