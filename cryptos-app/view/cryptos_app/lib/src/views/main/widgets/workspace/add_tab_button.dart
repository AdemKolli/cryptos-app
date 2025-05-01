import 'package:flutter/material.dart';

class AddTabButton extends StatelessWidget {
  const AddTabButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8)
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}