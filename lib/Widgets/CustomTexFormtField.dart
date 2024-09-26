import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.hintText,
    this.onChange,
    this.obscureText = false,
  });
  bool? obscureText;
  final String? hintText;
  Function(String)? onChange;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      validator: (data) {
        if (data!.isEmpty) {
          return 'Wrong! field is required';
        }
        return null;
      },
      style: const TextStyle(color: Colors.white),
      onChanged: onChange,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.white)),
        hintText: '$hintText',
        hintStyle: const TextStyle(color: Colors.white),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
