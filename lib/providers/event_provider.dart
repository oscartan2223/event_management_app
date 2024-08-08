import 'dart:io';

import 'package:assignment/models/event_model.dart';
import 'package:assignment/models/profile_model.dart';
import 'package:assignment/providers/file_provider.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/repositories/event_repository.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final EventRepository _eventRepository = EventRepository();

  List<EventModel> _eventList = [];

  List<EventModel> get events => _eventList;

  Future<void> getEvents() async {
    _eventRepository.getAllEvents().listen((snapshot) {
      _eventList = snapshot.docs
          .map((doc) => EventModel.fromMap(doc.id, doc.data()))
          .toList();
      notifyListeners();
    });
    updateStatus();
  }

  Future<EventModel?> organizeEvent(
      EventModel event, File image, Map<String, File> materials) async {
    try {
      String id = await _eventRepository.addEvent(event);
      String? imageLink = await FileProvider.uploadEventImage(image, id);

      Map<String, String> eventMaterials = {};
      if (materials.isNotEmpty) {
        for (String fileName in materials.keys) {
          String? link = await FileProvider.uploadEventFile(
              materials[fileName]!, id, fileName);
          if (link != null) {
            eventMaterials[fileName] = link;
          }
        }
      }

      if (imageLink != null) {
        EventModel eventOrganized = event.copyWith(
            id: id, materials: eventMaterials, imageLink: imageLink);
        bool status = await _eventRepository.updateEvent(eventOrganized);
        if (status) {
          return eventOrganized;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateStatus() async {
    for (EventModel event in _eventList) {
      for (Map<DateTime, DateTime> datetime in event.datetime) {
        if (event.status == EventStatus.cancelled ||
            event.status == EventStatus.completed) {
          break;
        }
        if (datetime.values.last.isBefore(DateTime.now())) {
          await _eventRepository
              .updateEvent(event.copyWith(status: EventStatus.completed));
        } else if (datetime.keys.first.isBefore(DateTime.now()) &&
            datetime.values.last.isAfter(DateTime.now())) {
          await _eventRepository
              .updateEvent(event.copyWith(status: EventStatus.ongoing));
        }
      }
    }
  }

  EventModel getEvent(String id) {
    return events.firstWhere((event) => event.id == id);
  }

  Future<void> joinEvent(EventModel event, ProfileModel user) async {
    List<String>? participants = event.participants;
    if (participants != null) {
      participants.add(user.email);
    } else {
      participants = [user.email];
    }
    bool status = await _eventRepository
        .updateEvent(event.copyWith(participants: participants));
    if (status) {
      ProfileProvider().joinEvent(event.id!, user);
    }
  }

  Future<void> leaveEvent(EventModel event, ProfileModel user) async {
    List<String>? participants = event.participants;
    if (participants != null) {
      participants.remove(user.email);
    }
    if (await ProfileProvider().leaveEvent(event.id!, user)) {
      await _eventRepository
          .updateEvent(event.copyWith(participants: participants));
    }
  }

  Future<Map<String, String>> getEventUserImages(
      String organizer, List<String>? participants) async {
    Map<String, String> eventUserImages = {};
    eventUserImages[organizer] = await ProfileProvider()
        .getOthersProfile(organizer)
        .then((profile) => profile.imageLink);
    if (participants != null) {
      for (String participant in participants) {
        eventUserImages[participant] = await ProfileProvider()
            .getOthersProfile(participant)
            .then((profile) => profile.imageLink);
      }
    }
    return eventUserImages;
  }

  Future<EventModel?> editEvent(EventModel event,
      {Map<String, String>? materials,
      Map<String, File>? newMaterials,
      List<Map<DateTime, DateTime>>? sessions,
      File? image}) async {
    bool status1 = false;
    bool status2 = false;
    bool status3 = false;
    if (materials != null) {
      Map<String, String> eventMaterials = {};
      if (materials.isNotEmpty) {
        for (String fileName in materials.keys) {
          eventMaterials[fileName] = materials[fileName]!;
        }
      }

      if (newMaterials != null) {
        if (newMaterials.isNotEmpty) {
          for (String fileName in newMaterials.keys) {
            String? link = await FileProvider.uploadEventFile(
                newMaterials[fileName]!, event.id!, fileName);
            if (link != null) {
              eventMaterials[fileName] = link;
            }
          }
        }
      }
      event = event.copyWith(materials: eventMaterials);
      status1 = true;
    }
    if (sessions != null) {
      event =
          event.copyWith(datetime: sessions, status: EventStatus.rescheduled);
      status2 = true;
    }
    if (image != null) {
      String? imageLink = await FileProvider.uploadEventImage(image, event.id!);
      if (imageLink != null) {
        event = event.copyWith(imageLink: imageLink);
        status3 = true;
      }
    }
    bool status = false;
    if (status1 || status2 || status3) {
      status = await _eventRepository.updateEvent(event);
    }
    if (status) {
      return event;
    }
    return null;
  }

  Future<EventModel?> cancelEvent(EventModel event) async {
    event = event.copyWith(status: EventStatus.cancelled);
    bool status = await _eventRepository.updateEvent(event);
    if (status) {
      return event;
    }
    return null;
  }
}
