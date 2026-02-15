import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planning/Future/eventEditingScreen/eventEditingViewModel.dart';
import 'package:event_planning/On_Boarding.dart';
import 'package:event_planning/googleMap/googleMapViewModel.dart';
import 'package:event_planning/homeScreen/homeScreenViewModel.dart';
import 'package:event_planning/providers/app_Theme_providers.dart';
import 'package:event_planning/providers/app_language_provider.dart';
import 'package:event_planning/providers/eventListProvider.dart';
import 'package:event_planning/sha-pref.dart';
import 'package:event_planning/utils/app_theme.dart';
import 'package:event_planning/chooseLocation/eventChooseLocation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'Future/eventDetailScreen/EventDetails.dart';
import 'Future/eventDetailScreen/eventDetailsScreenViewModel.dart';
import 'Future/eventEditingScreen/EventEditing.dart';
import 'Future/eventEditingScreen/editLocation/editLocation.dart';
import 'Future/eventEditingScreen/editLocation/editLocationViewModel.dart';
import 'add_Event.dart';
import 'chooseLocation/EventChooseLocationViewModel.dart';
import 'home_Screen.dart';
import 'auth/Login_Screen/login_screen.dart';
import 'auth/Register_Screen/Registe_screen.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseFirestore.instance.disableNetwork();
  await SharedPreferenceUtils.init();


  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => HomeScreenViewModel()),
      BlocProvider(create: (context) => EventEditingViewModel()),
      BlocProvider(create: (context) => EditLocationViewModel()),
      BlocProvider(create: (context) => EventDetailsScreenViewModel()),
      BlocProvider(create: (context) => GoogleMapViewModel()),
      BlocProvider(create: (context) => EventChooseLocationViewModel())
    ],
    child: MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
      ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
      ChangeNotifierProvider(create: (context) => AppThemeProviders()),
      ChangeNotifierProvider(create: (context) => EventListProvider()),
    ], child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<AppThemeProviders>(context);
    var languageProvider = Provider.of<AppLanguageProvider>(context);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.appTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.appLanguage),
      initialRoute: IntroScreen.route,
      routes: {
        EditLocation.routeName: (context) => EditLocation(),
        EventDetails.routeName: (context)=>EventDetails(),
        EventEditing.routeName: (context)=>EventEditing(),
        IntroScreen.route: (context)=>IntroScreen(),
        EventChooseLocation.routeName: (context) => EventChooseLocation(),
        HomeScreen.routeName: (context) => HomeScreen(),
        loginScreen.routeName: (context) => loginScreen(),
        RegisteScreen.routeName: (context) => const RegisteScreen(),
        AddEvent.routeName: (context) => const AddEvent(),
      },
    );
  }
}
