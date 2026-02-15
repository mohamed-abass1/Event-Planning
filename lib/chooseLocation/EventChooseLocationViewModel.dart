import 'package:event_planning/chooseLocation/EventChooseLocationStates.dart';
import 'package:event_planning/homeScreen/homeScreenViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventChooseLocationViewModel extends Cubit<EventChooseLocationStates> {
  EventChooseLocationViewModel() : super(EventChooseLocationInitialState());
  static EventChooseLocationViewModel get(context) => BlocProvider.of(context);
  String? location;
  LatLng latLng=LatLng(31.1328768,29.8156032);

  Future<void> getLocation(context) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        HomeScreenViewModel.get(context).MyLocation.latitude.toDouble(),
        HomeScreenViewModel.get(context).MyLocation.longitude.toDouble());

    if (placemarks.isNotEmpty) {
        location = placemarks[0].administrativeArea ?? 'Unknown';
        emit(LocationChangedSuccessState());

    }
  }

  Future<void> getSelectedLocation(context) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude.toDouble(),
        latLng.longitude.toDouble());

    if (placemarks.isNotEmpty) {
      location = placemarks[0].administrativeArea ?? 'Unknown';
      emit(LocationChangedSuccessState());

    }
  }

  LatLng currentLatLng =  LatLng(31.1328768,29.8156032);
  late CameraPosition cameraPosition = CameraPosition(
  target: currentLatLng,
  zoom: 18,
  );

  late Set<Marker> markers = {
  Marker(
  markerId:  MarkerId('event'),
  position: latLng
  ),
  };


  void ChooseLatLng(LatLng newLatLng,context){
    latLng=newLatLng;
    print(latLng);
    emit(LocationChangedSuccessState());
  }

  void onMapTap(LatLng tappedLatLng) {
    currentLatLng = tappedLatLng;

    markers = {
      Marker(
        markerId: const MarkerId('user'),
        position: tappedLatLng,
      )
    };


    cameraPosition = CameraPosition(target: tappedLatLng, zoom: 18);
    emit(LocationChangedSuccessState());

  }
  void changeMarkerPosition(LatLng newLatLng){
    markers={
      Marker(
          position:newLatLng ,
          markerId: MarkerId('user')
      )
    };
    emit(EventChooseLocationSuccessState());
  }
  void saveLocationSuccessfully(context){

    Navigator.pop(context);
    emit(LocationChangedSuccessState());
  }

}