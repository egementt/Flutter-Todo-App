import 'package:flutter/material.dart';
import 'package:flutter_todo/models/user.dart';

//current User
User currentUser;

// Padding values for textFields.

class Utils {
  static const double paddingX = 16;
  static const double paddingY = 8;
}

  EdgeInsets myPadding() {
  return EdgeInsets.only(
      bottom: Utils.paddingY,
      top: Utils.paddingY,
      left: Utils.paddingX,
      right: Utils.paddingX);
}


