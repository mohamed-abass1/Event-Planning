
import 'package:event_planning/Future/eventEditingScreen/editLocation/editLocation.dart';
import 'package:event_planning/Future/eventEditingScreen/editLocation/editLocationViewModel.dart';
import 'package:event_planning/Future/eventEditingScreen/eventEditingViewModel.dart';
import 'package:event_planning/chooseLocation/EventChooseLocationStates.dart';
import 'package:event_planning/chooseLocation/EventChooseLocationViewModel.dart';
import 'package:event_planning/home_Screen.dart';
import 'package:event_planning/providers/eventListProvider.dart';
import 'package:event_planning/utils/app_Styles.dart';
import 'package:event_planning/utils/app_colors.dart';
import 'package:event_planning/utils/assets_Manger.dart';
import 'package:event_planning/widget/chooseDateOrTime.dart';
import 'package:event_planning/widget/customElevatedButton.dart';
import 'package:event_planning/widget/customTextFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../home/tap_even_Widget.dart';
import '../../l10n/app_localizations.dart';
import '../../model/event.dart';


class EventEditing extends StatefulWidget {
  static String routeName = 'EventEditing';

  const EventEditing({super.key});

  @override
  State<EventEditing> createState() => _EventEditingState();
}

class _EventEditingState extends State<EventEditing> {
  int selectedIndex = 0;


  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();


  String formattedDate = "";
  String formattedTime = "";
  String selectedImage = "";
  String selectedEvent = "";

  late EventListProvider eventListProvider;

