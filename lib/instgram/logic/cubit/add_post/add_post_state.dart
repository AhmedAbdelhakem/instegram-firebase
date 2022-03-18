part of 'add_post_cubit.dart';

@immutable
abstract class AddPostState {}

class AddPostInitialState extends AddPostState {}

class AddPostSuccessState extends AddPostState {}

class AddPostFailureState extends AddPostState {
  final String errorMessage;

  AddPostFailureState(this.errorMessage);
}