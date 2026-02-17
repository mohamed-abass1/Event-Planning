import 'package:event_planning/providers/eventListProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/googleMapItemWidget.dart';
import 'googleMapStates.dart';
import 'googleMapViewModel.dart';
class GoogleMapScreen extends StatefulWidget {
  static String route = 'googleMap';

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  bool _initialized = false;


  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final mapViewModel = GoogleMapViewModel.get(context);
      mapViewModel.addEventsMarker(context); // SAFE here
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapViewModel = GoogleMapViewModel.get(context);
    final eventListProvider = Provider.of<EventListProvider>(context);

    return BlocBuilder<GoogleMapViewModel, GoogleMapStates>(
      bloc: mapViewModel,
      builder: (context, state) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 25, left: 25),
          child: FloatingActionButton(
            backgroundColor: AppColors.blueColor,
            child: const Icon(
              Icons.location_searching_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              if (mapViewModel.mapController != null) {
                mapViewModel.getLocation();
              }
            },
          ),
        ),

        body:  Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GoogleMap(
              circles: mapViewModel.circles,
              initialCameraPosition: mapViewModel.cameraPosition,
              markers: mapViewModel.markers,
              onTap: (LatLng tappedPos) {
                mapViewModel.onMapTap(tappedPos);
              },
              onMapCreated: (controller) {
                mapViewModel.mapController = controller;
              },
             myLocationButtonEnabled: false,
padding: EdgeInsets.only(bottom: 170),
              mapType: MapType.terrain,
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              buildingsEnabled: true,
              trafficEnabled: true,
            ),

            Column(
              children: [
                Spacer(flex: 3),
                Expanded(
                  child: PageView.builder(

                    itemCount: eventListProvider.eventList.length,
                    scrollDirection: Axis.horizontal,
                    controller: PageController(viewportFraction: 0.8),
                    itemBuilder: (context, index) {
                      return GoogleMapItemWidget(

                        event: eventListProvider.eventList[index],
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
