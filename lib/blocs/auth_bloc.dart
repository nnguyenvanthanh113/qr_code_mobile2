
import 'dart:async';

class AuthBloc{

  StreamController _emailController = new StreamController();
  StreamController _passController = new StreamController();
  //StreamController _appController = new StreamController();


  Stream get emailStream => _emailController.stream;
  Stream get passStream => _passController.stream;
  //Stream get appStream => _appController.stream;


  bool isValid(String email, String pass) {
    if (email == null || email.length == 0) {
      _emailController.sink.addError("Nhập mã tài xế");
      return false;
    }
    _emailController.sink.add("");

//    if (app == null || app.length == 0) {
//      _appController.sink.addError("Nhập code_app");
//      return false;
//    }
//    _appController.sink.add("");

    if (pass == null || pass.length < 6) {
      _passController.sink.addError("Mật khẩu phải trên 5 ký tự");
      return false;
    }
    _passController.sink.add("");

    return true;
  }




  void dispose() {
    _emailController.close();
    _passController.close();
  }
}