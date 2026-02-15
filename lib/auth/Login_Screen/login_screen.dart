
import 'package:event_planning/providers/app_language_provider.dart';
import 'package:event_planning/sha-pref.dart';
import 'package:event_planning/widget/switchButton.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home_Screen.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/app_Styles.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets_Manger.dart';
import '../../utils/dialogeutils.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/customTextFiled.dart';
import '../Register_Screen/Registe_screen.dart';
import 'Login_Screen_View_Model.dart';
import 'Login_navigator.dart';

class loginScreen extends StatefulWidget {
  static String routeName = "LoginScreen";

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> implements LoginNavigator {
  final LoginScreenViewModel viewModel = LoginScreenViewModel();

  late AppLanguageProvider provider; // <-- Correct provider reference

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<AppLanguageProvider>(context); // <-- Correct way
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: Scaffold(
        backgroundColor: Theme.of(context).splashColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: viewModel.fromKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLogo(height),
                    SizedBox(height: height * 0.02),
                    _buildEmailField(context),
                    SizedBox(height: height * 0.02),
                    _buildPasswordField(context),
                    _buildForgotPasswordText(context),
                    SizedBox(height: height * 0.02),
                    _buildLoginButton(context),
                    _buildCreateAccountText(context),
                    SizedBox(height: height * 0.02),
                    _buildDivider(context),
                    SizedBox(height: height * 0.02),
                    _buildGoogleButton(context),
                    SizedBox(height: height * 0.02),
                   Center(child: LanguageSwitcherButton())
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------- Widget Builders -----------------

  Widget _buildLogo(double height) {
    return Image.asset(
      AssetsManger.logo,
      height: height * 0.3,
      fit: BoxFit.contain,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return CustomTextFiled(
      keyboardType: TextInputType.emailAddress,
      hintText: AppLocalizations.of(context)!.email,
      prefixIcon: Image.asset(AssetsManger.iconEmail),
      controller: viewModel.emailController,
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Please Enter Email";
        }
        final emailValid = RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(text);
        return emailValid ? null : "Please Enter Valid Email";
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextFiled(
      keyboardType: TextInputType.text,
      obscureText: true,
      hintText: AppLocalizations.of(context)!.password,
      prefixIcon: Image.asset(AssetsManger.iconPassword),
      controller: viewModel.passwordController,
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Please Enter password";
        }
        if (text.length < 6) {
          return "Password Should by least 6 chars";
        }
        return null;
      },
    );
  }

  Widget _buildForgotPasswordText(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        AppLocalizations.of(context)!.forget_password,
        style: AppStyles.bold20Primary.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primaryLight,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return CustomElevatedButton(
      text: AppLocalizations.of(context)!.login,
      onButtonClicked: () {
        if (viewModel.fromKey.currentState?.validate() == true) {
          viewModel.login(context);
        } else {
          debugPrint("Invalid form data");
        }
        setState(() {});
      },
    );
  }

  Widget _buildCreateAccountText(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(RegisteScreen.routeName),
      child: Text.rich(
        TextSpan(
          text: AppLocalizations.of(context)!.dont_have_an_account,
          style: AppStyles.bold14black,
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!.create_account,
              style: AppStyles.bold20Primary.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryLight,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
         Expanded(
          child: Divider(
            thickness: 2,
            indent: 10,
            endIndent: 20,
            color: AppColors.primaryLight,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.or,
          style: AppStyles.bold20Primary,
        ),
         Expanded(
          child: Divider(
            thickness: 2,
            indent: 10,
            endIndent: 20,
            color: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return CustomElevatedButton(
      onButtonClicked: () {
        viewModel.signInWithGoogle().whenComplete(() =>
            Navigator.pushNamed(context, HomeScreen.routeName));
      },
      prefixIconButton: Image.asset(AssetsManger.iconGoogle),
      text: AppLocalizations.of(context)!.login_with_google,
      textStyle: AppStyles.medium16Primary,
      backgroundColor: Theme.of(context).splashColor,
    );
  }
  @override
  void hideMyLoading() => DialogeUtils.hideLoding(context);

  @override
  void showMyLoading(String message) =>
      DialogeUtils.showLoding(context: context, message: message);

  @override
  void showMessage(String message) {
    DialogeUtils.showMessage(
      context: context,
      message: message,
      posActionName: "Ok",
    );
  }
}
