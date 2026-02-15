
import 'package:event_planning/widget/switchButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/app_Styles.dart';
import '../../utils/app_colors.dart';
import '../../utils/assets_Manger.dart';
import '../../utils/dialogeutils.dart';
import '../../widget/customElevatedButton.dart';
import '../../widget/customTextFiled.dart';
import '../Login_Screen/login_screen.dart';
import 'RegistarNavigator.dart';
import 'Register_Screen_View_model.dart';

class RegisteScreen extends StatefulWidget {
  static String routeName = "RegisteScreen";

  const RegisteScreen({super.key});

  @override
  State<RegisteScreen> createState() => _RegisteScreenState();
}

class _RegisteScreenState extends State<RegisteScreen> implements RegisterNavigator {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final rePasswordController = TextEditingController();

  final RegisterScreenViewModel viewModel = RegisterScreenViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    return ChangeNotifierProvider(
      create: (_) => viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).splashColor,

          appBar: AppBar(
        leading: InkWell(onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back,color: AppColors.primaryLight,)),
            backgroundColor: Theme.of(context).splashColor,
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.register,
              style: AppStyles.bold24Primary,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.04,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLogo(height),
                      SizedBox(height: height * 0.02),
                      _buildNameField(context),
                      SizedBox(height: height * 0.02),
                      _buildEmailField(context),
                      SizedBox(height: height * 0.02),
                      _buildPasswordField(context),
                      SizedBox(height: height * 0.02),
                      _buildRePasswordField(context),
                      SizedBox(height: height * 0.02),
                      _buildRegisterButton(context),
                      _buildLoginText(context),
                      SizedBox(height: height * 0.02),
                        Center(child: LanguageSwitcherButton())
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // -------------------- Widget Builders --------------------

  Widget _buildLogo(double height) {
    return Image.asset(
      AssetsManger.logo,
      height: height * 0.25,
      fit: BoxFit.contain,
    );
  }

  Widget _buildNameField(BuildContext context) {
    return CustomTextFiled(
      controller: nameController,
      hintText: AppLocalizations.of(context)!.name,
      prefixIcon: Image.asset(AssetsManger.iconName),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Please Enter Name";
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return CustomTextFiled(

      hintStyle: Theme.of(context).textTheme.titleLarge,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      hintText: AppLocalizations.of(context)!.email,
      prefixIcon: Image.asset(AssetsManger.iconEmail),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Please Enter Email";
        }
        final emailValid = RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(text);
        if (!emailValid) return "Please Enter Valid Email";
        return null;
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextFiled(
      obscureText: true,
      keyboardType: TextInputType.text,
      controller: passwordController,
      hintText: AppLocalizations.of(context)!.password,
      prefixIcon: Image.asset(AssetsManger.iconPassword),
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

  Widget _buildRePasswordField(BuildContext context) {
    return CustomTextFiled(
      hintStyle: Theme.of(context).textTheme.titleLarge,
      obscureText: true,
      controller: rePasswordController,
      hintText: AppLocalizations.of(context)!.rePassword,
      prefixIcon: Image.asset(AssetsManger.iconPassword),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Please Enter Re-password";
        }
        if (text != passwordController.text) {
          return "Re-Password doesn't match Password";
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return CustomElevatedButton(

      text: AppLocalizations.of(context)!.create_account,
      onButtonClicked: () {
        if (formKey.currentState?.validate() == true) {
          register();
        } else {
          debugPrint("Invalid data");
        }
      },
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushReplacementNamed(loginScreen.routeName);
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!.already_have_account,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            TextSpan(
              text: AppLocalizations.of(context)!.login,
              style: AppStyles.bold20Primary.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryLight,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushReplacementNamed(
                    loginScreen.routeName,
                  );
                },
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // -------------------- Helper Methods --------------------

  void register() async {
    if (formKey.currentState?.validate() == true) {
      viewModel.register(emailController.text, passwordController.text,context);
    }
  }

  // -------------------- Navigator Methods --------------------

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
      posActionName: "Ok",)
    ;}

  }
