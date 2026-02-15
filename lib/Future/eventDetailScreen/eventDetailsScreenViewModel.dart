import 'package:event_planning/home_Screen.dart';
import 'package:event_planning/providers/eventListProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../firebaseutils.dart';
import '../../model/event.dart';
import 'eventDetailsScreenStates.dart';


class EventDetailsScreenViewModel extends Cubit<EventDetailsScreenStates>{
  EventDetailsScreenViewModel():super(EventDetailsScreenInitialState());

  static EventDetailsScreenViewModel get(context) => BlocProvider.of<EventDetailsScreenViewModel>(context);
 Future<void> deleteEvent(Event args,context)  async {
   final eventListProvider = Provider.of<EventListProvider>(context,listen: false);

   FirebaseUtils.getEventCollection().doc(args.id).delete();
 await eventListProvider.getAllEvent();
 Navigator.pushNamed(context, HomeScreen.routeName);
 emit(EventDetailsScreenEventDeletingState());
  }
}