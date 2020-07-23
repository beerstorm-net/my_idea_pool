import 'package:my_idea_pool/models/app_user.dart';

import 'app_defaults.dart';
import 'shared_preferences.dart';

class SharedPrefUtils {
  final SharedPref _sharedPref;

  SharedPrefUtils(this._sharedPref);

  // all common read/write goes here

  void prefsSaveUser(AppUser appUser) {
    String key = PREFKEYS[PREFKEY.APP_USER];
    if (appUser == null) {
      _sharedPref.remove(key);
      return;
    }
    //if (_sharedPref.contains(key)) {
    //  _sharedPref.remove(key);
    //}
    _sharedPref.save(key, appUser.toJson());
  }

  AppUser prefsGetUser() {
    String key = PREFKEYS[PREFKEY.APP_USER];
    Map<String, dynamic> data =
        (_sharedPref.contains(key)) ? _sharedPref.read(key) as Map : null;
    return data != null ? AppUser.fromJsonMap(data) : null;
  }

  void prefsDebug(bool enableDebug) {
    String key = PREFKEYS[PREFKEY.SETTINGS_DEBUG];
    if (_sharedPref.contains(key)) {
      _sharedPref.remove(key);
    }
    _sharedPref.save(key, enableDebug.toString());
  }

  bool prefsIsDebug() {
    String key = PREFKEYS[PREFKEY.SETTINGS_DEBUG];
    String enableDebug = (_sharedPref.contains(key))
        ? (_sharedPref.read(key) as String)
        : 'false';
    return (enableDebug == 'true');
  }
}
