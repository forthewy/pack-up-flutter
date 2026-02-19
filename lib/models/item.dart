enum CategoryType {
  travel,
  study,
  shopping,
  move,
  fitness,
  daily,
  work,
  etc,
}

const Map<CategoryType, String> categoryTitles = {
  CategoryType.travel: 'Travel',
  CategoryType.study: 'Study',
  CategoryType.shopping: 'Shopping',
  CategoryType.move: 'Move',
  CategoryType.fitness: 'Fitness',
  CategoryType.daily: 'Daily',
  CategoryType.work: 'Work',
  CategoryType.etc: 'Etc',
};
// @collection
//   Id id = Isar.autoIncrement;
class Item {
  final int id;
  final int category;
  final int? parentId;
  final String title;
  final String? note;
  final DateTime createdAt;
  final bool isChecked;

  Item({
    required this.id,
    required this.category,
    this.parentId,
    required this.title,
    this.note,
    required this.createdAt,
    required this.isChecked,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'category': category,
    'parentId': parentId,
    'title': title,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'isChecked' : isChecked,
  };

  static Item fromMap(Map map) => Item(
    id: map['id'],
    category: map['category'],
    parentId: map['parentId'],
    title: map['title'],
    note: map['note'],
    createdAt: DateTime.parse(map['createdAt']),
    isChecked: map['isChecked'],
  );
}
