import 'package:event_planning/Future/home_Screen.dart';
import 'package:event_planning/sha-pref.dart';
import 'package:event_planning/utils/dialogeutils.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Login_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreenViewModel extends ChangeNotifier {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final fromKey = GlobalKey<FormState>();

  late LoginNavigator navigator;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      bool isWeb = identical(0, 0.0);

      if (isWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      var user = userCredential.user;
      await SharedPreferenceUtils.saveData(key: 'name', value: user?.displayName);
      await SharedPreferenceUtils.saveData(key: 'profilePic', value: user?.photoURL);
      await SharedPreferenceUtils.saveData(key: 'userId', value: user?.uid);
      await SharedPreferenceUtils.saveData(key: 'email', value: user?.email);

      print('User Name: ${SharedPreferenceUtils.getData(key: 'name')}');

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
  Future<void> login(context) async {
    final formState = fromKey.currentState;
    if (formState == null || !formState.validate()) return;

    navigator.showMyLoading("Waiting...");

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      navigator.hideMyLoading();
      DialogeUtils.showMessage(
        context: context,
        message: 'Login Successfully',
        posActionName: 'ok',
        posAction: () {
          Navigator.pushNamed(context, HomeScreen.routeName);
        },
      );
      debugPrint("Login Successfully");
      debugPrint("User UID: ${credential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      navigator.hideMyLoading();
      _handleFirebaseError(e);
    } catch (e) {
      navigator.hideMyLoading();
      navigator.showMessage("Error: ${e.toString()}");
    }
  }

  void _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        navigator.showMessage("No user found for that email.");
        break;
      case 'wrong-password':
        navigator.showMessage("Wrong password provided for that user.");
        break;
      case 'invalid-credential':
        navigator.showMessage(
          "The supplied auth credential is malformed or has expired.",
        );
        break;
      default:
        navigator.showMessage("Unexpected error: ${e.message ?? 'Unknown'}");
    }
  }
}