  @override
  Widget build(BuildContext context) {
    eventListProvider = Provider.of<EventListProvider>(context);
    var args = ModalRoute.of(context)?.settings.arguments as Event;

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final eventsNameList = [
      AppLocalizations.of(context)!.sport,
      AppLocalizations.of(context)!.birthday,
      AppLocalizations.of(context)!.meeting,
      AppLocalizations.of(context)!.gaming,
      AppLocalizations.of(context)!.workshop,
      AppLocalizations.of(context)!.bookclub,
      AppLocalizations.of(context)!.exhibition,
      AppLocalizations.of(context)!.holiday,
      AppLocalizations.of(context)!.eating,
    ];

    final imageSelectedNameList = [
      AssetsManger.sports,
      AssetsManger.birthday,
      AssetsManger.meeting,
      AssetsManger.gaming,
      AssetsManger.workShop,
      AssetsManger.bookClub,
      AssetsManger.exhibition,
      AssetsManger.holiday,
      AssetsManger.eating,
    ];

    selectedEvent = eventsNameList[selectedIndex];
    selectedImage = imageSelectedNameList[selectedIndex];

    return BlocBuilder(
      bloc: EventEditingViewModel.get(context)..args=args..image=selectedImage..latLng=EventChooseLocationViewModel.get(context).latLng,
      builder:(context, state) =>  Scaffold(
        backgroundColor: Theme.of(context).splashColor,

        appBar: AppBar(
          backgroundColor: Theme.of(context).splashColor,

          centerTitle: true,
          iconTheme:  IconThemeData(color: AppColors.primaryLight),
          title: Text(
           AppLocalizations.of(context)!.edit_event,
            style: AppStyles.bold20Primary,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImagePreview(height, width, imageSelectedNameList),
                SizedBox(height: height * 0.02),
                _buildEventCategorySelector(width, height, eventsNameList),
                SizedBox(height: height * 0.02),
                _buildEventForm(context, width, height,args),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Helper Widgets ---------------- //

  Widget _buildImagePreview(
      double height, double width, List<String> imageList) {
    return Container(
      width: width * 0.6,
      height: height * 0.25,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
      child: Image.asset(
        imageList[selectedIndex],
        fit: BoxFit.fill
      ),
    );
  }

  Widget _buildEventCategorySelector(
      double width, double height, List<String> events) {
    return SizedBox(
      height: height * 0.05,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => SizedBox(width: width * 0.01),
        itemCount: events.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            selectedIndex = index;
            setState(() {});},

          child: TapEvenWidget(
            eventName: events[index],
            backgroundColor: AppColors.primaryLight,
            borderColor: AppColors.primaryLight,
            textSelectedStyle:Theme.of(context).textTheme.labelSmall!,
            textUnSelectedStyle: AppStyles.medium16Primary,
            isSelect: selectedIndex == index,
            selectedIconBackgroundColor:Theme.of(context).splashColor ,
            unselectedIconBackgroundColor: AppColors.primaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildEventForm(BuildContext context, double width, double height,Event args) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel(AppLocalizations.of(context)!.title),
        SizedBox(height: height * 0.02),
        CustomTextFiled(
          controller: EventEditingViewModel.get(context).editingTitle,
          hintText:EventEditingViewModel.get(context).args!.title,
          prefixIcon:  Icon(Icons.edit,color: Theme.of(context).dividerColor),
        ),
        SizedBox(height: height * 0.02),
        CustomTextFiled(
          controller: EventEditingViewModel.get(context).editingDescription,
          maxLines: 4,
          hintText: EventEditingViewModel.get(context).args!.description,
        ),
        SizedBox(height: height * 0.01),
        ChooseDateOrTime(
          iconName:  Icon(Icons.calendar_month_outlined,color:Theme.of(context).dividerColor ,),
          eventNameOrTime: AppLocalizations.of(context)!.event_date,
          chooseDateOrTime: EventEditingViewModel.get(context).dateTime == null
              ? AppLocalizations.of(context)!.choose_date
              :'${EventEditingViewModel.get(context).dateTime?.day}/${EventEditingViewModel.get(context).dateTime?.month}/${EventEditingViewModel.get(context).dateTime?.year}',
          onChooseDateOrTime: chooseDate,
        ),
        ChooseDateOrTime(
          iconName:  Icon(Icons.access_time,color: Theme.of(context).dividerColor),
          eventNameOrTime: AppLocalizations.of(context)!.event_time,
          chooseDateOrTime: EventEditingViewModel.get(context).time == null
              ? AppLocalizations.of(context)!.choose_time
              : EventEditingViewModel.get(context).time!.format(context).toString(),
          onChooseDateOrTime: chooseTime,
        ),
        SizedBox(height: height * 0.01),
        _buildLabel(AppLocalizations.of(context)!.location),
        SizedBox(height: height * 0.01),
        _buildLocationSelector(width, height),
        SizedBox(height: height * 0.02),
        CustomElevatedButton(onButtonClicked: (){
         EventEditingViewModel.get(context).latLng= EventChooseLocationViewModel.get(context).currentLatLng;
          EventEditingViewModel.get(context).eventEditing(context);
        },
          text:AppLocalizations.of(context)!.event_update,
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }

  Widget _buildLocationSelector(double width, double height) {
    return BlocBuilder(
      bloc: EditLocationViewModel.get(context)..getLocation(context),
      builder: (context, state) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: height * 0.01,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryLight,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () => setState(() {
        Navigator.pushNamed(context, EditLocation.routeName);
              }),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.02,
                  horizontal: width * 0.03,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryLight,
                ),
                child: Image.asset(AssetsManger.iconLocation),
              ),
            ),
            SizedBox(width: width * 0.02),
            Expanded(
              child: Text(
                EventChooseLocationViewModel.get(context).location??'Unknown',
                style: AppStyles.bold24Primary,
              ),
            ),
             Icon(Icons.arrow_forward_ios, color: AppColors.primaryLight),
          ],
        ),
      ),
    );
  }

  // ---------------- Logic Methods ---------------- //


  Future<void> chooseDate() async {
    final chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (chosenDate != null) {
      EventEditingViewModel.get(context).dateTime = chosenDate;
      formattedDate = DateFormat("dd/MM/yyyy").format(chosenDate);
      setState(() {});
    }
  }

  Future<void> chooseTime() async {
    final chosenTime =
    await showTimePicker(context: context, initialTime:TimeOfDay.now());

    if (chosenTime != null) {
      EventEditingViewModel.get(context).time = chosenTime;
      formattedTime = chosenTime.format(context);
      setState(() {});
    }
  }
}
