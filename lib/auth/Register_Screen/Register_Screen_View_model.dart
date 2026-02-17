import 'package:event_planning/Future/home_Screen.dart';
import 'package:event_planning/utils/dialogeutils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'RegistarNavigator.dart';

class RegisterScreenViewModel extends ChangeNotifier {
  late RegisterNavigator navigator;

  Future<void> register(String email, String password,context) async {
    navigator.showMyLoading("Loading...");
    DialogeUtils.hideLoding(context);
    try {
      // Attempt to create user with Firebase
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final userId = credential.user?.uid ?? "Unknown User";
      DialogeUtils.showMessage(context: context, message: 'Register Successfully',
          posAction: (){Navigator.pushNamed(context, HomeScreen.routeName);},
        posActionName: 'ok'
      );

      debugPrint("Register successfully with User ID: $userId");
    } on FirebaseAuthException catch (e) {
      // Stop loading before showing message
      navigator.hideMyLoading();

      final message = switch (e.code) {
        'weak-password' => 'The password provided is too weak.',
        'email-already-in-use' =>
        'The email address is already in use.',
        _ => 'Registration failed: ${e.message}',
      };

      navigator.showMessage(message);

      debugPrint("FirebaseAuthException: ${e.code}");
      debugPrint("Message: ${e.message}");
    } catch (e) {
      navigator.hideMyLoading();
      navigator.showMessage(e.toString());
      debugPrint("Unexpected error: $e");
    }
  }
}
