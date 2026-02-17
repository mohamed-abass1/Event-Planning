
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
import 'chooseLocation/EventChooseLocationViewModel.dart';
import 'chooseLocation/eventChooseLocation.dart';
import '../firebaseutils.dart';
import '../widget/tap_even_Widget.dart';
import '../l10n/app_localizations.dart';
import '../model/event.dart';

class AddEvent extends StatefulWidget {
  static String routeName = 'edit_evently';

  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  int selectedIndex = 0;


  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String formattedDate = "";
  String formattedTime = "";
  String selectedImage = "";
  String selectedEvent = "";

  late EventListProvider eventListProvider;

  @override
  Widget build(BuildContext context) {
    eventListProvider = Provider.of<EventListProvider>(context);

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
      bloc: EventChooseLocationViewModel.get(context)..getLocation(context),
      builder:(context, state) =>  Scaffold(
        backgroundColor: Theme.of(context).splashColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).splashColor,
          centerTitle: true,
          iconTheme:  IconThemeData(color: AppColors.primaryLight),
          title: Text(
            AppLocalizations.of(context)!.create_event,
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
                _buildEventForm(context, width, height),
              ],
            ),
          ),
        ),
      ),
    );
  }


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
            setState(() {});
          },
          child: TapEvenWidget(
            eventName: events[index],
            backgroundColor: AppColors.primaryLight,
            borderColor: AppColors.primaryLight,
            textSelectedStyle:Theme.of(context).textTheme.labelSmall!,
            textUnSelectedStyle: AppStyles.medium16Primary,
            isSelect: selectedIndex == index,
            selectedIconBackgroundColor: Theme.of(context).splashColor, unselectedIconBackgroundColor:AppColors.primaryLight,

          ),
        ),
      ),
    );
  }

  Widget _buildEventForm(BuildContext context, double width, double height) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLabel(AppLocalizations.of(context)!.title),
          SizedBox(height: height * 0.02),
          CustomTextFiled(
            controller: titleController,
            hintText: AppLocalizations.of(context)!.event_title,
            prefixIcon: const Icon(Icons.edit),
            validator: (text) =>
            (text == null || text.isEmpty) ? "Please Enter Event Title" : null,
          ),
          SizedBox(height: height * 0.02),
          CustomTextFiled(
            controller: descriptionController,
            maxLines: 4,
            hintText: AppLocalizations.of(context)!.event_description,
            validator: (text) => (text == null || text.isEmpty)
                ? "Please Enter Event description"
                : null,
          ),
          SizedBox(height: height * 0.01),
          ChooseDateOrTime(
            iconName: const Icon(Icons.calendar_month_outlined),
            eventNameOrTime: AppLocalizations.of(context)!.event_date,
            chooseDateOrTime: selectedDate == null
                ? AppLocalizations.of(context)!.choose_date
                : DateFormat("dd/MM/yyyy").format(selectedDate!),
            onChooseDateOrTime: chooseDate,
          ),
          ChooseDateOrTime(
            iconName: const Icon(Icons.access_time),
            eventNameOrTime: AppLocalizations.of(context)!.event_time,
            chooseDateOrTime: selectedTime == null
                ? AppLocalizations.of(context)!.choose_time
                : formattedTime,
            onChooseDateOrTime: chooseTime,
          ),
          SizedBox(height: height * 0.01),
          _buildLabel(AppLocalizations.of(context)!.location),
          SizedBox(height: height * 0.01),
          _buildLocationSelector(width, height),
          SizedBox(height: height * 0.02),
          CustomElevatedButton(
            text: AppLocalizations.of(context)!.add_event,
            onButtonClicked: addEvent,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style:Theme.of(context).textTheme.bodyMedium);
  }

  Widget _buildLocationSelector(double width, double height) {
    return BlocBuilder(
      bloc: EventChooseLocationViewModel.get(context)..getSelectedLocation(context),
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
        Navigator.pushNamed(context, EventChooseLocation.routeName);
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

  void addEvent() {
    if (formKey.currentState?.validate() == true) {
      if (selectedDate == null || selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please choose both date and time for the event!"),
          ),
        );
        return;
      }

      final event = Event(
        title: titleController.text,
        description: descriptionController.text,
        image: selectedImage,
        dateTime: selectedDate!,
        eventName: selectedEvent,
        time: formattedTime,
        latitude: EventChooseLocationViewModel.get(context).latLng.latitude.toDouble(),
        longitude: EventChooseLocationViewModel.get(context).latLng.longitude.toDouble()
      );

      FirebaseUtils.addEventToFireStore(event).timeout(
        const Duration(milliseconds: 500),
        onTimeout: () {
          debugPrint("Event added successfully");
          const SnackBar(content: Text("Event Added"));
          eventListProvider.getAllEvent();
          Navigator.pop(context);
        },
      );

      debugPrint("Event Title: ${titleController.text}");
      debugPrint("Event Description: ${descriptionController.text}");
      debugPrint("Event Date: $formattedDate");
      debugPrint("Event Time: $formattedTime");
    }
  }

  Future<void> chooseDate() async {
    final chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (chosenDate != null) {
      selectedDate = chosenDate;
      formattedDate = DateFormat("dd/MM/yyyy").format(chosenDate);
      setState(() {});
    }
  }

  Future<void> chooseTime() async {
    final chosenTime =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (chosenTime != null) {
      selectedTime = chosenTime;
      formattedTime = chosenTime.format(context);
      setState(() {});
    }
  }
}
