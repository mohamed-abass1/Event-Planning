import 'package:event_planning/Future/eventEditingScreen/editLocation/editLocationViewModel.dart';
import 'package:event_planning/Future/eventEditingScreen/eventEditingStates.dart';
import 'package:event_planning/chooseLocation/EventChooseLocationViewModel.dart';
import 'package:event_planning/home_Screen.dart';
import 'package:event_planning/providers/eventListProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../firebaseutils.dart';
import '../../model/event.dart';

class EventEditingViewModel extends Cubit<EventEditingStates> {
  EventEditingViewModel() : super(EventEditingInitialState());
  LatLng? latLng;
  TextEditingController editingTitle = TextEditingController();
  TextEditingController editingDescription = TextEditingController();
  String? image;
  DateTime? dateTime;
  TimeOfDay? time;
  Event? args;

  static EventEditingViewModel get(context) => BlocProvider.of<EventEditingViewModel>(context);

  Future<void> eventEditing(context)  async {
    final eventListProvider = Provider.of<EventListProvider>(context,listen: false);
  latLng=  EditLocationViewModel.get(context).editedLocation;
     FirebaseUtils.getEventCollection().doc(args?.id).update({
      "latitude": latLng?.latitude??args?.latitude,
      "longitude": latLng?.longitude??args?.longitude,
      "title": editingTitle.text == '' ? args?.title : editingTitle.text,
      "description":
          editingDescription.text == '' ? args?.description : editingDescription.text,
      "image": image ?? args?.image,
      "dateTime": dateTime?.millisecondsSinceEpoch ??
          args?.dateTime.millisecondsSinceEpoch,
      "time": time?.format(context) ?? args?.time,
    });
    await eventListProvider.getAllEvent();
    print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
Navigator.pushNamed(context, HomeScreen.routeName);
    emit(EventEditingSuccessState());
  }
}
