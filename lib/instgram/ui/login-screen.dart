import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled1/instgram/logic/cubit/login/login_cubit.dart';
import 'package:untitled1/instgram/logic/cubit/register/register_cubit.dart';
import 'package:untitled1/instgram/logic/validators.dart';
import 'package:untitled1/instgram/ui/components.dart';
import 'package:untitled1/instgram/ui/home_screen.dart';
import 'package:untitled1/instgram/ui/register_screen.dart';

// BlocConsumer => listener , builder
// BlocBuilder , BlocListener

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  bool isPasswordVisable = false;

  var formKey = GlobalKey<FormState>();
  late LoginCubit loginCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginCubit = context.read<LoginCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          onLoginSuccess();
        } else if (state is LoginFailure) {
          onLoginFailure(state.errorMessage);
        }
      },
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            //margin: EdgeInsets.only(bottom: 60),
            child: ListView(
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center
              children: [
                Text(
                  "LOGIN",
                  style:
                  TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15.sp,
                ),
                Text(
                  "Login now to browse our hot 🔥 offers",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),
                ),
                SizedBox(
                  height: 25.sp,
                ),
                myshopTextFormField(
                    label: "ُEmail Address",
                    validator: (value) => emailValidator(value.toString()),
                    controller: emailController,
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress),
                SizedBox(
                  height: 16.sp,
                ),
                myshopTextFormField(
                    label: "Password",
                    validator: (value) => passwordValidator(value.toString()),
                    controller: passwordController,
                    prefixIcon: Icons.lock,
                    obscureText: isPasswordVisable,
                    suffixIcon: myIconWidget()),
                SizedBox(
                  height: 26.sp,
                ),
                myshopButtonWidget(
                  texts: "LOGIN",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      loginCubit.login(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      // BlocProvider.of<LoginCubit>(context).login(
                      //   email: emailController.text,
                      //   password: passwordController.text,
                      // );
                      //
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ? ",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider(
                                      create: (context) => RegisterCubit(),
                                      child: ShopRegisterScreen(),
                                    ),
                              ));
                        },
                        child: Text(
                          "REGISTER",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myIconWidget() {
    return InkWell(
        onTap: () {
          isPasswordVisable = !isPasswordVisable;
          setState(() {});
        },
        child: isPasswordVisable
            ? Icon(
          Icons.visibility_off,
          size: 22.sp,
        )
            : Icon(
          Icons.visibility,
          size: 22.sp,
        ));
  }

  void onLoginSuccess() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
  }

  void onLoginFailure(String errorMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(errorMessage),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}