import 'package:flutter/material.dart';

class TextfieldCont extends StatefulWidget {
  const TextfieldCont({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.validator,
    this.isPassword = false,
  });
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final String? Function(String?)? validator;
  final bool isPassword;
  @override
  State<TextfieldCont> createState() => _TextfieldContState();
}

class _TextfieldContState extends State<TextfieldCont> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && !isPasswordVisible,
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(widget.icon, color: Colors.grey[700]),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
