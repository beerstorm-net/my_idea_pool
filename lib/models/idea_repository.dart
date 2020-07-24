import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/app_idea.dart';
import '../models/user_repository.dart';
import '../shared/app_defaults.dart';
import '../shared/common_utils.dart';
import 'app_user.dart';

class IdeaRepository {
  UserRepository _userRepository;

  IdeaRepository({UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  UserRepository get userRepository => _userRepository;

  Future<List<AppIdea>> loadIdeas({int page = 1}) async {
    String reqUrl = API_BASE + API_IDEAS;
    reqUrl += reqUrl.contains('?') ? "&" : "?";
    reqUrl += "page=" + page.toString();
    AppUser appUser = _userRepository.sharedPrefUtils.prefsGetUser();

    final response =
        await http.get(reqUrl, headers: {API_HEADER_TOKEN: appUser.token});

    List<AppIdea> ideas = List();
    if (response.statusCode <= 201) {
      List<dynamic> responseJson = json.decode(response.body);
      ideas =
          responseJson.map((ideaMap) => AppIdea.fromJsonMap(ideaMap)).toList();
    } else {
      CommonUtils.logger
          .e('API call failed... $reqUrl | ${response.reasonPhrase}');
    }

    return ideas;
  }

  Future<AppIdea> addIdea({@required AppIdea appIdea}) async {
    String reqUrl = API_BASE + API_IDEA_ADD;
    AppUser appUser = _userRepository.sharedPrefUtils.prefsGetUser();

    final response = await http.post(reqUrl,
        headers: {API_HEADER_TOKEN: appUser.token},
        body: appIdea.toRequestJson());

    if (response.statusCode <= 201) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      appIdea.id =
          responseJson.containsKey('id') ? responseJson['id'] as String : null;
      int created_at = responseJson.containsKey('created_at')
          ? responseJson['created_at'] as int
          : null;
      if (created_at != null) {
        appIdea.created_at = CommonUtils.getFormattedDate(
            date: DateTime.fromMillisecondsSinceEpoch(created_at * 1000));
      }
    } else {
      CommonUtils.logger
          .e('API call failed... $reqUrl | ${response.reasonPhrase}');
    }

    return appIdea;
  }

  Future<AppIdea> updateIdea({@required AppIdea appIdea}) async {
    String reqUrl = API_BASE + API_IDEA_UPDATE;
    AppUser appUser = _userRepository.sharedPrefUtils.prefsGetUser();

    if (appIdea.id == null) {
      // TODO: throw exception
      return appIdea;
    }
    reqUrl = reqUrl.replaceAll(":id", appIdea.id);

    final response = await http.put(reqUrl,
        headers: {API_HEADER_TOKEN: appUser.token},
        body: appIdea.toRequestJson());

    if (response.statusCode <= 201) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      CommonUtils.logger.d('updateIdea: $responseJson');
    } else {
      CommonUtils.logger
          .e('API call failed... $reqUrl | ${response.reasonPhrase}');
    }

    return appIdea;
  }

  Future<AppIdea> deleteIdea({@required AppIdea appIdea}) async {
    String reqUrl = API_BASE + API_IDEA_DELETE;
    AppUser appUser = _userRepository.sharedPrefUtils.prefsGetUser();

    if (appIdea.id == null) {
      // TODO: throw exception
      return appIdea;
    }
    reqUrl = reqUrl.replaceAll(":id", appIdea.id);

    final response =
        await http.delete(reqUrl, headers: {API_HEADER_TOKEN: appUser.token});

    if (response.statusCode <= 204) {
      //Map<String, dynamic> responseJson = json.decode(response.body);
      CommonUtils.logger.d('OK deleteIdea: ${appIdea.id}');
    } else {
      CommonUtils.logger
          .e('API call failed... $reqUrl | ${response.reasonPhrase}');
    }

    return appIdea;
  }
}
