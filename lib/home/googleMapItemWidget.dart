import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';


import '../model/event.dart';
import '../utils/app_Styles.dart';
import '../utils/app_colors.dart';
class GoogleMapItemWidget extends StatefulWidget {
  final Event event;

  GoogleMapItemWidget({required this.event});

  @override
  _GoogleMapItemWidgetState createState() => _GoogleMapItemWidgetState();
}

class _GoogleMapItemWidgetState extends State<GoogleMapItemWidget> {
  String? location;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(widget.event.latitude??0, widget.event.longitude??0);

    if (placemarks.isNotEmpty) {
      setState(() {
        location = placemarks[0].administrativeArea ?? 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.fromLTRB(0,45,7,45),
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.primaryLight, width: 3),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(8)),
            child: Image.asset(
              widget.event.image,
              
              width: size.width * 0.4,
            ),
          ),
          SizedBox(width: size.width * 0.008),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.bold24Primary,
                ),
                Row(
                  children: [
                     Icon(Icons.location_on_outlined,color: Theme.of(context).cardColor),
                    SizedBox(width: size.width * 0.008),
                    Expanded(
                      child: Text(
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        location ?? 'unKnown',

                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
