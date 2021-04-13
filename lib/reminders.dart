import 'package:finman/drawer.dart';
import 'package:finman/utils/reminderHelper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'model/reminder.dart';

class Reminders extends StatefulWidget {
  @override
  _RemindersState createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  String title;
  String desc;
  String cost;
  ReminderDatabaseHelper helper = ReminderDatabaseHelper();
  List<Reminder> reminderList;
  Reminder r = Reminder('','',0);
  int count = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if(reminderList == null) {
      reminderList = <Reminder>[];
      updateListView();
    }
    return Scaffold(
      backgroundColor: Color(0xFF474787),
      appBar: AppBar(
        title: Text(
          'Reminders',
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
            padding: EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
            child: getAllExpenseListView(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus, color: Color(0xFF474787)),
        backgroundColor: Color(0xFF706FD3),
        onPressed: (){
          _moneyDialog(context);
        },
      ),
    );
  }

  _moneyDialog(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Reminder', style: TextStyle(color: Color(0xFFF7F1E3)),),
          backgroundColor: Color(0xFF40407A),
          insetPadding: EdgeInsets.only(top: height*0.25, left: width*0.25, right: width*0.25, bottom: height*0.25),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                    child: TextFormField(
                      style: TextStyle(color: Color(0xFFF7F1E3)),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Enter title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Color(0xFFF7F1E3))),
                      onChanged: (value) {
                        print(value);
                        r.title = value;
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                    child: TextFormField(
                      style: TextStyle(color: Color(0xFFF7F1E3)),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Enter description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Color(0xFFF7F1E3))),
                      onChanged: (value) {
                        print(value);
                        r.description = value;
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                    child: TextFormField(
                      style: TextStyle(color: Color(0xFFF7F1E3)),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Enter cost';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Cost',
                          labelStyle: TextStyle(color: Color(0xFFF7F1E3))),
                      onChanged: (value) {
                        r.cost = int.parse(value);
                      },
                    ))
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Save', style: TextStyle(color: Color(0xFFF7F1E3), fontSize: 22.0)),
              onPressed: () {
                if(_formKey.currentState.validate()){
                  _save();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _save() async {
    int result = 0;

    result = await helper.insertReminder(r);
    if(result != 0) {
      _displaySnackBar('Operation Successful');
      updateListView();
    }
    else {
      _displaySnackBar('Operation Failed');
    }
    Navigator.of(context).pop();
  }

  void _delete(BuildContext context, Reminder r) async {
    int result = await helper.deleteReminder(r.id);
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
          key: Key(this.reminderList[position].id.toString()),
          child: Card(
            color: Color(0xFF40407A),
            elevation: 1.0,
            child: ListTile(
              title: Text(this.reminderList[position].title, style: TextStyle(fontSize: 22.0, color: Color(0xFFF7F1E3)),),
              subtitle: Text(this.reminderList[position].description, style: TextStyle(fontSize: 16.0, color: Color(0xFFF7F1E3)),),
              trailing: Text(this.reminderList[position].cost.toString(), style: TextStyle(fontSize: 18.0, color: Color(0xFFF7F1E3)),),
              onTap: () {
                debugPrint("ListTile Tapped");
              },
            ),
          ),
          onDismissed: (direction){
            _delete(context, this.reminderList[position]);
          },
        );
      },
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Reminder>> noteListFuture = helper.getReminderList();
      noteListFuture.then((rlist){
        setState(() {
          this.reminderList = rlist;
          this.count = rlist.length;
        });
      });

    });
  }

  _displaySnackBar(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
