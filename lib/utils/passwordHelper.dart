import 'package:finman/model/password.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PasswordDatabaseHelper{
  static PasswordDatabaseHelper _passwordDatabaseHelper;
  static Database _Pdatabase;

  String table = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colEmailID = 'emailID';
  String colPassword = 'password';

  PasswordDatabaseHelper._createInstance();

  factory PasswordDatabaseHelper(){
    if(_passwordDatabaseHelper == null){
      _passwordDatabaseHelper = PasswordDatabaseHelper._createInstance();
    }
    return _passwordDatabaseHelper;
  }

  Future<Database> get database async{
    if(_Pdatabase == null){
      _Pdatabase = await initializeDatabase();
    }
    return _Pdatabase;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'pass.db';

    var loanDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return loanDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $table($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colEmailID TEXT, $colPassword TEXT)');
  }

  //Fetch Operation
  Future<List<Map<String, dynamic>>> getPasswordMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $table order by $colId DESC');
    return result;
  }

  //Insert Operation
  Future<int> insertPassword(Password pass) async{
    Database db = await this.database;
    var result = await db.insert(table, pass.toMap());
    return result;
  }

  //Update Operation
  Future<int> updatePassword(Password pass) async{
    Database db = await this.database;
    var result = await db.update(table, pass.toMap(), where:'$colId = ?', whereArgs: [pass.id]);
    return result;
  }

  //Delete Operation
  Future<int> deletePassword(int id) async{
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $colId = $id');
    return result;
  }

  //No of Note Objects
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Password>> getPasswordList() async{
    var passMapList = await getPasswordMapList();
    int count = passMapList.length;

    List<Password> passwordList = <Password>[];
    for(int i = 0; i < count; i++){
      passwordList.add(Password.fromMapObject(passMapList[i]));
    }
    return passwordList;
  }
}
