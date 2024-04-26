import 'package:flutter/material.dart';
import 'package:banda/home_page.dart';
import 'package:banda/routes.dart';


final Map<String, Widget Function(BuildContext)> routes = {
    MyRoutes.home.name: (context) => HomePage(),
};