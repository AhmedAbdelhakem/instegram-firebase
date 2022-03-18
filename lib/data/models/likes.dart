/// userId : ""
/// username : ""

class Like {
  Like({
    String? userId,
    String? username,}){
    _userId = userId;
    _username = username;
  }

  Like.fromJson(dynamic json) {
    _userId = json['userId'];
    _username = json['username'];
  }
  String? _userId;
  String? _username;

  String? get userId => _userId;
  String? get username => _username;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['username'] = _username;
    return map;
  }

}