import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
        required TextEditingController controller,
        this.icon = const SizedBox(),
        this.keyboardType = TextInputType.text,
        this.height = 45,
        this.width = 400,
        this.isObscured = false,
        this.prefixIcon = const SizedBox(),
        this.textToHintInput = "",
        this.isEnabled = true,
        this.textPaddingSIze = 20,
        this.validator})
      : _controller = controller;

  final TextEditingController _controller;
  final Widget icon;
  final Widget prefixIcon;
  final TextInputType keyboardType;
  final bool isObscured;
  final String textToHintInput;
  final bool isEnabled;
  final double textPaddingSIze;
  final double height, width;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        cursorColor: const Color(0xffB02700),
        textAlign: TextAlign.left,
        style: const TextStyle(color: Colors.black),
        keyboardType: keyboardType,
        obscureText: isObscured,
        enabled: isEnabled,
        validator: validator,
        controller: _controller,
        decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 0.01),
          helperText: "",
          errorText: "dd",
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5)),
          prefixIcon: prefixIcon,
          prefixIconColor: Colors.grey,
          prefixIconConstraints:
          BoxConstraints.tight(Size.fromWidth(textPaddingSIze)),
          hintText: textToHintInput,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 14),
          filled: true,
          fillColor: Theme.of(context).colorScheme.background,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(5)),


          suffixIcon: icon,
          suffixIconColor: Colors.grey[600],
        ),
      ),
    );
  }
}
