
import 'package:flutter/cupertino.dart';

import 'blocs/auth_bloc.dart';

class MyApp extends InheritedWidget {

  final AuthBloc authBloc;
  final Widget child;
  MyApp(this.authBloc,this.child):super(child:child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static MyApp of(BuildContext context){
    return context.inheritFromWidgetOfExactType(MyApp);
  }
}