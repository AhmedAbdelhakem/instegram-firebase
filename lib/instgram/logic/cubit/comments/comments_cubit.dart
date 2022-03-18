import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:untitled1/data/local/my-shared.dart';
import 'package:untitled1/data/models/comment.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsStates> {
  CommentsCubit() : super(CommentsInitialState());

  List<Comment> comments = [];

  void addComment({
    required String postId,
    required String commentContent,
  }) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    Comment comment = Comment(
      commentId: uid + DateTime.now().toString().replaceAll(" ", ""),
      comment: commentContent,
      username: MyShared.getString(key: "username"),
      userId: uid,
      userImageUrl: MyShared.getString(key: "profileImageUrl"),
      commentTime: DateTime.now().toString(),
    );

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(comment.commentId)
        .set(comment.toJson())
        .then((value) => emit(CommentsAddCommentSuccessState()))
        .catchError((error) => emit(
      CommentsAddCommentFailureState(error.toString()),
    ));
  }

  void getComments({required String postId}) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .get()
        .then(
          (value) {
        comments.clear();

        value.docs.forEach(
              (element) {
            var json = element.data();

            var comment = Comment.fromJson(json);

            comments.add(comment);
          },
        );

        emit(CommentsGetCommentSuccessState());
      },
    ).catchError((error) {
      emit(CommentsGetCommentFailureState(error.toString()));
    });
  }
}