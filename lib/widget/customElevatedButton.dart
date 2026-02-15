import 'package:flutter/material.dart';
import '../utils/app_Styles.dart';
import '../utils/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
 final Color? backgroundColor;
final  Widget? prefixIconButton;
 final  String text;
 final  TextStyle? textStyle;
 final Function onButtonClicked;
  const CustomElevatedButton(
      {super.key, this.backgroundColor,
      this.prefixIconButton,
      required this.text,
      this.textStyle,
      required this.onButtonClicked});
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primaryLight,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.04, vertical: height * 0.02),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.primaryLight, width: 2))),
        onPressed: () {
          onButtonClicked();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prefixIconButton ?? const SizedBox(),
            SizedBox(
              width: width * 0.02,
            ),
            Text(
              text,
              style: textStyle ?? AppStyles.medium20White,
            )
          ],
        ));
  }
}
