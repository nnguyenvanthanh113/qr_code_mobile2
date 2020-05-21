import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:qrcodemobile2/dialog/rich_dialog.dart';
import 'package:qrcodemobile2/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'blocs/auth_bloc.dart';
import 'dialog/loading_dialog.dart';
import 'dialog/msg_dialog.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthBloc authBloc = new AuthBloc();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  //TextEditingController _appController = new TextEditingController();
  List data;
  static const code_app = '4619';

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Image.asset('qrcode.png'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 6),
                child: Text(
                  "Quét Mã QR",
                  style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                ),
              ),
              Text(
                "App dành cho Tài Xế ",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 20),
                  child: StreamBuilder(
                    stream: authBloc.emailStream,
                    builder: (context,snapshot)=>TextField(
                      controller: _emailController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                        errorText:
                        snapshot.hasError ? snapshot.error : null,
                        labelText: "Mã tài xế",
                          prefixIcon: Container(
                              width: 50, child: Image.asset("ic_mail.png")),
                          border: OutlineInputBorder(
                              borderSide:
                                BorderSide(color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(6)))),
                      ),
                    ),
                  ),
              StreamBuilder(
                  stream: authBloc.passStream,
                  builder: (context, snapshot) => TextField(
                    controller: _passController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        errorText:
                        snapshot.hasError ? snapshot.error : null,
                        prefixIcon: Container(
                            width: 50, child: Image.asset("ic_phone.png")),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  )),
//              Padding(
//                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
//                child: StreamBuilder(
//                    stream: authBloc.appStream,
//                    builder: (context, snapshot) => TextField(
//                      controller: _appController,
//                      style: TextStyle(fontSize: 18, color: Colors.black),
//                      decoration: InputDecoration(
//                          labelText: "code-app",
//                          errorText:
//                          snapshot.hasError ? snapshot.error : null,
//                          prefixIcon: Container(
//                              width: 10, child: Image.asset("iconqr_code.PNG")),
//                          border: OutlineInputBorder(
//                              borderSide: BorderSide(
//                                  color: Color(0xffCED0D2), width: 1),
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(6)))),
//                    )),
//              ),
              Container(
                constraints: BoxConstraints.loose(Size(double.infinity, 40)),
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 10, 1),
                  child: Text(
                    "Quên mật khẩu ?",
                    style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    onPressed: _onloginClick,
                    child: Text(
                      "ĐĂNG NHẬP",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onloginClick(){

    var isValid = authBloc.isValid(_emailController.text,
        _passController.text);
    if(isValid == true)
      {
        LoadingDialog.showLoadingDialog(context, "Đang tải....");
        //CheckLogin();
        _CheckCodeApp();


      }

  }

  //check code app
  _CheckCodeApp() async{

    String url = "https://kintoneivsdemo.cybozu.com/k/v1/app.json?id=" + code_app;

    var response = await http.get(
      //encode the url
        Uri.encodeFull(url),
        //only accept json response
        headers: {"X-Cybozu-Authorization" : "cHR0aHVAaW5kaXZpc3lzLmpwOnB0dGh1MTIzNA=="}
    );
    print(url);
    print(response.body);
    setState(() {
      String code = '';
      var converDataToJson = json.decode(response.body);
      code = converDataToJson['code'];
      print("code" + code);
      print(code_app);
      final int statusCode = response.statusCode;
      if (statusCode == 200)
      {
        if(code == '')
          {
            _CheckLogin();
          }
        else
          {
            LoadingDialog.hideLoadingDialog(context);
            //MsgDialog.showMsgDialog(context, "Đăng nhập","Code app không đúng");
            RichDialog.ErrorDialog(context, "Đăng nhập","Code app không đúng");

          }
      }
      else
      {
        LoadingDialog.hideLoadingDialog(context);
        //MsgDialog.showMsgDialog(context, "Đăng nhập","Code app không đúng");
        RichDialog.ErrorDialog(context, "Đăng nhập","Code app không đúng");

      }
    });

  }

  //check email va password
  //Future<String> CheckLogin() async{
  _CheckLogin() async{
    String url = "https://kintoneivsdemo.cybozu.com/k/v1/records.json?app=4615&query="
        + "driverCode=" + "\"" + _emailController.text + "\""
        + " and password=" + "\"" + _passController.text + "\"";
    var response = await http.get(
      //encode the url
      Uri.encodeFull(url),
      //only accept json response
      headers: {"X-Cybozu-API-Token" : "6SnXAq3rlwqiSPjSzi3NryvvaYI8jDH0OL3YEEg4"}
    );

    print(url);
    print(response.body);

    setState(() async {
      var converDataToJson = json.decode(response.body);
      data = converDataToJson['records'];
      print("data" + data.toString());
      final int statusCode = response.statusCode;
            if (statusCode == 200 || statusCode == 201)
            {
              if(data.length > 0)
                {
                  LoadingDialog.hideLoadingDialog(context);
                  print("thành công !");

                  //luu email, pass, code_app  vao SharedPreferences
                      final prefsEmail = await SharedPreferences.getInstance(); //email
                      final valueEmail = _emailController.text;
                      prefsEmail.setString('email', valueEmail);
                      print('saved $valueEmail');

                      final prefsPass = await SharedPreferences.getInstance(); // password
                      final valuePass = _passController.text;
                      prefsPass.setString('pass', valuePass);
                      print('saved $valuePass');

                      final prefsCode_app = await SharedPreferences.getInstance();//code_app
                      final valueCode_app = code_app;
                      prefsCode_app.setString('app', valueCode_app);
                      print('saved $valueCode_app');


                  //chuyen sang man hinh Home
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyHome(),
                  ));
                }
              if(data.length <= 0 )
                {
                  LoadingDialog.hideLoadingDialog(context);
                  //MsgDialog.showMsgDialog(context, "Đăng nhập","Kiểm tra lại Mã tài xế  và Mật khẩu");
                  RichDialog.ErrorDialog(context, "Đăng nhập","Kiểm tra lại Mã tài xế  và Mật khẩu");
                  //MsgDialog.showMsgDialog(context, "Sign-In Error",response.body);

                  print("không thành công !");
                }

            }
            else
            {
                //MsgDialog.showMsgDialog(context, "Lỗi đăng nhập ","!");
                RichDialog.ErrorDialog(context, "Đăng nhập","Kiểm tra lại Mã tài xế  và Mật khẩu");
                LoadingDialog.hideLoadingDialog(context);
            }
    });
  }

}