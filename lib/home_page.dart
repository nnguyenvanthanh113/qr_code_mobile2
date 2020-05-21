
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:qrcodemobile2/dialog/rich_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'ListScaner.dart';
import 'dialog/loading_dialog.dart';
import 'dialog/msg_dialog.dart';
import 'helper/DatabaseHelper.dart';
import 'model/ListQR.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  //static const code_app = '4619';
  GlobalKey globalKey = GlobalKey();
  var qrText = "";
  QRViewController controller;
  String checkQR = '';
  String StaffName = '';

  //audio
  AudioPlayer audioPlugin = AudioPlayer();
  String mp3Uri1;
  String mp3Uri2;


  //arraylist
  List<ListQR> listqr = new List();

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  ListQR todo;

  @override
  void initState() {

    //audio
    _load2();
    _load1();


    //check internet

  }





  //audio
  Future<Null> _load1() async {
    final ByteData data1 = await rootBundle.load('assets/beep2.mp3');
    Directory tempDir1 = await getTemporaryDirectory();
    File tempFile1 = File('${tempDir1.path}/beep2.mp3');
    //File tempFile = File('assets/beep.mp3');
    await tempFile1.writeAsBytes(data1.buffer.asUint8List(), flush: true);
    mp3Uri1 = tempFile1.uri.toString();
    print('finished loading 1, uri=$mp3Uri1');
  }
  Future<Null> _load2() async {
    final ByteData data2 = await rootBundle.load('assets/beeplong.mp3');
    Directory tempDir2 = await getTemporaryDirectory();
    File tempFile2 = File('${tempDir2.path}/beeplong.mp3');
    await tempFile2.writeAsBytes(data2.buffer.asUint8List(), flush: true);
    mp3Uri2 = tempFile2.uri.toString();
    print('finished loading 2, uri=$mp3Uri2');
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Column(children: <Widget>[
      Expanded(
        flex: 4,
        child: QRView(key: globalKey,
            overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Colors.red,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250
            ),
            onQRViewCreated: _onQRViewCreate),
      ),
      Expanded(
        flex: 1,
        child: Center(child: Text("$qrText"),),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Text('->'),
          //onPressed: showNotification,
          onPressed: (){

            //add tam thoi
           // _addTamThoi();

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListScaner()));
          },
        ),
      ),
    ],)

      ,);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState(() {
        qrText = scanData;
        if(qrText != "")
          {
            if(qrText != checkQR)
              {
                checkQR = qrText;

                _checkInternetConnectivity();

              }
            else
              {
                //MsgDialog.showMsgDialog(context, "mã này đã check !","");
                print("đã check QR này !!");
              }

          }
      });
    });
  }



  //check Internet
  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none)
    {
      //MsgDialog.showMsgDialog(context, "No internet","You're not connected to a network !");

      //lay ngay hien tai
      var now = new DateTime.now();
      String DateNow = ('${now.year}-${now.month}-${now.day}');

      //lay time hien tai
      String TimeNow = ('${now.hour}:${now.minute}');


        //luu sqllite
      todo = new ListQR(qrText, DateNow, TimeNow);


      int result;

        result = await helper.insertTodo(todo);
        print("số row đã thêm vào sqlLite :" + result.toString());

      listqr = await helper.getTodoList();
      for(int i = 0; i < listqr.length;i++)
        {
          print("result qr code:" + listqr[i].qrcode);
          print("result Date:" + listqr[i].Date);
          print("result Time:" + listqr[i].Time);
        }


      if (result != 0) {  // Success
        //MsgDialog.showMsgDialog(context, "Không có kết nối Internet !","Đã lưu tạm thời....");
        RichDialog.WarningDialog(context, "Không có kết nối Internet !","Đã lưu tạm thời....");
      } else {  // Failure
        //MsgDialog.showMsgDialog(context, "Không lưu được tạm thời....","");
        RichDialog.ErrorDialog(context, "Không lưu được tạm thời....","");
      }

    }
    else if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi)
    {
      //MsgDialog.showMsgDialog(context, "internet areadly !","");
      //lay ten NV ứng với mã qr
      GetStaffName(checkQR);


      Timer(Duration(seconds: 1), () {
        //post data lên kintone
        makePostRequest();
      });

    }

  }



  //lay StaffName
  Future<void> GetStaffName(String checkQR) async{

    //lay ma code_app
    final prefsCode_app = await SharedPreferences.getInstance();
    final Code_app = prefsCode_app.getString('app') ?? 0;
    print('read: $Code_app');

    String url = "https://kintoneivsdemo.cybozu.com/k/v1/records.json?app=" + Code_app + "&query=staffCode=" + "\"" + checkQR + "\"" ;
    //String url = "https://kintoneivsdemo.cybozu.com/k/v1/app.json?id=" + checkQR;
    //https://kintoneivsdemo.cybozu.com/k/v1/records.json?app=4616&query=staffCode="IVS-0633"
    var response = await http.get(
      //encode the url
        Uri.encodeFull(url),
        //only accept json response
        headers: {"X-Cybozu-Authorization" : "cHR0aHVAaW5kaXZpc3lzLmpwOnB0dGh1MTIzNA=="}
    );
    print(url);
    print(response.body);
    setState(() {

      var converDataToJson = json.decode(response.body);
      StaffName = converDataToJson['records'][0]['staffName']['value'];
      final int statusCode = response.statusCode;
      if (statusCode == 200)
      {
          print('StaffName :' + StaffName);
      }
      else
        print('StaffName :' + 'ko lay dc');
    });

  }

  //post data
  Future<void> makePostRequest() async {
    // set up POST request arguments
    String url = 'https://kintoneivsdemo.cybozu.com/k/v1/records.json';
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
       "X-Cybozu-Authorization" : "cHR0aHVAaW5kaXZpc3lzLmpwOnB0dGh1MTIzNA==",
    };

    //lay email tu SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final key = 'email';
    final value = prefs.getString(key) ?? 0;
    print('read: $value');

    //lay ngay hien tai
    var now = new DateTime.now();
    String DateNow = ('${now.year}-${now.month}-${now.day}');

    //lay time hien tai
    String TimeNow = ('${now.hour}:${now.minute}');

    //lay ma code_app
    final prefsCode_app = await SharedPreferences.getInstance();
    final Code_app = prefsCode_app.getString('app') ?? 0;
    print('read: $Code_app');



    String json = '{"app" : "'+ Code_app +'","records" : [{"driverCode" : {"value" : "'+ value +'"},"staffCode" : {"value" : "' + qrText + '"},"date" : {"value" : "'+ DateNow +'"},"timeIn" : {"value" : "'+ TimeNow +'"}}]}';
    //String json = '{"app" : "4619","records" : [{"driverCode" : {"value" : "'+ value +'"},"staffCode" : {"value" : "' + qrText + '"},"date" : {"value" : "2020-05-13"},"timeIn" : {"value" : "14:45"}}]}';
    // make POST request
    print("URL : " + json);
    print(qrText);

    LoadingDialog.showLoadingDialog(context, "Đang tải....");
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
//    String body = response.body;
//    print(body);



    if(statusCode == 200 || statusCode == 201)
      {
        String body = response.body;
        print(body);
        print("thành công !");
        LoadingDialog.hideLoadingDialog(context);

        //audio
        //_load();
        audioPlugin.play(mp3Uri1, isLocal: true);

        //hien Dialog
        //MsgDialog.showMsgDialog(context, "gởi thành công !",'$qrText : $StaffName');
        RichDialog.SuccesDialog(context, "gởi thành công !",'$qrText : $StaffName');
        //showNotification;
      }
    else
      {
        print("không thành công !");
        LoadingDialog.hideLoadingDialog(context);

        //audio
        //_load2();
        audioPlugin.play(mp3Uri2, isLocal: true);

        //hien Dialog
        //MsgDialog.showMsgDialog(context, "gởi thất bại !","...");
        RichDialog.ErrorDialog(context, "gởi thất bại !","...");
      }

  }



}
