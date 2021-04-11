class Expense
{
  int _id;
  String _description;
  int _money;

  Expense(this._description, this._money);
  Expense.withID(this._id,this._description,this._money);

  int get id => _id;
  String get description => _description;
  int get money => _money;

  set money(int newMoney){
    _money = newMoney;
  }

  set description(String newDescription){
    _description = newDescription;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(id != null){
      map['id'] = _id;
    }

    map['description'] = _description;
    map['money'] = _money;
  
    return map;
  }

  Expense.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._description = map['description'];
    this._money = map['money'];
  }
}