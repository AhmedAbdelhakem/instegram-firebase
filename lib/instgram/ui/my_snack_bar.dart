import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String errorMessage) {
  SnackBar snackBar = SnackBar(
    content: Text(errorMessage),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}