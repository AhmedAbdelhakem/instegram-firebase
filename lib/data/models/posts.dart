import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled1/data/local/my-shared.dart';

class Post {
  late String postId;
  late String userId;
  late String username;
  late String userImageUrl;
  final String postContent;
  late String postImageUrl;
  final double latitude;
  final double longitude;
  final String locationName;
  bool isLiked = false;
  int likesCount = 0;

  Post({
    required this.postContent,
    this.username = "",
    this.postImageUrl = "",
    this.postId = "",
    this.userId = "",
    this.userImageUrl = "",
    this.locationName = "Meeru island resort & spa",
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  Post.newInstance({
    required this.postContent,
    this.username = "",
    this.postImageUrl = "",
    this.postId = "",
    this.userId = "",
    this.userImageUrl = "",
    this.locationName = "Meeru island resort & spa",
    this.latitude = 0.0,
    this.longitude = 0.0,
  }) {
    postId = FirebaseAuth.instance.currentUser!.uid + DateTime.now().toString();
    userId = FirebaseAuth.instance.currentUser!.uid;
    username = MyShared.getString(key: "username");
    userImageUrl = MyShared.getString(key: "profileImageUrl");
  }

  Post.fromJson(Map<String, dynamic> json)
      : this(
    postId: json['postId']! as String,
    userId: json['userId']! as String,
    username: json['username']! as String,
    userImageUrl: json['userImageUrl']! as String,
    postContent: json['postContent']! as String,
    postImageUrl: json['postImageUrl']! as String,
    locationName: json['locationName']! as String,
    latitude: json['latitude']! as double,
    longitude: json['longitude']! as double,
  );

  Map<String, Object?> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'userImageUrl': userImageUrl,
      'postContent': postContent,
      'postImageUrl': postImageUrl,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}