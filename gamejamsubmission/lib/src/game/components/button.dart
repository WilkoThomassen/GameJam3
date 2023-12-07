import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  const Button({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textColor: Colors.black,
        color: Theme.of(context).colorScheme.primary,
        child: Text(text.toUpperCase()));
  }
}
