import 'package:event_planning/Future/eventEditingScreen/eventEditingViewModel.dart';
import 'package:event_planning/chooseLocation/EventChooseLocationViewModel.dart';
import 'package:event_planning/utils/app_colors.dart';
import 'package:event_planning/utils/app_styles%20copy.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventChooseLocation  extends StatefulWidget {
static String routeName='ECL';

  @override
  State<EventChooseLocation> createState() => _EventChooseLocationState();
}

class _EventChooseLocationState extends State<EventChooseLocation> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc:EventChooseLocationViewModel.get(context) ,
      builder: (BuildContext context, state) { return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: EventChooseLocationViewModel.get(context).cameraPosition,
                markers:EventChooseLocationViewModel.get(context).markers ,
                onTap: (argument) {
                  EventChooseLocationViewModel.get(context).ChooseLatLng(argument,context);
                  EventChooseLocationViewModel.get(context).changeMarkerPosition(argument);
                },
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);

      }
      ,
              child: Container(height: 50,
                width: 500,

                color: AppColors.blueColor,
                child: Center(child: Text('Tap On Location To Select that',style: AppStyles.regular20white,)),
              ),
            )
          ],
        ));
          },

    );
  }
}
