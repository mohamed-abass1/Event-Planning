import 'package:flutter/material.dart';

import '../utils/app_Styles.dart';

class ChooseDateOrTime extends StatelessWidget {
  final Icon? iconName;
  final String eventNameOrTime;
  final String chooseDateOrTime;
  final Function onChooseDateOrTime;
  ChooseDateOrTime(
      {super.key, required this.iconName,
      required this.onChooseDateOrTime,
      required this.eventNameOrTime,
      required this.chooseDateOrTime});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconName?.icon,color: Theme.of(context).dividerColor,),
        Text(
          eventNameOrTime,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Spacer(),
        TextButton(
            onPressed: () {
              onChooseDateOrTime();
            },
            child: Text(
              chooseDateOrTime,
              style: AppStyles.medium16Primary,
            ))
      ],
    );
  }
}
