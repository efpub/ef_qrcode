import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ef_qrcode/ef_qrcode.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget buildTextField(TextEditingController controller, String placeholder) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(fillColor: Colors.blue.shade100, filled: true, labelText: placeholder),//占位符
    );
  }

  File _imageFile;
  String message = '';
  final contentController = TextEditingController();
  final backgroundColorController = TextEditingController();
  final foregroundColorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contentController.addListener(_printContentValue);
    backgroundColorController.addListener(_printbackgroundColorValue);
    foregroundColorController.addListener(_printforegroundColorValue);
  }

  @override
  void dispose() {
    contentController.dispose();
    backgroundColorController.dispose();
    foregroundColorController.dispose();
    super.dispose();
  }

  _printContentValue() {
    print("Content: ${contentController.text}");
  }

  _printbackgroundColorValue() {
    print("BackgroundColor: ${backgroundColorController.text}");
  }

  _printforegroundColorValue() {
    print("ForegroundColor: ${foregroundColorController.text}");
  }

  void generateImage() async {
    try {
      var imageFile = await EfQrcode.generate(contentController.text, backgroundColorController.text, foregroundColorController.text);
      setState(() {
        _imageFile = imageFile;
      });
    }
    catch (e) {
      print(e);
    }
  }


  Widget _buildImage() {
    if (_imageFile != null) {
      return new Image.file(_imageFile);
    } else {
      return new Text('Generate an image to start', style: new TextStyle(fontSize: 18.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        title: Text('ef_qrcode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            buildTextField(contentController, 'Content'),
            buildTextField(backgroundColorController, 'BackgroundColor'),
            buildTextField(foregroundColorController, 'ForegroundColor'),
            /*
            new RaisedButton(onPressed: getPermissionsStatus,//() => acquireStoragePermissions(),
              child: new Text("status"),
              color: Colors.red,
            ),*/
            new RaisedButton(onPressed: () => generateImage(),
              child: new Text("generate"),
              color: Colors.blue,
            ),
            new Expanded(child: new Center(child: _buildImage())),
          ],
        ),
      ),
      ),
    );
  }
}
