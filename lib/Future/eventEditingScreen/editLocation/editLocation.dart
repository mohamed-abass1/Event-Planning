import 'package:event_planning/Future/eventEditingScreen/editLocation/editLocationViewModel.dart';
import 'package:event_planning/Future/eventEditingScreen/eventEditingViewModel.dart';
import 'package:event_planning/utils/app_colors.dart';
import 'package:event_planning/utils/app_styles%20copy.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditLocation  extends StatefulWidget {
static String routeName='EditLocation';

  @override
  State<EditLocation> createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc:EditLocationViewModel.get(context) ,
      builder: (BuildContext context, state) { return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: EditLocationViewModel.get(context).cameraPosition,
                markers:EditLocationViewModel.get(context).markers ,
                onTap: (argument) {
                  EditLocationViewModel.get(context).onMapTap(argument, context);
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
                child: Center(child: Text('Tap On Location To Change',style: AppStyles.regular20white,)),
              ),
            )
          ],
        ));
          },

    );
  }
}
