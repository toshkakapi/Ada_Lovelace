import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final  controller;
  final String hintText;
  final bool obscureText;

  MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key); // Исправлено расположение скобок и добавлен вызов конструктора родителя

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(2, 4),
                blurRadius: 3,
                spreadRadius: 1,
              )
            ]
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          cursorColor: Colors.white,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true, // Включает заливку фоновым цветом
            fillColor: Color.fromRGBO(120, 206, 198, 1.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white,
                width: 4,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color.fromRGBO(175, 238, 238, 1.0),
                width: 4,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 20.0),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
