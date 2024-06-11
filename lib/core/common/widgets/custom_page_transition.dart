import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomPageTransition extends CustomTransitionPage {
  CustomPageTransition({required super.child})
      : super(
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(animation),
              child: child,
            );
          },
        );
}
