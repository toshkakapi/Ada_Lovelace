import 'package:flutter/material.dart';

class SignButton extends StatelessWidget {
  final VoidCallback? onTap; // Исправлено на VoidCallback?
  final String text;

  const SignButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Передаем onTap в GestureDetector
      child: Container(
        padding: EdgeInsets.all(23),
        margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(3, 4),
                blurRadius: 3,
                spreadRadius: 1,
              )
            ]
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
