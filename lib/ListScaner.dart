import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qrcodemobile2/dialog/rich_dialog.dart';
import 'package:qrcodemobile2/model/ListQR.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'dialog/loading_dialog.dart';
import 'dialog/msg_dialog.dart';
import 'helper/DatabaseHelper.dart';

class ListScaner extends StatefulWidget {
  @override
  _ListScanerState createState() => _ListScanerState();
}

class _ListScanerState extends State<ListScaner> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ListQR> todoList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<ListQR>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đã lưu'),
      ),
      body: getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');

          // post data to server and delete all sqllit qr_code
          postDataDeleteAll();
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }

  //delete all slqlite
  void postDataDeleteAll() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none)
      {
        //MsgDialog.showMsgDialog(context, "Chưa kết nối Internet!","");
        RichDialog.WarningDialog(context, "Chưa kết nối Internet!","");
      }
    else if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi)
      {
        //post data to kintone
        //// set up POST request arguments
        String url = 'https://kintoneivsdemo.cybozu.com/k/v1/records.json';
        Map<String, String> headers = {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          "X-Cybozu-Authorization" : "cHR0aHVAaW5kaXZpc3lzLmpwOnB0dGh1MTIzNA==",
        };
        //lay email tu SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final key = 'email';
        final DriverName = prefs.getString(key) ?? 0;
        print('read: $DriverName');

        //lay Code_app
        final prefsCode_app = await SharedPreferences.getInstance();
        final Code_app = prefsCode_app.getString('app') ?? 0;
        print('read: $Code_app');


        if(todoList.length != 0)
        {
          LoadingDialog.showLoadingDialog(context, "Đang tải....");
          //List<ListQR> list;
          for(int i=0; i<todoList.length;i++)
          {
            String json = '{"app" : "'+ Code_app +'","records" : [{"driverCode" : {"value" : "'+ DriverName +'"},"staffCode" : {"value" : "' + todoList[i].qr_code + '"},"date" : {"value" : "'+ todoList[i].Date +'"},"timeIn" : {"value" : "'+ todoList[i].Time +'"}}]}';
            print("URL : " + json);

            Response response = await post(url, headers: headers, body: json);
            int statusCode = response.statusCode;
            if(statusCode == 200)
            {
              //delete id data was post kintone
              int result = await databaseHelper.deleteTodo(todoList[i].id);
              print("delteID : " + todoList[i].id.toString());

            }
//            else
//              {
//                MsgDialog.showMsgDialog(context, "gởi thất bại !",todoList[i].qr_code);
//              }
          }
          LoadingDialog.hideLoadingDialog(context);
          updateListView();

        }
      }


  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.todoList[position].qr_code),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.todoList[position].qrcode,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.todoList[position].Time + " " + this.todoList[position].Date),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, todoList[position]);
                  },
                ),
              ],
            ),
//            onTap: () {
//              debugPrint("ListTile Tapped");
//              navigateToDetail(this.todoList[position], 'Edit Todo');
//            },
          ),
        );
      },
    );
  }

  //láy 2 string add image
  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  //delete QR with id
  void _delete(BuildContext context, ListQR todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      //MsgDialog.showMsgDialog(context, "Đã xóa !","");
      RichDialog.SuccesDialog(context, "Đã xóa !","");
      updateListView();
    }
  }

  //update lại ListView
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ListQR>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }

}
