import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@singleton
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigator => navigatorKey.currentState!;

  void push(String routeName, {Object? arguments}) {
    navigator.pushNamed(routeName, arguments: arguments);
  }

  void pushReplacement(String routeName, {Object? arguments}) {
    navigator.pushReplacementNamed(routeName, arguments: arguments);
  }

  void pop() {
    navigator.pop();
  }

  void popUntil(String routeName) {
    navigator.popUntil(ModalRoute.withName(routeName));
  }

  void pushAndRemoveUntil(String routeName, {Object? arguments}) {
    navigator.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // GoRouter methods
  void go(String location, {Object? extra}) {
    GoRouter.of(navigator.context).go(location, extra: extra);
  }

  void pushGo(String location, {Object? extra}) {
    GoRouter.of(navigator.context).push(location, extra: extra);
  }

  void popGo() {
    GoRouter.of(navigator.context).pop();
  }

  void replace(String location, {Object? extra}) {
    GoRouter.of(navigator.context).replace(location, extra: extra);
  }

  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    GoRouter.of(
      navigator.context,
    ).goNamed(name, pathParameters: pathParameters, extra: extra);
  }

  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    GoRouter.of(
      navigator.context,
    ).pushNamed(name, pathParameters: pathParameters, extra: extra);
  }
}
