class Loan
{
  int _id;
  String _name;
  String _description;
  int _cost;
  int _giveOrTake;

  Loan(this._name,this._description, this._cost, this._giveOrTake);
  Loan.withID(this._id,this._name,this._description,this._cost, this._giveOrTake);

  int get id => _id;
  String get name => _name;
  String get description => _description;
  int get cost => _cost;
  int get giveOrTake => _giveOrTake;

  set cost(int newCost){
    _cost = newCost;
  }

  set giveOrTake(int newGiveOrTake){
    _giveOrTake = newGiveOrTake;
  }

  set description(String newDescription){
    _description = newDescription;
  }

  set name(String newName){
    _name = newName;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(id != null){
      map['id'] = _id;
    }

    map['name'] = _name;
    map['description'] = _description;
    map['cost'] = _cost;
    map['giveOrTake'] = _giveOrTake;

    return map;
  }

  Loan.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._cost = map['cost'];
    this._giveOrTake = map['giveOrTake'];
  }
}