import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../shared/common_utils.dart';

appIconImage(
    {double width = 100, double heigth = 200, Color color = Colors.green}) {
  return Image(
    image: AssetImage('assets/images/lightbulb_big.png'),
    width: width,
    height: heigth,
    color: color,
  );
}

appBarLeading() {
  return MaterialButton(
    onPressed: () {},
    color: Colors.white,
    child: appIconImage(width: 24, heigth: 30),
    padding: EdgeInsets.all(8.0),
    shape: CircleBorder(),
  );
}

buildProgressDialog(context, String message,
    {bool isDismissible = false, bool showLogs, Duration autoHide}) {
  ProgressDialog _progressDialog = ProgressDialog(
    context,
    type: ProgressDialogType.Normal,
    isDismissible: isDismissible,
    autoHide: autoHide ?? Duration(seconds: 2),
    showLogs: showLogs ?? CommonUtils.isDebug,
  );
  _progressDialog.style(
    message: message.isNotEmpty ? message : '...',
    messageTextStyle: TextStyle(
        color: Colors.blueGrey, fontSize: 20.0, fontWeight: FontWeight.w600),
    progressWidget: SpinKitPouringHourglass(
      color: Colors.blueGrey,
      //size: 44,
    ),
    progressWidgetAlignment: Alignment.topLeft,
    dialogAlignment: Alignment.topCenter,
  );

  return _progressDialog;
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

// show alert as a dialog
AwesomeDialog _awesomeDialog;
showAlertDialog(context, String message,
    {String type = "INFO", Duration autoHide = const Duration(seconds: 2)}) {
  DialogType dialogType = DialogType.INFO;
  Color textColor = Colors.blueGrey;
  if (type.toUpperCase() == "SUCCESS") {
    dialogType = DialogType.SUCCES;
    textColor = Colors.green;
  } else if (type.toUpperCase() == "WARNING") {
    dialogType = DialogType.WARNING;
    textColor = Colors.deepOrange;
  } else if (type.toUpperCase() == "ERROR") {
    dialogType = DialogType.ERROR;
    textColor = Colors.red;
  }
  _awesomeDialog = AwesomeDialog(
    context: context,
    useRootNavigator: true,
    animType: AnimType.LEFTSLIDE,
    dismissOnTouchOutside: true,
    dismissOnBackKeyPress: true,
    headerAnimationLoop: true,
    dialogType: dialogType,
    body: Container(
      padding: EdgeInsets.all(4.0),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        overflow: TextOverflow.fade,
        maxLines: 4,
        softWrap: true,
      ),
    ),
    btnOk: null,
    btnCancel: null,
    autoHide: autoHide,
  );
  _awesomeDialog.show();
}

theSnackBar(context, String message) {
  return SnackBar(
    duration: Duration(seconds: 2),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 260.0,
          child: Text(
            //AppLocalizations.of(context).translate('soon') + ' ' + message,
            message,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
        Icon(Icons.error),
      ],
    ),
    backgroundColor: Colors.orangeAccent,
  );
}
