import 'package:isar/isar.dart';
part 'item.g.dart';

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



@collection
class Item {
  Id id = Isar.autoIncrement;

  int? parentId; // 마인드맵 구조를 위한 부모 ID

  late int category; // CategoryType.index
  late String title;
  String? note;

  DateTime createdAt = DateTime.now();
}
