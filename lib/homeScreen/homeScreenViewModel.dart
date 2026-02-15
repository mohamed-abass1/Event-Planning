import 'package:event_planning/chooseLocation/EventChooseLocationViewModel.dart';
import 'package:event_planning/homeScreen/HomeScreenStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreenViewModel extends Cubit<HomeScreenStates>{
  HomeScreenViewModel():super(HomeScreenStatesInitialState());
  static HomeScreenViewModel get(context) => BlocProvider.of(context);
  Location location = Location();
  LatLng MyLocation=LatLng(30.03497, 31.56346);
  Future<void> getLocation(context) async {
    if (!await _getLocationPermission()) return;
    if (!await _locationServiceEnabled()) return;

    await location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
    );

    LocationData locationData = await location.getLocation();

    while (locationData.latitude == null ||
        locationData.longitude == null ||
        (locationData.latitude == 0 && locationData.longitude == 0)) {
      await Future.delayed(const Duration(seconds: 1));
      locationData = await location.getLocation();
    }

    MyLocation = LatLng(
      locationData.latitude!,
      locationData.longitude!,
    );

    print("REAL LOCATION => ${MyLocation.latitude}, ${MyLocation.longitude}");
EventChooseLocationViewModel.get(context).latLng=MyLocation;
    emit(HomeScreenStatesGetLocationSuccessState());
  }


  Future<bool> _getLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
    }
    return permissionStatus == PermissionStatus.granted;
  }


  Future<bool> _locationServiceEnabled() async {
    bool enabled = await location.serviceEnabled();
    if (!enabled) enabled = await location.requestService();
    return enabled;
  }


}