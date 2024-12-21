import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextStyle hintStyle;
  final bool isPasswordField;
  final bool obscureText;
  final Function()? onToggleVisibility;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.hintStyle,
    this.isPasswordField = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.suffixIcon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        suffixIcon: isPasswordField
            ? IconButton(
          icon: Icon(suffixIcon, color: Colors.grey),
          onPressed: onToggleVisibility,
        )
            : null,
      ),
      validator: validator,
      style: const TextStyle(color: Colors.white),
    );
  }
}
