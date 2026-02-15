import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/event.dart';

class FirebaseUtils {
  static CollectionReference<Event> getEventCollection() {
    return FirebaseFirestore.instance
        .collection(Event.collectionName)
        .withConverter<Event>(
            fromFirestore: (snapshot, option) =>
                Event.fromFireStore(snapshot.data()),
            toFirestore: (event, _) => event.toFireStore());
  }

  static Future< void> addEventToFireStore(Event event) {
    CollectionReference<Event> collectionRef = getEventCollection();
    DocumentReference<Event> docRef = collectionRef.doc();
    event.id= docRef.id;
    return docRef.set(event);
  }
}
