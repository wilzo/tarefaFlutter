import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:mercadinho/commons/data_constants.dart';
import 'package:mercadinho/models/event/events.dart';
import 'package:intl/intl.dart';

class EventServices {
  //instância para persistência dos dados no Firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Events? appEvent;
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('events');
  DocumentReference get _firestoreRef =>
      _firestore.doc('events/${appEvent!.id}');

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  final eventDBS = DatabaseService<Events>(
    AppDBConstants.eventsCollection,
    fromDS: (id, data) => Events.fromDS(id, data!),
    toMap: (event) => event.toMap(),
  );

  Future<void> addEventTime(DateTime date, Events events) async {
    debugPrint('CRUD - $date');
    await _firestore.collection('events').add(events.toMap());
  }

  Future<void> addEventTimeObject(DateTime date, Events events) async {
    debugPrint('CRUD - $date');
    await _firestore.collection('events').add({
      'userId': '1234',
      'date': date, //DateFormat('MM/dd/yyyy').format(date),
      'title': events.title,
      'description': events.description,
      'public': events.public,
    });
  }

  Stream<QuerySnapshot> getEventTime(String userId) {
    return _firestore
        .collection('events')
        .where('userId', isEqualTo: userId)
        .orderBy('date')
        .snapshots();
  }

  Future<Events?> getEventsById(String? id) async {
    final docProduct = _firestore.collection('events').doc(id);
    final snapShot = await docProduct.get();
    if (snapShot.exists) {
      return Events.fromDocument(snapShot);
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot> getAllEvents() {
    return _collectionRef.snapshots();
  }

  Future<List<Events>> getEvents(String userId) async {
    List<Events> listEvents = [];
    final result = await _collectionRef.get();
    listEvents = result.docs.map((e) => Events.fromSnapshot(e)).toList();
    return listEvents;
  }

  Future<List?> getCalendarEvents(String? userId) async {
    List<dynamic>? eventList;

    try {
      final calendarEvent =
          await _firestore.collection('events').doc(userId).get();
      eventList = calendarEvent.data()!["calendarEvents"];
    } catch (e) {
      print(e);
    }

    return eventList;
  }
}
