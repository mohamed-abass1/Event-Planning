
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/event.dart';
import '../providers/eventListProvider.dart';
import '../utils/app_Styles.dart';
import '../utils/app_colors.dart';
import '../utils/assets_Manger.dart';

class EventItemWidget extends StatelessWidget {
  final Event event;
  EventItemWidget({required this.event});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final eventListProvider = Provider.of<EventListProvider>(context);

    return Container(
      height: size.height * 0.25,
      margin: EdgeInsets.symmetric(vertical:size.height*0.01 ,horizontal: size.width * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.primaryLight, width: 2),
        image: DecorationImage(
          image: AssetImage(event.image),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateBox(size,context),
            const Spacer(),
            _buildBottomInfo(context, eventListProvider, size),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBox(Size size,context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            event.dateTime.day.toString(),
            style: AppStyles.bold20Primary,
          ),
          Text(
            DateFormat("MMM").format(event.dateTime),
            style: AppStyles.bold20Primary,
          ),
        ],
      ),
    );
  }

  /// 🎟 Bottom container showing title and favorite icon
  Widget _buildBottomInfo(
      BuildContext context,
      EventListProvider provider,
      Size size,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.height * 0.012,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              event.title,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () => provider.updateFavoriteEvent(event),
            child: Image.asset(
              event.isFavorite
                  ? AssetsManger.iconSelectedFavorite
                  : AssetsManger.iconArtUnSelected,
              color: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
