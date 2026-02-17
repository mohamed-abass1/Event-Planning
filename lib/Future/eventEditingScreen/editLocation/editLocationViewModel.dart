import 'package:event_planning/Future/eventEditingScreen/eventEditingViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'editLocationStates.dart';

class EditLocationViewModel extends Cubit<EditLocationStates> {
  EditLocationViewModel() : super(EditLocationInitialState());
  static EditLocationViewModel get(context) => BlocProvider.of(context);
  String? location;
  Future<void> getLocation(context) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude.toDouble(),
        latLng.longitude.toDouble());

    if (placemarks.isNotEmpty) {
        location = placemarks[0].administrativeArea ?? 'Unknown';
        emit(EditLocationChangedSuccessState());
    }
  }

LatLng latLng=LatLng(31.1328768,29.8156032);
  LatLng? editedLocation;
  late CameraPosition cameraPosition = CameraPosition(
  target: latLng,
  zoom: 18,
  );

  late Set<Marker> markers = {
  Marker(
  markerId:  const MarkerId('changedLocation'),
  position: latLng
  ),
  };


  void ChooseLatLng(LatLng newLatLng,context){
    editedLocation=newLatLng;

    EventEditingViewModel.get(context).latLng=newLatLng;
    emit(EditLocationChangedSuccessState());
  }

  void onMapTap(LatLng tappedLatLng,context) {
    editedLocation = tappedLatLng;
    latLng=tappedLatLng;
     ChooseLatLng(tappedLatLng, context);
    markers = {
      Marker(
        markerId: const MarkerId('user'),
        position: tappedLatLng,
      )
    };


    cameraPosition = CameraPosition(target: tappedLatLng, zoom: 18);
    emit(EditLocationChangedSuccessState());

  }

}