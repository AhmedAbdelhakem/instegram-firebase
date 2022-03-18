part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitialState extends PostsState {}

class PostsGetSuccessState extends PostsState {}

class PostsGetFailureState extends PostsState {}

class LikePostSuccessState extends PostsState {}

class UnLikePostSuccessState extends PostsState {}

class AddStorySuccessState extends PostsState {}

class AddStoryFailureState extends PostsState {
  final String errorMessage;

  AddStoryFailureState(this.errorMessage);
}


class GetHomeStoriesSuccessState extends PostsState {}

class GetStoriesDetailsSuccessState extends PostsState {
  final List<Story> storiesDetails;

  GetStoriesDetailsSuccessState(this.storiesDetails);
}


