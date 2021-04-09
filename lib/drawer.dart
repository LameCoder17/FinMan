import 'package:finman/billSplit.dart';
import 'package:finman/expenses.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Drawer(
        child: Container(
          color: Color(0xFF706FD3),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height*0.3 , left: 20.00),
                child: ListTile(
                    title: Text(
                      'Expenses',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Color(0xFFF7F1E3)
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context){
                            return Expenses();
                          }
                      ));
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 20.00),
                child: ListTile(
                    title: Text(
                      'Bill Split',
                      style: TextStyle(
                          fontSize: 28.0,
                          color: Color(0xFFF7F1E3)
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context){
                            return BillSplit();
                          }
                      ));
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 20.00),
                child: ListTile(
                    title: Text(
                      'Reminders',
                      style: TextStyle(
                          fontSize: 28.0,
                          color: Color(0xFFF7F1E3)
                      ),
                    ),
                    onTap: null
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 20.00),
                child: ListTile(
                    title: Text(
                      'Loans',
                      style: TextStyle(
                          fontSize: 28.0,
                          color: Color(0xFFF7F1E3)
                      ),
                    ),
                    onTap: null
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0 ,left: 20.00),
                child: ListTile(
                    title: Text(
                      'Passwords',
                      style: TextStyle(
                          fontSize: 28.0,
                          color: Color(0xFFF7F1E3)
                      ),
                    ),
                    onTap: null
                ),
              )
            ],
          ),
        )
    );
  }
}