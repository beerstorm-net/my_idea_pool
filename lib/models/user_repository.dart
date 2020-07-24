import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../shared/app_defaults.dart';
import '../shared/common_utils.dart';
import '../shared/shared_preferences.dart';
import '../shared/shared_preferences_utils.dart';
import 'app_user.dart';

class UserRepository {
  final SharedPref _sharedPref;
  final SharedPrefUtils _sharedPrefUtils;
  static initSharedPrefUtils(sharedPref) => SharedPrefUtils(sharedPref);
  UserRepository({SharedPref sharedPref})
      : _sharedPref = sharedPref ?? new SharedPref(),
        _sharedPrefUtils = initSharedPrefUtils(sharedPref);

  SharedPref get sharedPref => _sharedPref;
  SharedPrefUtils get sharedPrefUtils => _sharedPrefUtils;

  Future<AppUser> signupUser({@required AppUser appUser}) async {
    String reqUrl = API_BASE + API_SIGNUP;

    final response = await http.post(reqUrl, body: {
      "email": appUser.email.toLowerCase(),
      "name": appUser.name,
      "password": appUser.password,
    });
    if (response.statusCode <= 201) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      appUser.token = responseJson.containsKey('jwt')
          ? responseJson['jwt'] as String
          : null;
      appUser.refresh_token = responseJson.containsKey('refresh_token')
          ? responseJson['refresh_token'] as String
          : null;

      if (appUser.token != null) {
        appUser.updated_at = CommonUtils.getFormattedDate();
        appUser.token_updated_at = CommonUtils.getFormattedDate();
      }
    } else {
      CommonUtils.logger
          .e('API call failed... $reqUrl | ${response.reasonPhrase}');
      appUser.token = null;
    }
    return appUser;
  }

  Future<AppUser> loginUser({@required AppUser appUser}) async {
    String reqUrl = API_BASE + API_LOGIN;

    // headers: {
    //      'Content-Type': 'application/json',
    //    },
    final response = await http.post(reqUrl, body: {
      "email": appUser.email.toLowerCase(),
      "password": appUser.password,
    });
    if (response.statusCode <= 201) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      appUser.token = responseJson.containsKey('jwt')
          ? responseJson['jwt'] as String
          : null;
      appUser.refresh_token = responseJson.containsKey('refresh_token')
          ? responseJson['refresh_token'] as String
          : null;

      if (appUser.token != null) {
        appUser.updated_at = CommonUtils.getFormattedDate();
        appUser.token_updated_at = CommonUtils.getFormattedDate();
      }
    } else {
      CommonUtils.logger
          .e('API call failed... $reqUrl | ${response.reasonPhrase}');
      appUser.token = null;
    }
    return appUser;
  }

  Future<AppUser> refreshToken({@required AppUser appUser}) async {
    String reqUrl = API_BASE + API_REFRESH_TOKEN;

    final response = await http.post(reqUrl, body: {
      "refresh_token": appUser.refresh_token,
    });
    if (response.statusCode <= 201) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      appUser.token = responseJson.containsKey('jwt')
          ? responseJson['jwt'] as String
          : null;

      if (appUser.token != null) {
        appUser.updated_at = CommonUtils.getFormattedDate();
        appUser.token_updated_at = CommonUtils.getFormattedDate();
      }
    } else {
      CommonUtils.logger
          .e('API call failed... $reqUrl | ${response.reasonPhrase}');
      appUser.token = null;
    }
    return appUser;
  }

  Future<AppUser> logoutUser({@required AppUser appUser}) async {
    String reqUrl = API_BASE + API_LOGOUT;

    final response = await http.delete(reqUrl, headers: {
      API_HEADER_TOKEN: appUser.token,
    });
    if (response.statusCode <= 204) {
      appUser.token = null;
      appUser.refresh_token = null;
      //appUser.updated_at = CommonUtils.getFormattedDate();
      //appUser.token_updated_at = CommonUtils.getFormattedDate();
    } else {
      CommonUtils.logger
          .e('API call failed... $reqUrl | ${response.reasonPhrase}');
      appUser.token = null;
    }
    return appUser;
  }

  Future<AppUser> currentUser({@required AppUser appUser}) async {
    String reqUrl = API_BASE + API_CURRENT_USER;

    final response =
        await http.get(reqUrl, headers: {API_HEADER_TOKEN: appUser.token});
    if (response.statusCode <= 201) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      appUser.name = responseJson.containsKey('name')
          ? responseJson['name'] as String
          : null;
      appUser.avatar_url = responseJson.containsKey('avatar_url')
          ? responseJson['avatar_url'] as String
          : null;
      appUser.updated_at = CommonUtils.getFormattedDate();
    } else {
      CommonUtils.logger
          .e('API call failed... $reqUrl | ${response.reasonPhrase}');
    }
    return appUser;
  }
}
