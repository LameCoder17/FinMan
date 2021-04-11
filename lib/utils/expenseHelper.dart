import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:finman/model/expense.dart';

class ExpenseDatabaseHelper{
  static ExpenseDatabaseHelper _expenseDatabaseHelper;
  static Database _Edatabase;

  String table = 'note_table';
  String colId = 'id';
  String colDescription = 'description';
  String colMoney = 'money';

  ExpenseDatabaseHelper._createInstance();

  factory ExpenseDatabaseHelper(){
    if(_expenseDatabaseHelper == null){
      _expenseDatabaseHelper = ExpenseDatabaseHelper._createInstance();
    }
    return _expenseDatabaseHelper;
  }

  Future<Database> get database async{
    if(_Edatabase == null){
      _Edatabase = await initializeDatabase();
    }
    return _Edatabase;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'exp.db';

    var expenseDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return expenseDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $table($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDescription TEXT, $colMoney INTEGER)');
  }

  //Fetch Operation
  Future<List<Map<String, dynamic>>> getExpenseMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $table order by $colId DESC');
    return result;
  }

  //Insert Operation
  Future<int> insertExpense(Expense expense) async{
    Database db = await this.database;
    var result = await db.insert(table, expense.toMap());
    return result;
  }

  //Update Operation
  Future<int> updateExpense(Expense expense) async{
    Database db = await this.database;
    var result = await db.update(table, expense.toMap(), where:'$colId = ?', whereArgs: [expense.id]);
    return result;
  }

  //Delete Operation
  Future<int> deleteExpense(int id) async{
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

  Future<List<Expense>> getExpenseList() async{
    var expenseMapList = await getExpenseMapList();
    int count = expenseMapList.length;

    List<Expense> expenseList = <Expense>[];
    for(int i = 0; i < count; i++){
      expenseList.add(Expense.fromMapObject(expenseMapList[i]));
    }
    return expenseList;
  }
}
