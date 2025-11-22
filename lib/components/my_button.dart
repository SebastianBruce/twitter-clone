import 'package:flutter/material.dart';

/*

BUTTON

A simple button.

----------------------------------------------------------------------

To use this widget, you need:

— text
— a function ( on tap )

*/

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({super.key, required this.text, required this.onTap});

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding inside
        padding: const EdgeInsets.all(25),

        decoration: BoxDecoration(
          // color of button
          color: Theme.of(context).colorScheme.secondary,

          // curved corners
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
