import 'package:finman/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
            padding:
                EdgeInsets.only(top: height * 0.1, left: 40.0, right: 40.0),
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
                          'Rs 100',
                          style: TextStyle(
                              fontSize: 26.0, color: Color(0xFFF7F1E3)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: width * 0.5,
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
                            },
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
