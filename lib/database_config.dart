import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConfig{

  static Database? _database;

  Future<Database?> getDatabase() async{
    if(_database == null){
      _database = await initialiseDB();
      return _database;
    }
    else{
      return _database;
    }

  }

  Future<Database> initialiseDB() async{

    String databasePath = await getDatabasesPath();
    String path = join(databasePath,'notesapp.db');
    Database database = await openDatabase(path,onCreate: (Database db,int version)async{
      await db.execute('''
      CREATE TABLE "notes"(
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "note" TEXT NOT NULL
      )
      ''');
    },version: 2,onUpgrade: (Database db,int oldVersion,int newVersion) async{
      if (oldVersion < newVersion) {
        await db.execute("ALTER TABLE notes ADD COLUMN 'body' TEXT");
      }
    });
    return database;
  }

  readData(String sql) async{
    Database? db = await getDatabase();
    List<Map> response = await db!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async{
    Database? db = await getDatabase();
    int response = await db!.rawInsert(sql);
    return response;
  }

  deleteData(String sql) async{
    Database? db = await getDatabase();
    int response = await db!.rawDelete(sql);
    return response;
  }

  updateData(String sql) async{
    Database? db = await getDatabase();
    int response = await db!.rawUpdate(sql);
    return response;
  }

}