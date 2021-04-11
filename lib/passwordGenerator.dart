import 'package:finman/utils/generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordGenerator extends StatefulWidget {
  PasswordGenerator({Key key, this.title}) : super(key: key);

  final String title;
  State<StatefulWidget> createState() => new PasswordGeneratorState();
}

class PasswordGeneratorState extends State<PasswordGenerator> {
  Generator _generator = new Generator();
  bool _letterCheckBool = true;
  bool _numCheckBool = false;
  bool _symCheckBool = false;
  double _sliderVal = 6.0;
  final GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();

  void generate() {
    setState(() {
      _generator.generate(_sliderVal.round());
    });
  }

  void letterCheck(bool value) {
    setState((){
      _generator.checkLetterGen(value);
      _letterCheckBool = value;
    });
  }

  void numCheck(bool value) {
    setState(() {
      _generator.checkNumGen(value);
      _numCheckBool = value;
    });
  }

  void symCheck(bool value) {
    setState(() {
      _generator.checkSymGen(value);
      _symCheckBool = value;
    });
  }

  void sliderChange(double value) {
    setState(() {
      _sliderVal = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Color(0xFF474787),
      appBar: AppBar(
        title: Text('Password Generator'),
        backgroundColor: Color(0xFF706FD3),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.assignment),
            tooltip: "Copy",
            onPressed: () {
              final snackBar = SnackBar(content: Text('Copied'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Clipboard.setData(new ClipboardData(text: _generator.getGeneratedValue()));
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                _generator.getGeneratedValue(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF7F1E3),
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width*0.3, right: width*0.3),
            child: TextButton(
              onPressed: generate,
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Color(0xFF706FD3)),
              child: Text("Generate", style: TextStyle(color: Color(0xFFF7F1E3)),),
            ),
          ),
          Column(
            children: <Widget>[
              CheckboxListTile(
                title: Text("Use letters", style: TextStyle(color: Color(0xFFF7F1E3)),),
                activeColor: Color(0xFF706FD3),
                value: _letterCheckBool,
                onChanged: (bool value){letterCheck(value);},
              ),
              CheckboxListTile(
                title: Text("Use numbers", style: TextStyle(color: Color(0xFFF7F1E3)),),
                activeColor: Color(0xFF706FD3),
                value: _numCheckBool,
                onChanged: (bool value){numCheck(value);},
              ),
              CheckboxListTile(
                title: Text("Use symbols", style: TextStyle(color: Color(0xFFF7F1E3)),),
                activeColor: Color(0xFF706FD3),
                value: _symCheckBool,
                onChanged: (bool value){symCheck(value);},
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Slider(
                  value: _sliderVal,
                  onChanged: (double value){sliderChange(value);},
                  activeColor: Color(0xFF706FD3),
                  label: "Number of characters",
                  divisions: 64,
                  min: 6.0,
                  max: 64.0,
                ),
              ),
              Container(
                width: 50.0,
                child: Text(
                  _sliderVal.round().toString(),style: TextStyle(color: Color(0xFFF7F1E3)),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}