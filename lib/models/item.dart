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
  CategoryType.travel: '여행 준비',
  CategoryType.study: '시험 준비',
  CategoryType.shopping: '쇼핑 목록',
  CategoryType.move: '이사 체크',
  CategoryType.fitness: '운동 루틴',
  CategoryType.daily: '하루 계획',
  CategoryType.work: '회사 준비',
  CategoryType.etc: '기타 목록',
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

  Item({
    required this.id,
    required this.category,
    this.parentId,
    required this.title,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'category': category,
    'parentId': parentId,
    'title': title,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
  };

  static Item fromMap(Map map) => Item(
    id: map['id'],
    category: map['category'],
    parentId: map['parentId'],
    title: map['title'],
    note: map['note'],
    createdAt: DateTime.parse(map['createdAt']),
  );
}
