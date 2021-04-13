import 'package:finman/drawer.dart';
import 'package:finman/passwordGenerator.dart';
import 'package:finman/utils/passwordHelper.dart';
import 'package:finman/utils/reminderHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'model/password.dart';
import 'model/reminder.dart';

class Passwords extends StatefulWidget {
  @override
  _PasswordsState createState() => _PasswordsState();
}

class _PasswordsState extends State<Passwords> {
  String title;
  String email;
  String pass;
  PasswordDatabaseHelper helper = PasswordDatabaseHelper();
  List<Password> passwordList;
  Password p = Password('','','');
  int count = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if(passwordList == null) {
      passwordList = <Password>[];
      updateListView();
    }
    return Scaffold(
      backgroundColor: Color(0xFF474787),
      appBar: AppBar(
        title: Text(
          'Passwords',
          style: TextStyle(fontSize: 28,  color: Color(0xFFF7F1E3)),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xFF706FD3),
      ),
      drawer: MyDrawer(),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.only(top: height * 0.1, left: 40.0, right: 40.0),
          child: Padding(
            padding: EdgeInsets.only(left: width*0.2, right: width*0.2),
            child: TextButton(
              child: Text('Generate Password',textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, color: Color(0xFFF7F1E3)),),
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Color(0xFF706FD3)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return PasswordGenerator();
                    }
                ));
              },
            ),
          ),),
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
          _passwordDialog(context);
        },
      ),
    );
  }

  _passwordDialog(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Store Password', style: TextStyle(color: Color(0xFFF7F1E3)),),
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
                        labelStyle: TextStyle(color: Color(0xFFF7F1E3)),),
                      onChanged: (value) {
                        print(value);
                        p.title = value;
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                    child: TextFormField(
                      style: TextStyle(color: Color(0xFFF7F1E3)),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Enter email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email ID',
                        labelStyle: TextStyle(color: Color(0xFFF7F1E3)),),
                      onChanged: (value) {
                        print(value);
                        p.emailID = value;
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                    child: TextFormField(
                      style: TextStyle(color: Color(0xFFF7F1E3)),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Enter password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Color(0xFFF7F1E3)),),
                      onChanged: (value) {
                        p.password = value;
                      },
                    ))
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Save', style: TextStyle(color: Color(0xFFF7F1E3), fontSize: 22.0),),
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

    result = await helper.insertPassword(p);
    if(result != 0) {
      _displaySnackBar('Operation Successful');
      updateListView();
    }
    else {
      _displaySnackBar('Operation Failed');
    }
    Navigator.of(context).pop();
  }

  void _delete(BuildContext context, Password p) async {
    int result = await helper.deletePassword(p.id);
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
          key: Key(this.passwordList[position].id.toString()),
          child: Card(
            color: Color(0xFF40407A),
            elevation: 1.0,
            child: ListTile(
              title: Text(this.passwordList[position].title + '\n', style: TextStyle(fontSize: 22.0, color: Color(0xFFF7F1E3)),),
              subtitle: Text(this.passwordList[position].emailID + '\n' + this.passwordList[position].password, style: TextStyle(fontSize: 18.0, color: Color(0xFFF7F1E3)),),
              onTap: () {
                debugPrint("ListTile Tapped");
              },
            ),
          ),
          onDismissed: (direction){
            _delete(context, this.passwordList[position]);
          },
        );
      },
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Password>> noteListFuture = helper.getPasswordList();
      noteListFuture.then((plist){
        setState(() {
          this.passwordList = plist;
          this.count = plist.length;
        });
      });

    });
  }

  _displaySnackBar(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
