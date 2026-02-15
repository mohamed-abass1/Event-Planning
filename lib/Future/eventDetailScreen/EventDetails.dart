import 'package:event_planning/Future/eventEditingScreen/EventEditing.dart';
import 'package:event_planning/model/event.dart';
import 'package:event_planning/utils/app_colors.dart';
import 'package:event_planning/utils/app_styles%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../l10n/app_localizations.dart';
import 'eventDetailsScreenStates.dart';
import 'eventDetailsScreenViewModel.dart';

class EventDetails extends StatefulWidget {
static String routeName='EventDetails';

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
Widget build(BuildContext context) {
   var args = ModalRoute.of(context)?.settings.arguments as Event;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
   String location='unknow';
   // Future<void> getLocation(context) async {
   //   List<Placemark> placemarks = await placemarkFromCoordinates(
   //       args.latitude??0,
   //       args.longitude??0);
   //
   //   if (placemarks.isNotEmpty) {
   //     location = placemarks[0].administrativeArea ?? 'Unknown';
   //
   //   }
   // }
    return BlocBuilder<EventDetailsScreenViewModel,EventDetailsScreenStates>(
      bloc: EventDetailsScreenViewModel.get(context),
      builder:(context, state) =>  Scaffold(
        backgroundColor: Theme.of(context).splashColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).splashColor,
        leading: InkWell(onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back,color: AppColors.primaryLight ,)),
          centerTitle: true,

          actions: [
            InkWell(onTap: () {
              Navigator.pushNamed(context, EventEditing.routeName,arguments: args);
            },
                child: Icon(Icons.edit,color: AppColors.primaryLight,)),

            InkWell(onTap: (){EventDetailsScreenViewModel.get(context).deleteEvent(args,context);
              Navigator.pop(context);},
                child: Icon(Icons.delete,color: AppColors.redColor,)
            )],
          title: Text(AppLocalizations.of(context)!.event_details,style: AppStyles.medium16Primary,),),
        body: Padding(
          padding:  EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(borderRadius: BorderRadiusGeometry.all(Radius.circular(25)),
                      child: Image.asset(args.image)),
                ),
                SizedBox(height: height*0.015,),
                Text(args.title,style: AppStyles.bold20Primary,),
                SizedBox(height: height*0.015,),

                Container(padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryLight,width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  child: Row(
                  children: [
                    Container(padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.primaryLight,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Icon(Icons.calendar_month_outlined,color: AppColors.whiteColor,size: height*0.032,)),
                    SizedBox(width: width*0.02,),
                    Column(children: [
                      Text("${args.dateTime.day}/${args.dateTime.month}/${args.dateTime.year}",style: AppStyles.medium20Primary,),
                      Text('${args.time}',style: Theme.of(context).textTheme.titleMedium,),

                    ],)
                  ],
                ),),
                SizedBox(height: height*0.015,),
                Container(padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryLight,width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(16))
                  ),
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.all(12.5),
                          decoration: BoxDecoration(color: AppColors.primaryLight,
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Icon(Icons.my_location_rounded,color: AppColors.whiteColor,size: height*0.032,)),
                      SizedBox(width: width*0.02,),
                      Column(children: [
                        Text(location,style: AppStyles.bold20Primary,),
                      ],)
                    ],
                  ),),
                SizedBox(height: height*0.015,),

                Container(
                  decoration: BoxDecoration(border: Border.all(color: AppColors.primaryLight,width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: SizedBox(
                      height:height*0.4,
                      child: GoogleMap(zoomControlsEnabled: false,
                          circles:{Circle(circleId: CircleId('eventLocation'),
                              center: LatLng(args.latitude??5000, args.longitude??5000),fillColor: AppColors.black,radius:5,strokeWidth: 7,strokeColor: AppColors.grey)} ,
                          initialCameraPosition: CameraPosition(zoom: 19,
                              target: LatLng(args.latitude??0, args.longitude??0)))),
                ),
                SizedBox(height: height*0.015,),

                Text(AppLocalizations.of(context)!.description,style: AppStyles.medium16black,),
                SizedBox(height: height*0.007,),
                Text(args.description,style: Theme.of(context).textTheme.titleMedium,)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
