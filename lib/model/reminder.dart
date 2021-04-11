class Reminder
{
  int _id;
  String _title;
  String _description;
  int _cost;

  Reminder(this._title,this._description, this._cost);
  Reminder.withID(this._id,this._title,this._description,this._cost);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get cost => _cost;

  set cost(int newCost){
    _cost = newCost;
  }

  set description(String newDescription){
    _description = newDescription;
  }

  set title(String newTitle){
    _title = newTitle;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(id != null){
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['cost'] = _cost;

    return map;
  }

  Reminder.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._cost = map['cost'];
  }
}