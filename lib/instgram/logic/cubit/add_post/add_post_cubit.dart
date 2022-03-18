import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/data/models/posts.dart';

part 'add_post_state.dart';

class AddPostCubit extends Cubit<AddPostState> {
  AddPostCubit() : super(AddPostInitialState());

  late Post _post;

  void addPost({required String postContent, required File imageFile}) {
    _post = Post.newInstance(postContent: postContent);

    print(_post.toJson());
    _uploadImage(imageFile);
  }

  void _uploadImage(File imageFile) async {
    try {
      await FirebaseStorage.instance
      // .ref('uploads/file-to-upload.png')
          .ref('postsImages/${_post.postId}')
          .putFile(imageFile);

      _getImageUrl();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      emit(AddPostFailureState(e.toString()));
    }
  }

  void _getImageUrl() async {
    _post.postImageUrl = await FirebaseStorage.instance
        .ref('postsImages/${_post.postId}')
        .getDownloadURL();

    _insertNewPost();
  }

  void _insertNewPost() {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(_post.postId)
        .set(_post.toJson())
        .then((value) {
      emit(AddPostSuccessState());
    }).catchError((error) {
      emit(AddPostFailureState(error.toString()));
    });
  }
}