import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:untitled1/instgram/logic/cubit/register/register_cubit.dart';
import 'package:untitled1/instgram/logic/validators.dart';
import 'package:untitled1/instgram/ui/components.dart';

import 'login-screen.dart';

class ShopRegisterScreen extends StatefulWidget {
  ShopRegisterScreen({Key? key}) : super(key: key);

  @override
  State<ShopRegisterScreen> createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {
  var userNameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var phoneController = TextEditingController();

  bool isPasswordVisable = false;

  var formKey = GlobalKey<FormState>();

  late RegisterCubit registerCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerCubit = context.read<RegisterCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          onRegisterSuccess();
        } else if (state is RegisterFailureState) {
          onRegisterFailure(state.errorMessage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Form(
          key: formKey,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            //margin: EdgeInsets.only(bottom: 60),
            child: ListView(
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center
              children: [
                const Text(
                  "REGISTER",
                  style:  TextStyle(
                      fontSize: 33, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Register now to browse our hot 🔥 offers",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),
                ),
                const SizedBox(
                  height: 18,
                ),
                myshopTextFormField(
                  label: "User Name",
                  validator: (value) => usernameValidator(value.toString()),
                  controller: userNameController,
                  prefixIcon: Icons.person,
                ),
                const SizedBox(
                  height: 16,
                ),
                myshopTextFormField(
                    label: "ُEmail Address",
                    validator: (value) => emailValidator(value.toString()),
                    controller: emailController,
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(
                  height: 16,
                ),
                myshopTextFormField(
                    label: "Password",
                    validator: (value) => passwordValidator(value.toString()),
                    controller: passwordController,
                    prefixIcon: Icons.lock,
                    obscureText: isPasswordVisable,
                    suffixIcon: myiconwidg()),
                const SizedBox(
                  height: 16,
                ),
                myshopTextFormField(
                    label: "Phone",
                    validator: (value) => phoneValidator(value.toString()),
                    controller: phoneController,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone),
                const SizedBox(
                  height: 32,
                ),
                myshopButtonWidget(
                  texts: "REGISTER",
                  onPressed: () => register(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      registerCubit.register(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  void onRegisterSuccess() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
  }

  Widget myiconwidg() {
    return InkWell(
        onTap: () {
          isPasswordVisable = !isPasswordVisable;
          setState(() {});
        },
        child: isPasswordVisable
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility));
  }

  void onRegisterFailure(String errorMessage) {
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