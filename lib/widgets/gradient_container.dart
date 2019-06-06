import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final MaterialColor color;

  const GradientContainer({Key key, @required this.color, @required this.child})
      : assert(color != null, child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              color[700],
              color[500],
              color[300],
            ])),
        child: child,
      );
}
