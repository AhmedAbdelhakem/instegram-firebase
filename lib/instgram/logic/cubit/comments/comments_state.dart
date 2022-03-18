part of 'comments_cubit.dart';

@immutable
abstract class CommentsStates {}

class CommentsInitialState extends CommentsStates {}

class CommentsAddCommentSuccessState extends CommentsStates {}

class CommentsAddCommentFailureState extends CommentsStates {
  final String errorMessage;

  CommentsAddCommentFailureState(this.errorMessage);
}

class CommentsGetCommentSuccessState extends CommentsStates {}

class CommentsGetCommentFailureState extends CommentsStates {
  final String errorMessage;

  CommentsGetCommentFailureState(this.errorMessage);
}