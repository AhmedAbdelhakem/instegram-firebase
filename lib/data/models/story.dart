/// username : ""
/// userId : ""
/// userImageUrl : ""
/// storyImageUrl : ""
/// storyTime : ""

class Story {
  Story({
    String? username,
    String? userId,
    String? userImageUrl,
    String? storyImageUrl,
    String? storyTime,}){
    _username = username;
    _userId = userId;
    _userImageUrl = userImageUrl;
    _storyImageUrl = storyImageUrl;
    _storyTime = storyTime;
  }

  Story.fromJson(dynamic json) {
    _username = json['username'];
    _userId = json['userId'];
    _userImageUrl = json['userImageUrl'];
    _storyImageUrl = json['storyImageUrl'];
    _storyTime = json['storyTime'];
  }
  String? _username;
  String? _userId;
  String? _userImageUrl;
  String? _storyImageUrl;
  String? _storyTime;

  String? get username => _username;
  String? get userId => _userId;
  String? get userImageUrl => _userImageUrl;
  String? get storyImageUrl => _storyImageUrl;
  String? get storyTime => _storyTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['userId'] = _userId;
    map['userImageUrl'] = _userImageUrl;
    map['storyImageUrl'] = _storyImageUrl;
    map['storyTime'] = _storyTime;
    return map;
  }

}