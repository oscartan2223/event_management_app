import 'dart:io';

import 'package:assignment/models/profile_model.dart';
import 'package:assignment/models/request_model.dart';
import 'package:assignment/providers/file_provider.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/repositories/request_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestProvider extends ChangeNotifier {
  final RequestRepository _requestRepostiory = RequestRepository();

  List<BaseRequestModel> _requestList = [];

  List<BaseRequestModel> get requests => _requestList;

  Future<void> getRequests() async {
    _requestRepostiory.getAllRequests().listen((snapshot) {
      _requestList = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        String type = data['type'];
        switch (type) {
          case 'Report User':
            return ReportModel.fromMap(doc.id, data);
          case 'Feedback':
          case 'Organizer Role Request':
            return RequestModel.fromMap(doc.id, data);
          default:
            throw Exception('Unknown request type');
        }
      }).toList();
      notifyListeners();
    });
  }

  Future<void> getPersonalRequests(String personalEmail) async {
    QuerySnapshot<Map<String, dynamic>>? querySnapshot =
        await _requestRepostiory.getPersonalRequests(personalEmail);
    if (querySnapshot != null) {
      _requestList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        String type = data['type'];
        switch (type) {
          case 'Report User':
            return ReportModel.fromMap(doc.id, data);
          case 'Feedback':
          case 'Organizer Role Request':
            return RequestModel.fromMap(doc.id, data);
          default:
            throw Exception('Unknown request type');
        }
      }).toList();
      notifyListeners();
    }
  }

  Future<bool> makeRequest(
      BaseRequestModel request, Map<String, File> supportingDocuments) async {
    String id = await _requestRepostiory.addRequest(request);

    Map<String, String> supportingDocs = {};

    if (supportingDocuments.isNotEmpty) {
      for (String fileName in supportingDocuments.keys) {
        String? link = await FileProvider.uploadSupportingDoc(
            supportingDocuments[fileName]!, id, fileName);
        if (link != null) {
          supportingDocs[fileName] = link;
        }
      }
    }

    if (id != '') {
      return await _requestRepostiory.updateRequest(
          request.copyWith(id: id, supportingDocs: supportingDocs));
    }
    return false;
  }

  Future<bool> updateRequest(BaseRequestModel request) async {
    return await _requestRepostiory.updateRequest(request);
  }

  Future<bool> updateStatus(BaseRequestModel request, String status) async {
    request = request.copyWith(status: status);
    notifyListeners();
    return await _requestRepostiory.updateRequest(request);
  }

  BaseRequestModel getRequest(String id) {
    return _requestList.firstWhere((request) => request.id == id);
  }

  Future<bool> approveEventOrganizerRoleRequest(
      BaseRequestModel request) async {
    bool status1 = await _requestRepostiory.updateRequest(request);
    ProfileModel profile =
        await ProfileProvider().getOthersProfile(request.userEmail);
    bool status2 = await ProfileProvider()
        .updateProfile(profile.copyWith(type: UserType.organizer));
    return status1 && status2;
  }

}
