import 'package:addtocartdatabase/model/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDB {
  static Database? _database;

  static Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'cart.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE cart(id INTEGER PRIMARY KEY, name TEXT, imageUrl TEXT, price REAL, quantity INTEGER)',
        );
      },
    );
  }

  static Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('cart', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateQuantity(int id, int quantity) async {
    final db = await database;
    await db.update(
      'cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<bool> isProductInCart(int id) async {
    final db = await database;
    final result = await db.query(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  static Future<List<Product>> fetchCartItems() async {
    final db = await database;
    final maps = await db.query('cart');
    return maps.map((e) => Product.fromMap(e)).toList();
  }

  static Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }
}
