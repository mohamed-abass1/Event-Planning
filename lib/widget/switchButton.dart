import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:event_planning/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_language_provider.dart';

class LanguageSwitcherButton extends StatefulWidget {
  @override
  State<LanguageSwitcherButton> createState() => _LanguageSwitcherButtonState();
}
class _LanguageSwitcherButtonState extends State<LanguageSwitcherButton> {
  int value = 0;
  int? nullableValue;
  bool positive = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);

  return AnimatedToggleSwitch<int?>.rolling(
    style: ToggleStyle(backgroundColor:AppColors.transparentColor ),
        allowUnlistedValues: true,
        styleAnimationType: AnimationType.onHover,
        current: nullableValue,
        values:  const [0, 1],

        onChanged: (i) {
          if(i==0){
            languageProvider.changeLanguage('ar');
          }
          if(i==1){
            languageProvider.changeLanguage('en');
          }

          setState(() => nullableValue = i);},
        iconBuilder: rollingIconBuilder,
        customStyleBuilder: (context, local, global) {
          return ToggleStyle(borderColor:AppColors.primaryLight, indicatorColor: AppColors.primaryLight);
        },
    );}}

Widget rollingIconBuilder(int? value, bool foreground) {
  return Image.asset(iconDataByValue(value));
}

String iconDataByValue(int? value) => switch (value) {
  0 => 'assets/images/EG.png',
 1=>'assets/images/en.png',
  int() => throw UnimplementedError(),
  null => throw UnimplementedError(),
};