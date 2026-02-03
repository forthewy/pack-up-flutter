import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/item.dart';

late Isar isar;

Future<void> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();

  isar = await Isar.open(
      [ItemSchema],
      directory: dir.path,
      inspector: true,
  );
}

//
// class IsarService {
//   late Future<Isar> db;
// }
//
//   IsarService() {
//     db = _init();
//   }
//
//   // -------------------------
//   // CRUD
//   // -------------------------
//
//   Future<int> createItem(Item item) async {
//     final isar = await db;
//     return await isar.writeTxn(() => isar.items.put(item));
//   }
//
//   Future<List<Item>> getRootItems(int category) async {
//     final isar = await db;
//     return await isar.items
//         .filter()
//         .categoryEqualTo(category)
//         .and()
//         .parentIdIsNull()
//         .findAll();
//   }
//
//   Future<List<Item>> getChildren(int parentId) async {
//     final isar = await db;
//     return await isar.items
//         .filter()
//         .parentIdEqualTo(parentId)
//         .findAll();
//   }
//
//   Future<void> updateItem(Item item) async {
//     final isar = await db;
//     await isar.writeTxn(() => isar.items.put(item));
//   }
//
//   Future<void> deleteItem(int id) async {
//     final isar = await db;
//     await isar.writeTxn(() => isar.items.delete(id));
//   }
// }
