import 'package:kasboxapp/data/models/response/product_response_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDatasource{
  ProductLocalDatasource._init();

  static final ProductLocalDatasource instance = ProductLocalDatasource._init();

  final String tableProducts = 'products';

  static Database? _database;

  Future<Database> _initDB(String filepath) async{
    final dbPath = await getDatabasesPath();
    final path = dbPath + filepath;

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableProducts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        price INTEGER,
        stock INTEGER,
        img TEXT,
        category TEXT
      )
    ''');
  }

  Future<Database> get database async{
    if (_database != null) return _database!;

    _database = await _initDB('kasbox.db');
    return _database!;
  }

  Future<void> removeAllProduct() async{
    final db = await instance.database;
    await db.delete(tableProducts);
  }

  Future<void> insertAllProduct (List<Product> products)async{
    final db = await instance.database;
    for (var product in products){
      await db.insert(tableProducts, product.toJson());
    }
  }

  Future<List<Product>> getAllProduct() async{
    final db = await instance.database;
    final result = await db.query(tableProducts);

    return result.map((e) => Product.fromJson(e)).toList();
  }

}