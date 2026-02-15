import 'package:event_planning/l10n/app_localizations.dart';
import 'package:event_planning/utils/app_colors.dart';
import 'package:event_planning/utils/app_styles%20copy.dart';
import 'package:event_planning/widget/customElevatedButton.dart';
import 'package:event_planning/widget/switchButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'auth/Login_Screen/login_screen.dart';

class IntroScreen extends StatefulWidget {
  static String route = 'intrio';

  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Builder(builder: (context) {
      return IntroductionScreen(

        back: ImageIcon(AssetImage('assets/images/nextButton.png')),
next: ImageIcon(AssetImage('assets/images/nextButton.png')),
        key: _introKey,
        
        overrideNext:(context, onPressed) {
          return
          InkWell(onTap: _introKey.currentState?.next,
            child: Container(padding: EdgeInsets.all(5),
                decoration: BoxDecoration(shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryLight,width: 3)),
                child: Icon(Icons.arrow_forward,color: AppColors.primaryLight,)),
          );
        },
        overrideBack:(context, onPressed) {
          return
            InkWell(onTap: _introKey.currentState?.previous,
              child: Container(padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryLight,width: 3)),
                  child: Icon(Icons.arrow_back,color: AppColors.primaryLight,)),
            );
        },
        backStyle: ButtonStyle(),
        dotsDecorator: DotsDecorator(
          color: AppColors.black,
            activeShape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3))),
            activeColor: AppColors.primaryLight,
            activeSize: Size(25, 10)),
        pages: [

          PageViewModel(
              useScrollView: false,
              decoration: PageDecoration(
                  titlePadding: EdgeInsets.all(0), bodyFlex: 1, safeArea: 0),
              title: '',
              bodyWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/onBordingAppLogo.png'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Image.asset('assets/images/onboarding2.png'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    'Find Events That Inspire You',
                    style: AppStyles.bold20Primary,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text(
                    "Dive into a world of events crafted to fit your unique interests. Whether you`re into live music, art workshops, professional networking, or simply discovering new experiences, we have something for everyone. Our curated recommendations will help you explore, connect, and make the most of every opportunity around you.",
                    style: AppStyles.medium16black,
                  ),
                ],
              )),
          PageViewModel(
              useScrollView: false,
              decoration: PageDecoration(
                  titlePadding: EdgeInsets.all(0), bodyFlex: 1, safeArea: 0),
              title: '',
              bodyWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/onBordingAppLogo.png'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Image.asset('assets/images/onBordingScreen3.png'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    'Effortless Event Planning',
                    style: AppStyles.bold20Primary,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text(
                    'Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we’ve got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.',
                    style: AppStyles.medium16black,
                  ),
                ],
              )),
          PageViewModel(
              useScrollView: false,
              decoration: PageDecoration(
                  titlePadding: EdgeInsets.all(0), bodyFlex: 1, safeArea: 0),
              title: '',
              bodyWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/onBordingAppLogo.png'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Image.asset('assets/images/onBordingScreen4.png'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    'Connect with Friends & Share Moments',
                    style: AppStyles.bold20Primary,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text(
                    'Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.',
                    style: AppStyles.medium16black,
                  ),
                ],
              ))
          , PageViewModel(
              useScrollView: false,
              decoration: PageDecoration(
                  titlePadding: EdgeInsets.all(0), bodyFlex: 1, safeArea: 0),
              title: '',
              bodyWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/onBordingAppLogo.png'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Image.asset('assets/images/onBording_sceen1.png'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    'Personalize Your Experience',
                    style: AppStyles.bold20Primary,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    'Choose your preferred theme and language to get started with a comfortable, tailored experience that suits your style.',
                    style: AppStyles.medium16black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Language',
                        style: AppStyles.medium20Primary,
                      ),
                      LanguageSwitcherButton(),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomElevatedButton(
                      text: AppLocalizations.of(context)!.letsstart,
                      onButtonClicked: () {
                       Navigator.pushNamed(context, loginScreen.routeName);
                      })
                ],
              )),
        ],
        showBackButton: true,
        showDoneButton: false,
        showNextButton: true,
      );
    });
  }
}
