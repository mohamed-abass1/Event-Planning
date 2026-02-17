import 'package:flutter/material.dart';

import '../utils/app_colors.dart';


class TapEvenWidget extends StatelessWidget {
  final bool isSelect;
  final String eventName;
  final Color backgroundColor;
  final Color selectedIconBackgroundColor;
  final Color unselectedIconBackgroundColor;

  final TextStyle textSelectedStyle;
  final TextStyle textUnSelectedStyle;
  final Color? borderColor;

  const TapEvenWidget({
    Key? key,
    required this.selectedIconBackgroundColor,
    required this.unselectedIconBackgroundColor,
    required this.isSelect,
    required this.eventName,
    required this.backgroundColor,
    required this.textSelectedStyle,
    required this.textUnSelectedStyle,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final containerColor =
    isSelect ? backgroundColor : AppColors.transparentColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.002,
      ),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(46),
        border: Border.all(
          color: borderColor ?? AppColors.white,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/all_icon.png',color: isSelect?selectedIconBackgroundColor:unselectedIconBackgroundColor),
        SizedBox(width: width * 0.02),
            Text(
            eventName,
            style: isSelect ? textSelectedStyle : textUnSelectedStyle,
          )
        ],
      ),
    );
  }
}
