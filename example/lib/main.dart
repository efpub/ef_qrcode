import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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

  Uint8List _QRCodeBytes;
  bool isSelectWatermark = false;
  String message = '';
  final contentController = TextEditingController();
  final backgroundColorController = TextEditingController();
  final foregroundColorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contentController.addListener(_printContentValue);
    backgroundColorController.addListener(_printBackgroundColorValue);
    foregroundColorController.addListener(_printForegroundColorValue);
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

  _printBackgroundColorValue() {
    print("BackgroundColor: ${backgroundColorController.text}");
  }

  _printForegroundColorValue() {
    print("ForegroundColor: ${foregroundColorController.text}");
  }

  void generateImage() async {
    try {
      ByteData bytes = await rootBundle.load('assets/images/宠物星球.png');
      var resultBytes = await EfQrcode.generate(
          content: contentController.text,
          backgroundColor: backgroundColorController.text,
          foregroundColor: foregroundColorController.text,
          watermark: isSelectWatermark ? bytes.buffer.asUint8List() : null
      );
      setState(() {
        _QRCodeBytes = resultBytes;
      });
    }
    catch (e) {
      print(e);
    }
  }


  Widget _buildImage() {
    if (_QRCodeBytes != null) {
      return Image.memory(_QRCodeBytes);
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
              // checkbox
              new CheckboxListTile(
                value: this.isSelectWatermark,
                title: Text('use watermark'),
                activeColor: Colors.blue,
                onChanged: (bool val) {
                  // val 是布尔值
                  this.setState(() {
                    this.isSelectWatermark = !this.isSelectWatermark;
                  });
                },
              ),
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
