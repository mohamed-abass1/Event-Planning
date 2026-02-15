
import 'package:flutter/material.dart';

class DialogUtils {

  static void showLoading({required BuildContext context, required String message}) {
    showDialog(


        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                  ),
                )
              ],
            ),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    String? title,
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        List<Widget> actions = [];

        if (posActionName != null) {
          actions.add(TextButton(
            onPressed: () {
              if (Navigator.canPop(dialogContext)) {
                Navigator.pop(dialogContext);
              }
              posAction?.call();
            },
            child: Text(
              posActionName,
            ),
          ));
        }

        if (negActionName != null) {
          actions.add(TextButton(
            onPressed: () {
              if (Navigator.canPop(dialogContext)) {
                Navigator.pop(dialogContext);
              }
              negAction?.call();
            },
            child: Text(
              negActionName,
            ),
          ));
        }

        return AlertDialog(
          content: Text(
            message,
          ),
          title: Text(
            title ?? '',
          ),
          actions: actions,
        );
      },
    );
  }

}
