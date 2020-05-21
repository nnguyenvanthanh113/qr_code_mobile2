
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcodemobile2/home_page.dart';
import 'package:qrcodemobile2/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(
      seconds: 3
    ),() async {

      //lay email tu SharedPreferences
      final email = await SharedPreferences.getInstance();
      final keyEmail = 'email';
      final valueEmail = email.getString(keyEmail) ?? null;
      print('valueEmail: $valueEmail');

      //lay pass tu SharedPreferences
      final password = await SharedPreferences.getInstance();
      final keyPassword = 'pass';
      final valuePassword = password.getString(keyPassword) ?? null;
      print('valuePassword: $valuePassword');

      if(valueEmail == null && valuePassword == null)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)
            =>LoginPage()
            )
          );
        }
      else
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)
            =>MyHome()
            )
          );
        }



    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 400,
        ),
      ),
    );
  }
}
