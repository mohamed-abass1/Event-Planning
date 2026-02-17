
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/eventListProvider.dart';
import '../../../utils/app_Styles.dart';
import '../../../utils/assets_Manger.dart';
import '../../../widget/customTextFiled.dart';
import '../../../widget/event_item_widget.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    final eventListProvider = Provider.of<EventListProvider>(context);

    if (eventListProvider.favoriteEventList.isEmpty) {
      eventListProvider.getFavoriteEvent();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      appBar: AppBar(backgroundColor: Theme.of(context).splashColor,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextFiled(
              hintText: AppLocalizations.of(context)!.search_event,
              hintStyle: AppStyles.bold14Primary,
              style: AppStyles.medium16Primary,
              prefixIcon: Image.asset(AssetsManger.iconSearch),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: eventListProvider.favoriteEventList.isEmpty
                  ? Center(
                child: Text(
                  'No Favorite Event',
                  style: AppStyles.bold20Black,
                ),
              )
                  : ListView.builder(
                itemCount:
                eventListProvider.favoriteEventList.length,
                itemBuilder: (context, index) => EventItemWidget(
                  event:
                  eventListProvider.favoriteEventList[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
