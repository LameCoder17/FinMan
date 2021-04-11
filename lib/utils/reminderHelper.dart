import 'package:finman/model/reminder.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ReminderDatabaseHelper{
  static ReminderDatabaseHelper _reminderDatabaseHelper;
  static Database _Rdatabase;

  String table = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colCost = 'cost';

  ReminderDatabaseHelper._createInstance();

  factory ReminderDatabaseHelper(){
    if(_reminderDatabaseHelper == null){
      _reminderDatabaseHelper = ReminderDatabaseHelper._createInstance();
    }
    return _reminderDatabaseHelper;
  }

  Future<Database> get database async{
    if(_Rdatabase == null){
      _Rdatabase = await initializeDatabase();
    }
    return _Rdatabase;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'remi.db';

    var expenseDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return expenseDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $table($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colCost INTEGER)');
  }

  //Fetch Operation
  Future<List<Map<String, dynamic>>> getReminderMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $table order by $colId DESC');
    return result;
  }

  //Insert Operation
  Future<int> insertReminder(Reminder rem) async{
    Database db = await this.database;
    var result = await db.insert(table, rem.toMap());
    return result;
  }

  //Update Operation
  Future<int> updateReminder(Reminder rem) async{
    Database db = await this.database;
    var result = await db.update(table, rem.toMap(), where:'$colId = ?', whereArgs: [rem.id]);
    return result;
  }

  //Delete Operation
  Future<int> deleteReminder(int id) async{
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

  Future<List<Reminder>> getReminderList() async{
    var reminderMapList = await getReminderMapList();
    int count = reminderMapList.length;

    List<Reminder> remindList = <Reminder>[];
    for(int i = 0; i < count; i++){
      remindList.add(Reminder.fromMapObject(reminderMapList[i]));
    }
    return remindList;
  }
}
