import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:untitled1/data/local/my-shared.dart';
import 'package:untitled1/data/models/posts.dart';
import 'package:untitled1/data/models/story.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitialState());

  List<Post> posts = [];

  void getPosts() {
    print('Posts => ${posts.length}');

    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      posts.clear();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

        var likes = await FirebaseFirestore.instance
            .collection("posts")
            .doc(json["postId"])
            .collection("likes")
            .get();

        Post post = Post.fromJson(json);
        post.likesCount = likes.docs.length;

        for (var element in likes.docs) {
          if (element.data()["userId"] ==
              FirebaseAuth.instance.currentUser!.uid) {
            post.isLiked = true;
          } else {
            post.isLiked = false;
          }
        }

        posts.add(post);
      }

      emit(PostsGetSuccessState());
    });
  }

  // void likeUnLikePost(Post post) {
  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //
  //   FirebaseFirestore.instance
  //       .collection("posts")
  //       .doc(post.postId)
  //       .collection("likes")
  //       .doc(uid)
  //       .get()
  //       .then(
  //     (value) {
  //       if (value.data() == null) {
  //         _likePost(post.postId);
  //       } else {
  //         _unLikePost(post.postId);
  //       }
  //     },
  //   );
  // }

  void likePost(String postId) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(uid)
        .set({"userId": uid});

    emit(LikePostSuccessState());
  }

  void unLikePost(String postId) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(uid)
        .delete();

    emit(UnLikePostSuccessState());
  }

  void addStory(File file) async {
    String ref =
        'stories/${FirebaseAuth.instance.currentUser!.uid + DateTime.now().toString()}';
    // 1 upload image
    await _uploadImage(file, ref);
    // 2 get image url
    String storyImageUrl = await _getImageUrl(ref);
    print('storyImageUrl => $storyImageUrl');
    // 3 add on firestore
    await _insertUserData(storyImageUrl);
  }

  Future<bool> _uploadImage(File imageFile, String ref) async {
    try {
      await FirebaseStorage.instance.ref(ref).putFile(imageFile);

      return true;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      emit(AddStoryFailureState(e.toString()));
    }
    return false;
  }

  Future<String> _getImageUrl(String ref) async {
    String imageUrl = await FirebaseStorage.instance.ref(ref).getDownloadURL();

    return imageUrl;
  }

  Future<bool> _insertUserData(String storyImageUrl) async {
    Story story = Story(
      username: MyShared.getString(key: "username"),
      userId: FirebaseAuth.instance.currentUser!.uid,
      userImageUrl: MyShared.getString(key: "profileImageUrl"),
      storyImageUrl: storyImageUrl,
      storyTime: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    FirebaseFirestore.instance
        .collection("stories")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(story.toJson());

    FirebaseFirestore.instance
        .collection("stories")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("myStories")
        .doc(story.storyTime)
        .set(story.toJson())
        .then((value) {
      emit(AddStorySuccessState());
      getHomeStories();
      return true;
    }).catchError((error) {
      emit(AddStoryFailureState(error.toString()));
    });

    return false;
  }

  List<Story> storiesDetails = [];

  List<Story> homeStories = [];

  void getHomeStories() {
    FirebaseFirestore.instance.collection("stories").get().then((value) {
      homeStories.clear();
      for (var element in value.docs) {
        Story story = Story.fromJson(element.data());

        const int day = 86400000;
        int currentMillis = DateTime.now().millisecondsSinceEpoch;
        int storyMillis = int.tryParse(story.storyTime!) ?? 0;
        int betweenMillis = currentMillis - storyMillis;
        bool isLessThanDay = betweenMillis < day;

        print('currentMillis $currentMillis');
        print('storyMillis $storyMillis');
        print('day $day');
        print('betweenMillis $betweenMillis');
        print('isLessThanDay $isLessThanDay');

        if (isLessThanDay) {
          homeStories.add(story);
        }

      }
      emit(GetHomeStoriesSuccessState());
    });
  }

  void getStoriesDetails(String userId) {
    FirebaseFirestore.instance
        .collection("stories")
        .doc(userId)
        .collection("myStories")
        .get()
        .then((value) {
      print('story docs => ${value.docs.length}');
      storiesDetails.clear();
      for (var element in value.docs) {
        Story story = Story.fromJson(element.data());

        const int day = 86400000;
        int currentMillis = DateTime.now().millisecondsSinceEpoch;
        int storyMillis = int.tryParse(story.storyTime!) ?? 0;
        int betweenMillis = currentMillis - storyMillis;
        bool isLessThanDay = betweenMillis < day;

        print('currentMillis $currentMillis');
        print('storyMillis $storyMillis');
        print('day $day');
        print('betweenMillis $betweenMillis');
        print('isLessThanDay $isLessThanDay');

        if (isLessThanDay) {
          storiesDetails.add(story);
        }
      }
      print(storiesDetails.length);
      emit(GetStoriesDetailsSuccessState(storiesDetails));
    });
  }
}