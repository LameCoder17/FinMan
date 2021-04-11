import 'package:finman/drawer.dart';
import 'package:finman/utils/expenseHelper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'model/expense.dart';

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  String inputMoney;
  String desc;
  ExpenseDatabaseHelper helper = ExpenseDatabaseHelper();
  List<Expense> expensesList;
  Expense e = Expense('',0);
  int total;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if(expensesList == null) {
      expensesList = <Expense>[];
      updateListView();
    }
    return Scaffold(
      backgroundColor: Color(0xFF474787),
      appBar: AppBar(
        title: Text(
          'Expenses',
          style: TextStyle(fontSize: 28,  color: Color(0xFFF7F1E3)),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xFF706FD3),
      ),
      drawer: MyDrawer(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.1, left: 40.0, right: 40.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFF706FD3),
                  borderRadius: BorderRadius.all(Radius.circular(20.00))),
              child: Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, left: 20.0, right: 20.0, bottom: 15.0),
                        child: Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 32.0, color: Color(0xFFF7F1E3), fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5.0, left: 20.0, right: 20.0, bottom: 20.0),
                        child: Text(
                          'Rs $total',
                          style: TextStyle(
                              fontSize: 26.0, color: Color(0xFFF7F1E3)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: width * 0.45,
                  ),
                  Column(
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.only(left: 5.0, right: 5.0),
                          child: GestureDetector(
                            child: Icon(FontAwesomeIcons.plus,
                            color: Color(0xFF33D9B2)),
                            onTap: (){
                              debugPrint('Plus');
                              _moneyDialog(context, 'Add Money');
                            },
                          )),
                      Padding(
                          padding:
                              EdgeInsets.only(top: 30.0, left: 5.0, right: 5.0),
                          child: GestureDetector(
                            child: Icon(FontAwesomeIcons.minus,
                            color: Color(0xFFFF5252)),
                            onTap: (){
                              debugPrint('Minus');
                              _moneyDialog(context, 'Subtract Money');
                            },
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
            child: getAllExpenseListView(),
          )
        ],
      ),
    );
  }

  _moneyDialog(BuildContext context, String action) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(action, style: TextStyle(color: Color(0xFFF7F1E3)),),
          backgroundColor: Color(0xFF40407A),
          insetPadding: EdgeInsets.only(top: height*0.33, left: width*0.25, right: width*0.25, bottom: height*0.33),
          content: Column(
            children: [
              TextField(
                style: TextStyle(color: Color(0xFFF7F1E3)),
                    decoration: InputDecoration(
                        labelText: 'Reason',
                    labelStyle: TextStyle(color: Color(0xFFF7F1E3))),
                    onChanged: (value) {
                      print(value);
                      e.description = value;
                    },
                  ),
              TextField(
                keyboardType: TextInputType.number,
                    style: TextStyle(color: Color(0xFFF7F1E3)),
                    decoration: InputDecoration(
                        labelText: 'Money',
                    labelStyle: TextStyle(color: Color(0xFFF7F1E3))),
                    onChanged: (value) {
                      if(action == 'Add Money'){
                        e.money = int.parse(value);
                      }
                      else{
                        e.money = -int.parse(value);
                      }
                    },
                  )
            ],
          ),
          actions: [
            TextButton(
              child: Text('Ok',  style: TextStyle(color: Color(0xFFF7F1E3), fontSize: 22.0)),
              onPressed: () {
                  _save();
                },
            ),
          ],
        );
      },
    );
  }

  void _save() async {
    int result = 0;

    if(e.money == 0){
      Navigator.of(context).pop();
    }
    result = await helper.insertExpense(e);

    if(result != 0) {
      _displaySnackBar('Operation Successful');
      updateListView();
    }
    else {
      _displaySnackBar('Operation Failed');
    }
    Navigator.of(context).pop();
  }

  void _delete(BuildContext context, Expense e) async {
    int result = await helper.deleteExpense(e.id);
    if(result != 0)
    {
      _displaySnackBar('Removed Successfully');
      updateListView();
    }
  }

  ListView getAllExpenseListView() {
    return ListView.builder(
      itemCount: count,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int position) {
        return Dismissible(
          key: Key(this.expensesList[position].id.toString()),
          child: Card(
            color: Color(0xFF40407A),
            elevation: 1.0,
            child: ListTile(
              leading: upOrDown(this.expensesList[position].money),
              title: Text(this.expensesList[position].description, style: TextStyle(color: Color(0xFFF7F1E3)),),
              trailing: plusOrMinus(this.expensesList[position].money),
              onTap: () {
                debugPrint("ListTile Tapped");
              },
            ),
          ),
          onDismissed: (direction){
              _delete(context, this.expensesList[position]);
          },
        );
      },
    );
  }

  plusOrMinus(int money){
    if(money>0){
      return Text('+'+ money.toString(), style: TextStyle(color: Color(0xFF33D9B2)),);
    }
    else{
      return Text(money.toString(), style: TextStyle(color: Color(0xFFFF5252)),);
    }
  }

  upOrDown(int money){
    if(money>0){
      return Icon(FontAwesomeIcons.arrowUp, color: Color(0xFF33D9B2),);
    }
    else{
      return Icon(FontAwesomeIcons.arrowDown, color: Color(0xFFFF5252));
    }
  }

  calculateTotal(){
    int sum = 0;
    expensesList.forEach((e) => sum += e.money);
    return sum;
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Expense>> noteListFuture = helper.getExpenseList();
      noteListFuture.then((elist){
        setState(() {
          this.expensesList = elist;
          this.count = elist.length;
          total = calculateTotal();
        });
      });

    });
  }

  _displaySnackBar(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
