/// commentId : ""
/// comment : ""
/// commentTime : ""
/// userId : ""
/// username : ""
/// userImageUrl : ""

class Comment {
  Comment({
    this.commentId,
    this.comment,
    this.commentTime,
    this.userId,
    this.username,
    this.userImageUrl,});

  Comment.fromJson(dynamic json) {
    commentId = json['commentId'];
    comment = json['comment'];
    commentTime = json['commentTime'];
    userId = json['userId'];
    username = json['username'];
    userImageUrl = json['userImageUrl'];
  }

  String? commentId;
  String? comment;
  String? commentTime;
  String? userId;
  String? username;
  String? userImageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['commentId'] = commentId;
    map['comment'] = comment;
    map['commentTime'] = commentTime;
    map['userId'] = userId;
    map['username'] = username;
    map['userImageUrl'] = userImageUrl;
    return map;
  }

}