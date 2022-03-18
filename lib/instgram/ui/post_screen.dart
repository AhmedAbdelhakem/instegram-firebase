import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled1/instgram/logic/cubit/add_post/add_post_cubit.dart';
import 'my_snack_bar.dart';

class PostScreen extends StatefulWidget {
  final File imageFile;

  const PostScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late AddPostCubit cubit;

  @override
  Widget build(BuildContext context) {
    //cubit = BlocProvider.of<AddPostCubit>(context);
    cubit = context.read<AddPostCubit>();

    return BlocListener<AddPostCubit, AddPostState>(
      listener: (context, state) {
        if (state is AddPostSuccessState) {
          Navigator.pop(context);
        } else if (state is AddPostFailureState) {
          showSnackBar(context, state.errorMessage);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            "New Post",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(50.sp),
              onTap: () => addNewPost(),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 15.sp),
                child: Text(
                  "Share",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 18.sp),
                ),
              ),
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.sp),
                  width: 30.w,
                  child: Image.file(
                    widget.imageFile,
                    fit: BoxFit.contain,
                  )),
              Expanded(
                child: TextFormField(
                  controller: contentController,
                  validator: (value) => value != null ? null :value.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  decoration: InputDecoration(
                      hintText: "Write a caption.",
                      border: InputBorder.none,
                      hintStyle:
                      TextStyle(color: Colors.grey, fontSize: 16.sp)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addNewPost() {
    if (formKey.currentState!.validate()) {
      cubit.addPost(
        postContent: contentController.text,
        imageFile: widget.imageFile,
      );
    }
  }
}