import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../../providers/eventListProvider.dart';
import '../../../utils/app_colors.dart';
import 'googleMapStates.dart';

class GoogleMapViewModel extends Cubit<GoogleMapStates> {
  GoogleMapViewModel() : super(GoogleMapInitialState());
LatLng? MyLocation;
  Location location = Location();
  static GoogleMapViewModel get(context) => BlocProvider.of(context);

  GoogleMapController? mapController;
  Set<Circle> circles= {};

  LatLng currentLatLng = const LatLng(31.1328768,29.8156032);

  CameraPosition cameraPosition = const CameraPosition(zoom:10,
    target: LatLng(31.1328768,29.8156032),
  );

  Set<Marker> markers = {};
void addEventsMarker(context){
  final eventListProvider = Provider.of<EventListProvider>(context);
  for (int i = 0; i < eventListProvider.eventList.length; i++) {
    circles.add(
      Circle(
        radius: 10,
        strokeWidth: 15,
        fillColor: AppColors.black,
        strokeColor: AppColors.grey,
        circleId: CircleId(i.toString()),
        center: LatLng(
          eventListProvider.eventList[i].latitude ?? 0,
          eventListProvider.eventList[i].longitude ?? 0,
        ),
      ),
    );
    print("Circles: ${markers.length}");
  }

}
  void onMapTap(LatLng tappedLatLng) {
    currentLatLng = tappedLatLng;

    markers={Marker(markerId: MarkerId('h'),
      position: tappedLatLng

    )

    };

    cameraPosition = CameraPosition(target: tappedLatLng,zoom: 13);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    emit(GoogleMapUpdateState());
  }


  Future<void> getLocation() async {
    LocationData locationData = await location.getLocation();
    MyLocation=LatLng(locationData.longitude??0, locationData.latitude??0);
    onLocationChanged(locationData);
  }

  void onLocationChanged(LocationData locationData) {
    if (locationData.latitude == null || locationData.longitude == null) return;

    currentLatLng = LatLng(
      locationData.latitude!,
      locationData.longitude!,
    );
    markers = {
      Marker(
        markerId:  MarkerId('user'),
        position: currentLatLng,
      ),
    };

    cameraPosition = CameraPosition(
      zoom: 10,
      target: currentLatLng,
    );

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    emit(GoogleMapUpdateState());
  }
}
