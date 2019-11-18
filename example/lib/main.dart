import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:share_mmkv/share_mmkv.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  ShareMmkv _shareMmkv = ShareMmkv();


  Widget _titleSection(
      {@required String title, @required GestureTapCallback tap}) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        height: 50,
        width: double.infinity,
        color: Colors.blue,
        child: Center(child: Text(title)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ShareMmkv Demo'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              _titleSection(
                  title: "set map",
                  tap: () async {
                    bool success = await _shareMmkv
                        .setSameValueMapWithMap({"a": "a---111", "b": "b----1111"}, "string");
                    print("write success = $success");
                  }),
              _titleSection(
                title: "get map with list",
                tap: () async {
                  Map<dynamic, dynamic> map = await _shareMmkv
                      .getSameValueMapWithListKey(["a", "b"], "string");
                  print("flutter = $map");
                },
              ),
              _titleSection(
                  title: "set string",
                  tap: () async {
                    bool success =
                        await _shareMmkv.setString("string", "I'm string");
                    print("write string success = $success");
                  }),
              _titleSection(
                title: "get string",
                tap: () async {
                  final string = await _shareMmkv.getString("string");
                  print("get = $string");
                },
              ),
              _titleSection(
                  title: "set bool",
                  tap: () async {
                    bool success =
                    await _shareMmkv.setBool("bool", false);
                    print("write bool success = $success");
                  }),
              _titleSection(
                title: "get bool",
                tap: () async {
                  final bool = await _shareMmkv.getBool("bool");
                  print("get = $bool");
                },
              ),

              _titleSection(
                  title: "set double",
                  tap: () async {
                    bool success =
                    await _shareMmkv.setDouble("double", 1.21223123);
                    print("write double success = $success");
                  }),
              _titleSection(
                title: "get double",
                tap: () async {
                  final bool = await _shareMmkv.getDouble("double");
                  print("get = $bool");
                },
              ),
              _titleSection(
                  title: "set int",
                  tap: () async {
                    bool success =
                    await _shareMmkv.setInt("int",21223123);
                    print("write int success = $success");
                  }),
              _titleSection(
                title: "get int",
                tap: () async {
                  final bool = await _shareMmkv.getInt("int");
                  print("get = $bool");
                },
              ),
              _titleSection(
                  title: "count",
                  tap: () async {
                    int count =
                    await _shareMmkv.count();
                    print("get count = $count");
                  }),
              _titleSection(
                title: "remove int",
                tap: () async {
                  final bool = await _shareMmkv.remove("int");
                  print("remove  = $bool");
                },
              ),
              _titleSection(
                title: "clear",
                tap: () async {
                  final bool = await _shareMmkv.clear();
                  print("remove  = $bool");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
