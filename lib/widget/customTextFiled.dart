import 'package:flutter/material.dart';

import '../utils/app_Styles.dart';
import '../utils/app_colors.dart';

class CustomTextFiled extends StatelessWidget {
  final Color? borderColor;
  final String hintText;
  final String? labelText;
  final  TextStyle? labelStyle;
  final  TextStyle? hintStyle;
  final  TextStyle? style;
  final  Widget? prefixIcon;
  final  Widget? suffixIcon;
  final  bool? obscureText;
  final  int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomTextFiled(
      {super.key, this.borderColor,
      this.keyboardType=TextInputType.text,
      this.controller,
      this.validator,
      required this.hintText,
      this.labelText,
      this.hintStyle,
      this.prefixIcon,
      this.suffixIcon,
      this.labelStyle,
      this.style,
      this.obscureText,
      this.maxLines});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      maxLines: maxLines ?? 1,
      obscureText: obscureText ?? false,
      style: Theme.of(context).textTheme.labelMedium,
      cursorColor: AppColors.blackColor,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.labelMedium,
          labelText: labelText,
          labelStyle: labelStyle,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: Theme.of(context).hintColor, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: Theme.of(context).hintColor ?? AppColors.grey, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.redColor, width: 2)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.redColor, width: 2))),
    );
  }
}
