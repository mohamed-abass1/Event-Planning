
import 'package:event_planning/Future/eventDetailScreen/EventDetails.dart';
import 'package:event_planning/chooseLocation/EventChooseLocationViewModel.dart';
import 'package:event_planning/googleMap/googleMapViewModel.dart';
import 'package:event_planning/home/tap_even_Widget.dart';
import 'package:event_planning/homeScreen/homeScreenViewModel.dart';
import 'package:event_planning/sha-pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../Future/eventDetailScreen/eventDetailsScreenViewModel.dart';
import '../chooseLocation/EventChooseLocationStates.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_language_provider.dart';
import '../providers/eventListProvider.dart';
import '../utils/app_Styles.dart';
import '../utils/app_colors.dart';
import '../home/event_item_widget.dart';
import 'HomeScreenStates.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final eventProvider = context.read<EventListProvider>();
      eventProvider.getEventNameList(context);
      eventProvider.getAllEvent();

      HomeScreenViewModel.get(context).getLocation(context);
      EventChooseLocationViewModel.get(context).getSelectedLocation(context);

    });
  }

  @override
  Widget build(BuildContext context) {
    final eventListProvider = context.watch<EventListProvider>();

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return DefaultTabController(
      length: eventListProvider.eventsNameList.length,
      child: BlocBuilder<HomeScreenViewModel, HomeScreenStates>(
        bloc: HomeScreenViewModel.get(context),
        builder: (context, state) => Scaffold(
          backgroundColor: Theme.of(context).splashColor,
          appBar: _buildAppBar(height, width, context),
          body: Column(
            children: [
              _buildHeaderTabs(eventListProvider, height, width),
              Expanded(
                child: eventListProvider.eventList.isEmpty
                    ? _buildEmptyState()
                    : _buildEventList(eventListProvider, width, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // APP BAR
  PreferredSizeWidget _buildAppBar(double HEIGHT, double width, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: HEIGHT * 0.1,
      backgroundColor: Theme.of(context).primaryColor,
      title: Row(
        children: [
          _buildUserGreeting(HEIGHT, context),
          const Spacer(),
          Icon(Icons.sunny, color: AppColors.white),
          SizedBox(width: width * 0.02),
          _buildLanguageBadge(width),
        ],
      ),
    );
  }

  Widget _buildUserGreeting(double hight, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.welcomeback,
          style: TextStyle(
            color: AppColors.white,
            fontFamily: AppStyles.regular14White.fontFamily,
          ),
        ),
        SizedBox(height: hight * 0.01),
        Text(
          SharedPreferenceUtils.getData(key: 'name').toString(),
          style: TextStyle(
            color: AppColors.white,
            fontFamily: AppStyles.bold24White.fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageBadge(double width) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    return Container(
      margin: EdgeInsets.only(right: width * 0.02),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        languageProvider.appLanguage,
        style: TextStyle(
          color: AppColors.primaryLight,
          fontFamily: AppStyles.bold14Primary.fontFamily,
        ),
      ),
    );
  }

  // HEADER (Location + Tabs)
  Widget _buildHeaderTabs(EventListProvider eventListProvider, double hight, double width) {
    return Container(
      height: hight * 0.1,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLocationRow(width),
          SizedBox(height: hight * 0.02),
          _buildTabBar(eventListProvider),
        ],
      ),
    );
  }

  Widget _buildLocationRow(double width) {
    return BlocBuilder<EventChooseLocationViewModel, EventChooseLocationStates>(
      bloc: EventChooseLocationViewModel.get(context),
      builder: (context, state) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: AppColors.white),
          SizedBox(width: width * 0.03),
          Text(
            EventChooseLocationViewModel.get(context).location ?? 'Processing',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: AppStyles.medium14White.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(EventListProvider eventListProvider) {
    return TabBar(
      tabAlignment: TabAlignment.start,
      dividerColor: AppColors.transparentColor,
      indicator:  BoxDecoration(color: AppColors.transparentColor),
      isScrollable: true,
      indicatorColor: AppColors.transparentColor,
      onTap: (index) => eventListProvider.changeSelectedIndex(index),
      tabs: eventListProvider.eventsNameList.map((eventName) {
        final isSelected = eventListProvider.selectedIndex ==
            eventListProvider.eventsNameList.indexOf(eventName);

        return TapEvenWidget(
          borderColor: Theme.of(context).canvasColor,
          eventName: eventName,
          isSelect: isSelected,
          backgroundColor: Theme.of(context).canvasColor,
          textSelectedStyle: Theme.of(context).textTheme.headlineSmall!,
          textUnSelectedStyle: AppStyles.medium16White,
          selectedIconBackgroundColor: Theme.of(context).cardColor,
          unselectedIconBackgroundColor: AppColors.white,
        );
      }).toList(),
    );
  }

  // EMPTY
  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "NO ITEMS found",
        style: TextStyle(
          fontFamily: AppStyles.medium16White.fontFamily,
        ),
      ),
    );
  }

  // EVENTS LIST
  Widget _buildEventList(EventListProvider eventListProvider, double width, context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      itemCount: eventListProvider.filterList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              EventDetails.routeName,
              arguments: eventListProvider.filterList[index],
            );
          },
          child: EventItemWidget(event: eventListProvider.filterList[index]),
        );
      },
    );
  }
}
