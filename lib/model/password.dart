class Password
{
  int _id;
  String _title;
  String _emailID;
  String _password;

  Password(this._title,this._emailID, this._password);
  Password.withID(this._id,this._title,this._emailID, this._password);

  int get id => _id;
  String get title => _title;
  String get emailID => _emailID;
  String get password => _password;

  set title(String newTitle){
    _title = newTitle;
  }

  set emailID(String newEmailID){
    _emailID = newEmailID;
  }

  set password(String newPassword){
    _password = newPassword;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(id != null){
      map['id'] = _id;
    }

    map['title'] = _title;
    map['emailID'] = _emailID;
    map['password'] = _password;

    return map;
  }

  Password.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._emailID = map['emailID'];
    this._password = map['password'];
  }
}