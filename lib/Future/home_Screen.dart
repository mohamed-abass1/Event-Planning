
import 'package:event_planning/Future/taps/HomeTab/home.dart';
import 'package:event_planning/utils/app_colors.dart';
import 'package:event_planning/utils/assets_Manger.dart';
import 'package:flutter/material.dart';

import 'taps/favorite/Favourite.dart';
import 'taps/googleMap/googleMap.dart';
import 'taps/profile/profile.dart';
import 'add_Event.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    final List<Widget> taps = [
      Home(),
      GoogleMapScreen(),
      const Favourite(),
      const Profile(),
    ];

    return Scaffold(
      body: taps[selectedIndex],

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        shape:  StadiumBorder(
          side: BorderSide(
            color: AppColors.whiteColor,
            width: 4,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.of(context).pushNamed(AddEvent.routeName),
        child:  Icon(
          Icons.add,
          color: AppColors.whiteColor,
          size: 35,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppColors.transparentColor,
        ),
        child: BottomAppBar(
          color: Theme.of(context).primaryColor,
          shape: const CircularNotchedRectangle(),
          padding: EdgeInsets.zero,
          notchMargin: 6,
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).primaryColor,
            selectedItemColor: AppColors.whiteColor,
            unselectedItemColor: Colors.white70,
            elevation: 0,
            onTap: (index) => setState(() => selectedIndex = index),
            items: [
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AssetsManger.iconHomeUnselected),
                ),
                label: AppLocalizations.of(context)!.home,
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AssetsManger.iconMap),
                ),
                label: AppLocalizations.of(context)!.map,
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AssetsManger.iconArtUnSelected),
                ),
                label: AppLocalizations.of(context)!.favorite,
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage(AssetsManger.iconUserUnSelected),
                ),
                label: AppLocalizations.of(context)!.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
