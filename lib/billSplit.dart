import 'package:finman/drawer.dart';
import 'package:flutter/material.dart';

class BillSplit extends StatefulWidget {
  BillSplit({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BillSplitState createState() => _BillSplitState();
}

class _BillSplitState extends State<BillSplit> {
  TextEditingController noOfPeople = TextEditingController();
  TextEditingController cost = TextEditingController();
  var perPersonCost = 0.0;
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF474787),
      appBar: AppBar(
        title: Text(
          'Bill Split',
          style: TextStyle(fontSize: 28, color: Color(0xFFF7F1E3)),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xFF706FD3),
      ),
      drawer: MyDrawer(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 40.0, right: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 20.0),
                    child: Text(
                      "Number of people",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 24.0, color: Color(0xFFF7F1E3)),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.8,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: noOfPeople,
                      onChanged: (val) {
                        setState(() {
                          print(noOfPeople.text);
                        });
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter number of people';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'People',
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.0, bottom: 20.0),
                    child: Text(
                      "Cost",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 24.0, color: Color(0xFFF7F1E3)),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.8,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: cost,
                      onChanged: (val) {
                        setState(() {
                          print(cost.text);
                        });
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter cost';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Cost',
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0, left: width/5, right: width/5),
            child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Color(0xFF706FD3)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  displayCost(noOfPeople.text, cost.text);
                }
              },
              child: Text(
                'Split the Bill',
                style: TextStyle(fontSize: 26, color: Color(0xFFF7F1E3)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.1),
            child: Text(
              'Per Person Cost is',
              style: TextStyle(
                  fontSize: 26,
                  color: Color(0xFFF7F1E3),
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text(
              perPersonCost.toStringAsFixed(2),
              style: TextStyle(fontSize: 28, color: Color(0xFFF7F1E3)),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  displayCost(var people, var cost) {
    if (people != null && cost != null) {
      print(people);
      print(cost);
      double p = double.parse(people);
      double c = double.parse(cost);
      setState(() {
        perPersonCost = c / p;
      });
    }
  }
}

_displayDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Additional Information'),
          content: Text(
              'Wavelength - 550 nm \n RGB Value - 255, 87, 105 \n Intensity - 530 W/m'),
          actions: <Widget>[
            new TextButton(
              child: new Text('Okay'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
