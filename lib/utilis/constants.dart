import 'dart:ui';

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF9575CD);
const kSecondaryColor = Color(0xFF9575CD);
const kTextColor = Color(0xFF000000);

const kTextStyleButton = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
const kTextStyleTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";

const List<String> categoryList = ["All", "Men", "Women"];
