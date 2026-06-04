import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin NavigatorMixin<T extends StatefulWidget> on State<T> {
  void navigateTo(String routeName, {Object? arguments}) {
    GoRouter.of(context).goNamed(routeName);

    // Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  // void replaceWith(String routeName, {Object? arguments}) {
  //   Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  // }

  void goBack() {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }
  }
}