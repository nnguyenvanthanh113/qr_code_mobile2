import 'package:flutter/material.dart';

import 'Splash.dart';
import 'app.dart';
import 'blocs/auth_bloc.dart';
import 'login_page.dart';

void main() => runApp(MyApp(new AuthBloc(), MaterialApp(

  //home: LoginPage(),
  home: MySplash(),
)));