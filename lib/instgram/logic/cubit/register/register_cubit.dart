import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  void register({
    required String email,
    required String password,
  }) async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
          (value) {
        emit(RegisterSuccessState());
      },
    ).catchError(
          (error) {
        if (error is FirebaseAuthException && error.code == 'weak-password') {
          emit(RegisterFailureState("The password provided is too weak."));
        } else if (error is FirebaseAuthException &&
            error.code == 'email-already-in-use') {
          emit(RegisterFailureState(
              "The account already exists for that email."));
        } else {
          emit(RegisterFailureState(error.toString()));
        }
      },
    );
  }

}
