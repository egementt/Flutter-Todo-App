import 'package:flutter/material.dart';

SnackBar errorSnackbar(String error) {
  return SnackBar(
    backgroundColor: ThemeData().errorColor,
    content: Text(error),
  );
}
