import 'package:finman/drawer.dart';
import 'package:finman/utils/loanHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'model/loan.dart';

class Loans extends StatefulWidget {
  @override
  _LoansState createState() => _LoansState();
}

class _LoansState extends State<Loans> {
  String title;
  String reason;
  String cost;
  int giveOrTake;
  LoanDatabaseHelper helper = LoanDatabaseHelper();
  List<Loan> loanList;
  Loan l = Loan('','',0,0);
  int count = 0;
  int balance = 0;
  List<String> theList = ['You gave', 'You got'];
  String _sel;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if(loanList == null) {
      loanList = <Loan>[];
      updateListView();
    }
    return Scaffold(
      backgroundColor: Color(0xFF474787),
      appBar: AppBar(
        title: Text(
          'Loans',
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
            padding:
            EdgeInsets.only(top: height * 0.1, left: 40.0, right: 40.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFF706FD3),
                  borderRadius: BorderRadius.all(Radius.circular(20.00))),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0, bottom: 15.0),
                    child: Text(
                      'Balance',
                      style: TextStyle(
                          fontSize: 24.0, color: Color(0xFFF7F1E3), fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: width*0.3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0, bottom: 15.0),
                    child: Text(
                      'Rs $balance',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 24.0, color: Color(0xFFF7F1E3)),
                    ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus, color: Color(0xFF474787)),
        backgroundColor: Color(0xFF706FD3),
        onPressed: (){
          _addPersonDialog(context);
        },
      ),
    );
  }

  _addPersonDialog(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF40407A),
          title: Text('Add Loan', style: TextStyle(color: Color(0xFFF7F1E3)),),
          insetPadding: EdgeInsets.only(top: height*0.2, left: width*0.25, right: width*0.25, bottom: height*0.2),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: TextField(
                        style: TextStyle(color: Color(0xFFF7F1E3)),
                        decoration: InputDecoration(
                            labelText: 'Name',
                        labelStyle: TextStyle(color: Color(0xFFF7F1E3)),),
                        onChanged: (value) {
                          print(value);
                          l.name = value;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                      child: TextField(
                        style: TextStyle(color: Color(0xFFF7F1E3)),
                        decoration: InputDecoration(
                            labelText: 'Description',
                        labelStyle: TextStyle(color: Color(0xFFF7F1E3)),),
                        onChanged: (value) {
                          print(value);
                          l.description = value;
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Color(0xFFF7F1E3)),
                        decoration: InputDecoration(
                            labelText: 'Cost',
                        labelStyle: TextStyle(color: Color(0xFFF7F1E3)),),
                        onChanged: (value) {
                          l.cost = int.parse(value);
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: DropdownButton(
                      dropdownColor: Color(0xFF40407A),
                      hint: _sel == null
                          ? Text('Choose', style: TextStyle(color: Color(0xFFF7F1E3)),)
                          : Text(_sel, style: TextStyle(color: Color(0xFFF7F1E3)),),
                      items: theList.map((e){
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e, style: TextStyle(color: Color(0xFFF7F1E3)),),
                        );
                      },).toList(),
                      onChanged: (val){
                        setState(() {
                          _sel = val;
                        });
                      },
                    ),)],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Save', style: TextStyle(color: Color(0xFFF7F1E3), fontSize: 22.0),),
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

    if(l.name == ''){
      _displaySnackBar('Empty name');
      Navigator.of(context).pop();
    }

    if(_sel == 'You gave'){
      l.giveOrTake = 0;
    }
    else{
      l.giveOrTake = 1;
    }

    _sel = null;
    result = await helper.insertLoan(l);
    if(result != 0) {
      _displaySnackBar('Operation Successful');
      updateListView();
    }
    else {
      _displaySnackBar('Operation Failed');
    }
    Navigator.of(context).pop();
  }

  void _delete(BuildContext context, Loan l) async {
    int result = await helper.deleteLoan(l.id);
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
          key: Key(this.loanList[position].id.toString()),
          child: Card(
            color: Color(0xFF40407A),
            elevation: 1.0,
            child: ListTile(
              title: Text(this.loanList[position].name, style: TextStyle(color: Color(0xFFF7F1E3), fontSize: 22.0),),
              subtitle: Text(this.loanList[position].description, style: TextStyle(color: Color(0xFFF7F1E3), fontSize: 16.0),),
              trailing: loanTakenOrNot(this.loanList[position]),
              onTap: () {
                debugPrint("ListTile Tapped");
              },
            ),
          ),
          onDismissed: (direction){
            _delete(context, this.loanList[position]);
          },
        );
      },
    );
  }

  loanTakenOrNot(Loan l){
    if(l.giveOrTake == 0){
      return Text('+' + l.cost.toString(), style: TextStyle(color: Color(0xFFF7F1E3), fontSize: 18.0),);
    }
    else{
      return Text('-' + l.cost.toString(), style: TextStyle(color: Color(0xFFF7F1E3), fontSize: 18.0),);
    }
  }

  findBalance(){
    int sum = 0;
    loanList.forEach((e) {
      if(e.giveOrTake == 0){
        sum += e.cost;
    }else{
        sum -= e.cost;
      }
    });
    return sum;
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Loan>> noteListFuture = helper.getLoanList();
      noteListFuture.then((llist){
        setState(() {
          this.loanList = llist;
          this.count = llist.length;
          balance = findBalance();
        });
      });

    });
  }

  _displaySnackBar(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
