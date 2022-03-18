import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:untitled1/data/local/my-shared.dart';
import 'package:untitled1/data/models/users.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void login({required String email, required String password}) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      getUserData();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        emit(LoginFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        emit(LoginFailure("Wrong password provided for that user."));
      } else {
        emit(LoginFailure(e.toString()));
      }
    }
  }

  void getUserData() {
    FirebaseFirestore.instance
        .collection("flutterUsers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
          (value) {
        print('user data => ${value.data()}');
        if (value.data() == null) return;

        var user = MyUser.fromJson(value.data());

        saveUserData(user);
      },
    );
  }

  void saveUserData(MyUser user) {
    MyShared.putString(key: "user", value: jsonEncode(user));

    MyShared.putString(key: "username", value: user.username);
    MyShared.putString(key: "profileImageUrl", value: user.profileImageUrl);

    emit(LoginSuccess());
  }
}