import 'package:finman/model/loan.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LoanDatabaseHelper{
  static LoanDatabaseHelper _loanDatabaseHelper;
  static Database _Ldatabase;

  String table = 'note_table';
  String colId = 'id';
  String colName = 'name';
  String colDescription = 'description';
  String colCost = 'cost';
  String colGiveOrTake = 'giveOrTake';

  LoanDatabaseHelper._createInstance();

  factory LoanDatabaseHelper(){
    if(_loanDatabaseHelper == null){
      _loanDatabaseHelper = LoanDatabaseHelper._createInstance();
    }
    return _loanDatabaseHelper;
  }

  Future<Database> get database async{
    if(_Ldatabase == null){
      _Ldatabase = await initializeDatabase();
    }
    return _Ldatabase;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'l.db';

    var loanDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return loanDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $table($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colDescription TEXT, $colCost INTEGER, $colGiveOrTake INTEGER)');
  }

  //Fetch Operation
  Future<List<Map<String, dynamic>>> getLoanMapList() async{
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $table order by $colId DESC');
    return result;
  }

  //Insert Operation
  Future<int> insertLoan(Loan loan) async{
    Database db = await this.database;
    var result = await db.insert(table, loan.toMap());
    return result;
  }

  //Update Operation
  Future<int> updateLoan(Loan loan) async{
    Database db = await this.database;
    var result = await db.update(table, loan.toMap(), where:'$colId = ?', whereArgs: [loan.id]);
    return result;
  }

  //Delete Operation
  Future<int> deleteLoan(int id) async{
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

  Future<List<Loan>> getLoanList() async{
    var loanMapList = await getLoanMapList();
    int count = loanMapList.length;

    List<Loan> loanList = <Loan>[];
    for(int i = 0; i < count; i++){
      loanList.add(Loan.fromMapObject(loanMapList[i]));
    }
    return loanList;
  }
}
