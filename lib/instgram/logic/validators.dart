passwordValidator(String value) {
  if (value.isEmpty) {
    return "please Enter Email";
  }
  if (value.length < 6) {
    return " password must be at least 6 characters ";
  }
  bool passwordValid =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
      .hasMatch(value);
  if (!passwordValid) {
    return "password not valid";
  }
  return null;
}

emailValidator(String value) {
  if (value.isEmpty) {
    return "please Enter Email";
  }
  bool emailValid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value);
  if (!emailValid) {
    return "email not valid";
  }
  return null;
}

phoneValidator(String value) {
  if (value.isEmpty) {
    return "please Enter Phone Number";
  }
  String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
}

usernameValidator(String value) {
  if (value.isEmpty) {
    return "please Enter User Name";
  }
  return null;
}