import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:my_idea_pool/blocs/auth/auth_bloc.dart';
import 'package:my_idea_pool/models/app_user.dart';
import 'package:uuid/uuid.dart';

class CommonUtils {
  // TODO: isDebug is a manual switch, but it must come from isPhysicalDevice
  static final isDebug = true;
  static final Logger logger = Logger(
    level: isDebug ? Level.debug : Level.warning,
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: false, // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ),
  );

  static String nullSafe(String source) {
    return (source == null || source.isEmpty || source == "null") ? "" : source;
  }

  static String generateUuid() {
    var uuid = Uuid();
    return uuid.v5(Uuid.NAMESPACE_URL, 'beerstorm.net');
  }

  static Pattern passwordPattern() {
    final Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])'; //(?=.*?[!@#\$&*~]).{8,}$
    return pattern;
  }

  static String getFormattedDate({DateTime date}) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date ?? DateTime.now());
  }

  static Future<Map<String, dynamic>> parseJsonFromAssets(
      String filePath) async {
    return rootBundle
        .loadString(filePath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  static bool shouldRefreshToken(String dateAt) {
    // API token expires in 10mins, refresh earlier to avoid expiration!
    if (dateAt != null && dateAt.isNotEmpty) {
      Jiffy jiffy = Jiffy(dateAt);
      return (jiffy.diff(DateTime.now(), Units.MINUTE) >= 5);
    }
    return true;
  }

  static void checkRefreshToken(context, AppUser appUser) {
    if (CommonUtils.shouldRefreshToken(appUser?.token_updated_at)) {
      BlocProvider.of<AuthBloc>(context)
          .add(RefreshTokenEvent(appUser: appUser));
    }
    Future.delayed(Duration(seconds: 1));
  }
}
