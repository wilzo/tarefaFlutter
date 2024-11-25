import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Events {
  String? id;
  String? description;
  DateTime? date;
  String? userId;
  bool? public;
  String? title;
  Events(
      {this.id,
      this.description,
      this.date,
      this.userId,
      this.public,
      this.title});

  Events copyWith({
    String? id,
    String? description,
    DateTime? date,
    String? userId,
    bool? public,
    String? title,
  }) {
    return Events(
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      public: public ?? this.public,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    debugPrint('toMap $date!');
    return {
      'id': id,
      'description': description,
      // 'date': date!.millisecondsSinceEpoch,
      'userId': userId,
      'public': public,
      'title': title,
      'date': date,
    };
  }

  //método construtor para salvar os dados do documento firebase
  Events.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    description = doc.get('description');
    date = (doc.get('date') as Timestamp).toDate();
    userId = doc.get('userId');
    public = doc.get('public');
    title = doc.get('title');
  }

  Events.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        description = doc.get('description'),
        date = (doc.get('date') as Timestamp).toDate(),
        userId = doc.get('userId'),
        public = doc.get('public'),
        title = doc.get('title');

  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
      id: map['id'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      userId: map['userId'],
      public: map['public'],
      title: map['title'],
    );
  }
  factory Events.fromDS(String id, Map<String, dynamic> data) {
    return Events(
      id: id,
      description: data['description'],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
      userId: data['user_id'],
      public: data['public'],
      title: data['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Events.fromJson(String source) => Events.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppEvent(id: $id, title: $title, description: $description, date: $date, userId: $userId, public: $public)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Events &&
        o.id == id &&
        o.title == title &&
        o.description == description &&
        o.date == date &&
        o.userId == userId &&
        o.public == public;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        userId.hashCode ^
        public.hashCode;
  }
}
