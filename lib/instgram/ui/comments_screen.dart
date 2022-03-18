import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled1/data/local/my-shared.dart';
import 'package:untitled1/data/models/comment.dart';
import 'package:untitled1/instgram/logic/cubit/comments/comments_cubit.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late CommentsCubit commentsCubit;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentsCubit = context.read<CommentsCubit>();
    commentsCubit.getComments(postId: widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentsCubit, CommentsStates>(
      listener: (context, state) {
        if (state is CommentsAddCommentSuccessState) {
          commentsCubit.getComments(postId: widget.postId);
          controller.clear();
          hideLoaderDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            "Comments",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: buildCommentListView(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        MyShared.getString(key: "profileImageUrl")),
                    radius: 22.sp,
                  ),
                  SizedBox(
                    width: 10.sp,
                  ),
                  Expanded(
                      child: TextFormField(
                        controller: controller,
                        onFieldSubmitted: (value) {

                          showLoaderDialog(context);
                          commentsCubit.addComment(
                            postId: widget.postId,
                            commentContent: value,
                          );
                        },
                        textInputAction: TextInputAction.send,
                        style: const TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          hintText: "Add a comment",
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0.sp),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0.sp),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0.sp,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            space()
          ],
        ),
      ),
    );
  }

  space() {
    if (Platform.isIOS) {
      return SizedBox(
        height: 19.sp,
      );
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }

  Widget buildCommentListView() {
    return BlocBuilder<CommentsCubit, CommentsStates>(
      buildWhen: (previous, current) =>
      current is CommentsGetCommentSuccessState,
      builder: (context, state) {
        return ListView.builder(
          itemCount: commentsCubit.comments.length,
          itemBuilder: (context, index) {
            Comment comment = commentsCubit.comments[index];

            return Padding(
              padding: EdgeInsets.all(15.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage:
                    NetworkImage(comment.userImageUrl.toString()),
                    radius: 18.sp,
                  ),
                  SizedBox(
                    width: 10.sp,
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: comment.username,
                                    style:
                                    const TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: '  ${comment.comment}')
                              ])),
                          Text(
                            TimeAgo.timeAgoSinceDate(
                                comment.commentTime.toString()),
                            style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ))
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
    DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Loading...")),
      ],
    ),
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

hideLoaderDialog(BuildContext context){
  Navigator.pop(context);
}