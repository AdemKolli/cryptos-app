import 'package:flutter/material.dart';

class Debug extends StatelessWidget {
  final Widget? child;
  final Color? color;
  const Debug({super.key, this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: color!
                ),
                right: BorderSide(
                  color: color!
                ),
                left: BorderSide(
                  color: color!
                ),
                bottom: BorderSide(
                  color: color!
                )
              )
            ),
            child: child
    );
  }
}