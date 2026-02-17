
import 'package:event_planning/sha-pref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/Login_Screen/login_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../../../language_Bottom_Sheet.dart';
import '../../../providers/app_Theme_providers.dart';
import '../../../providers/app_language_provider.dart';
import '../../../theme_Bottom_Sheet.dart';
import '../../../utils/app_Styles.dart';
import '../../../utils/app_colors.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<AppLanguageProvider>(context);
    final themeProvider = Provider.of<AppThemeProviders>(context);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(height, width),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(AppLocalizations.of(context)!.language),
                SizedBox(height: height * 0.02),
                _buildSettingTile(
                  onTap: showLanguageBottomSheet,
                  title: languageProvider.appLanguage == 'en'
                      ? AppLocalizations.of(context)!.english
                      : AppLocalizations.of(context)!.arabic,
                ),
                SizedBox(height: height * 0.03),
                _buildSectionTitle(AppLocalizations.of(context)!.theme),
                SizedBox(height: height * 0.02),
                _buildSettingTile(
                  onTap: showThemeBottomSheet,
                  title: themeProvider.appTheme == ThemeMode.dark
                      ? AppLocalizations.of(context)!.dark
                      : AppLocalizations.of(context)!.light,
                ),
              ],
            ),
          ),
           Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, loginScreen.routeName);
              },
              child: Row(
                children: [
                   Icon(Icons.logout, color: AppColors.white),
                  SizedBox(width: width * 0.02),
                  Text(
                    AppLocalizations.of(context)!.logout,
                    style: AppStyles.regular20white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double height, double width) {
    return Container(
      height: height * 0.25,
      padding: EdgeInsets.only(
        top: height * 0.04,
        left: width * 0.04,
        right: width * 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(45),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(borderRadius: BorderRadiusGeometry.only(
              bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
            topRight: Radius.circular(50),),
              child: Image.network(SharedPreferenceUtils.getData(key: 'profilePic').toString())),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(SharedPreferenceUtils.getData(key: 'name').toString(), style: AppStyles.bold24White),
                Text(SharedPreferenceUtils.getData(key: 'email').toString(), style: AppStyles.medium16White),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSettingTile({
    required VoidCallback onTap,
    required String title,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryLight, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:  TextStyle(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
             Icon(Icons.arrow_drop_down,
                size: 35, color: AppColors.primaryLight),
          ],
        ),
      ),
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).splashColor,
      context: context,
      builder: (context) => LanguageBottomSheet(),
    );
  }

  void showThemeBottomSheet() {

    showModalBottomSheet(
      backgroundColor: Theme.of(context).splashColor,

      context: context,
      builder: (context) => ThemeBottomSheet(),
    );
  }
}
