// import 'package:firebase_helpers/firebase_helpers.dart';

// class EventModel extends DatabaseService{
//   final String? id;
//   final String? title;
//   final String? description;
//   final DateTime? eventDate;

//   EventModel({this.id,this.title, this.description, this.eventDate}):super(id!);

//   factory EventModel.fromMap(Map data) {
//     return EventModel(
//       title: data['title'],
//       description: data['description'],
//       eventDate: data['event_date'],
//     );
//   }

//   factory EventModel.fromDS(String id, Map<String,dynamic> data) {
//     return EventModel(
//       id: id,
//       title: data['title'],
//       description: data['description'],
//       eventDate: data['event_date'].toDate(),
//     );
//   }
// }