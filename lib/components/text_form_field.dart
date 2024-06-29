import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  TextEditingController? controller;
  String? hintText;
  String? labelText;
  IconData? prefixIcon;
  TextInputType? inputType;

  CustomTextFormField(
      {super.key, this.controller,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      this.inputType});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller!,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.prefixIcon),
        labelText: widget.labelText!,
        hintText: widget.hintText!,
        border: const OutlineInputBorder(),
      ),
      keyboardType: widget.inputType!,
    );
  }
}
