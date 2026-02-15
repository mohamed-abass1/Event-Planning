import 'package:flutter/material.dart';
import '../firebaseutils.dart' show FirebaseUtils;
import '../l10n/app_localizations.dart';
import '../model/event.dart';
import '../widget/toastMessage.dart';
class EventListProvider extends ChangeNotifier {
  int selectedIndex = 0;
  List<String> eventsNameList = [];
  List<Event> eventList = [];
  List<Event> filterList = [];
  List<Event> favoriteEventList = [];

  void getEventNameList(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    eventsNameList = [
      loc.all,
      loc.sport,
      loc.birthday,
      loc.meeting,
      loc.gaming,
      loc.workshop,
      loc.bookclub,
      loc.exhibition,
      loc.holiday,
      loc.eating,
    ];
  }

  Future<void> getAllEvent() async {
    print('Fetching all events...');
    final snapshot = await FirebaseUtils.getEventCollection().get();

    eventList = snapshot.docs.map((e) => e.data()).toList();
    filterList = List<Event>.from(eventList)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    notifyListeners();
  }

  void getFilterEvent() {
    final selectedCategory =
    eventsNameList[selectedIndex].trim().toLowerCase();

    filterList = eventList.where((event) {
      final name = event.eventName.trim().toLowerCase();
      return selectedCategory == name;
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    notifyListeners();
  }

  void changeSelectedIndex(int newSelectedIndex) {
    selectedIndex = newSelectedIndex;
    selectedIndex == 0 ? getAllEvent() : getFilterEvent();
  }

  Future<void> getFavoriteEvent() async {
    final query = FirebaseUtils.getEventCollection()
        .orderBy('dateTime')
        .where('isFavorite', isEqualTo: true);

    final snapshot = await query.get();

    favoriteEventList = snapshot.docs.map((e) => e.data()).toList();
    notifyListeners();
  }

  void updateFavoriteEvent(Event event) {
    FirebaseUtils.getEventCollection()
        .doc(event.id)
        .update({'isFavorite': !event.isFavorite})
        .timeout(
      const Duration(milliseconds: 500),
      onTimeout: () {
        ToastMessage.toastMsg(msg: 'Event Update successfully');
        selectedIndex == 0 ? getAllEvent() : getFilterEvent();
        getFavoriteEvent();
      },
    );

    notifyListeners();
  }

  Object? operator [](int other) {}
}
