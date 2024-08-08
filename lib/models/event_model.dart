import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum EventType {
  exhibition,
  tour,
  concert,
  games,
  workshops,
  festival,
  competition,
  conference,
  hackathon,
  webinar,
  seminar,
  fundraising,
  booth,
}

enum EventStatus {
  scheduled,
  ongoing,
  completed,
  cancelled,
  rescheduled,
}

const Map<EventStatus, Color> eventStatusColor = {
  EventStatus.cancelled: Color.fromARGB(255, 255, 66, 66),
  EventStatus.completed: Color.fromARGB(255, 199, 194, 194),
  EventStatus.ongoing: Color.fromARGB(255, 120, 255, 125),
  EventStatus.rescheduled: Colors.amber,
  EventStatus.scheduled: Color.fromARGB(255, 113, 191, 255)
};

class EventModel {
  final String? id;
  final String organizerEmail;
  final String title;
  final String description;
  final String venue;
  final double fees;
  final String contact;
  final EventType type;
  final List<Map<DateTime, DateTime>> datetime;
  final int capacity;
  final String imageLink;
  final bool isAnonymous;
  final EventStatus status;
  final Map<String, String>? materials;
  final List<String>? participants;

  EventModel({
    this.id,
    required this.organizerEmail,
    required this.title,
    required this.description,
    required this.venue,
    required this.fees,
    required this.contact,
    required this.type,
    required this.datetime,
    required this.capacity,
    required this.imageLink,
    required this.isAnonymous,
    required this.status,
    this.materials,
    this.participants,
  });

  factory EventModel.fromMap(String id, Map<String, dynamic> map) => EventModel(
        id: id,
        organizerEmail: map['organizerEmail'],
        title: map['title'],
        description: map['description'],
        venue: map['venue'],
        // fees: (map['fees'] as num).toDouble(),
        fees: map['fees'],
        contact: map['contact'],
        type: EventType.values
            .firstWhere((e) => e.toString() == 'EventType.${map['type']}'),
        datetime:
            (map['datetime'] as Map<String, dynamic>).entries.map((entry) {
          return {
            DateTime.parse(entry.key): (entry.value as Timestamp).toDate()
          };
        }).toList(),
        capacity: map['capacity'],
        imageLink: map['imageLink'],
        isAnonymous: map['isAnonymous'],
        status: EventStatus.values
            .firstWhere((stat) => stat.toString() == 'EventStatus.${map['status']}'),
        materials: Map<String, String>.from(map['materials']),
        participants: List<String>.from(map['participants']),
      );

  Map<String, dynamic> toMap() => {
        'organizerEmail': organizerEmail,
        'title': title,
        'description': description,
        'venue': venue,
        'fees': fees,
        'contact': contact,
        'type': type.toString().split('.').last,
        'datetime': {
          for (var entry in datetime)
            entry.keys.first.toIso8601String():
                Timestamp.fromDate(entry.values.first)
        },
        'capacity': capacity,
        'imageLink': imageLink,
        'isAnonymous': isAnonymous,
        'status': status.toString().split('.').last,
        'materials': materials ?? {},
        'participants': participants ?? [],
      };

  EventModel copyWith({
    String? id,
    String? organizerEmail,
    String? title,
    String? description,
    String? venue,
    double? fees,
    String? contact,
    EventType? type,
    List<Map<DateTime, DateTime>>? datetime,
    int? capacity,
    String? imageLink,
    bool? isAnonymous,
    EventStatus? status,
    Map<String, String>? materials,
    List<String>? participants,
  }) =>
      EventModel(
        id: id ?? this.id,
        organizerEmail: organizerEmail ?? this.organizerEmail,
        title: title ?? this.title,
        description: description ?? this.description,
        venue: venue ?? this.venue,
        fees: fees ?? this.fees,
        contact: contact ?? this.contact,
        type: type ?? this.type,
        datetime: datetime ?? this.datetime,
        capacity: capacity ?? this.capacity,
        imageLink: imageLink ?? this.imageLink,
        isAnonymous: isAnonymous ?? this.isAnonymous,
        status: status ?? this.status,
        materials: materials ?? this.materials ?? {},
        participants: participants ?? this.participants ?? [],
      );
}
