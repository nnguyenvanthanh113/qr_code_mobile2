
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';

class RichDialog
{

  //Dialog Succes
  static void SuccesDialog(BuildContext context, String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RichAlertDialog( //uses the custom alert dialog
            alertTitle: richTitle(title),
            alertSubtitle: richSubtitle(msg),
            alertType: RichAlertType.SUCCESS,
          );
        }
    );
  }

  //Dialog Error
  static void ErrorDialog(BuildContext context, String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RichAlertDialog( //uses the custom alert dialog
            alertTitle: richTitle(title),
            alertSubtitle: richSubtitle(msg),
            alertType: RichAlertType.ERROR,
          );
        }
    );
  }

  // Dialog warning
  static void WarningDialog(BuildContext context, String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RichAlertDialog( //uses the custom alert dialog
            alertTitle: richTitle(title),
            alertSubtitle: richSubtitle(msg),
            alertType: RichAlertType.WARNING,
          );
        }
    );
  }

}