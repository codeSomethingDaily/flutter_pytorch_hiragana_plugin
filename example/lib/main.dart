import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_pytorch_hiragana/flutter_pytorch_hiragana.dart';

import 'package:image/image.dart' as img;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterPytorchHiragana().initModel();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterPytorchHiraganaPlugin = FlutterPytorchHiragana();
  String s = "";

  @override
  void initState() {
    super.initState();
  }

  void onButtonPressed() async {
    // final Byte[] bytes
    ByteData data = await rootBundle
        .load("packages/flutter_pytorch_hiragana/assets/testImg/d.png");
    var image = img.decodePng(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    if (image != null) {
      var res = await _flutterPytorchHiraganaPlugin.predict(image);
      debugPrint(res.toString());

      var japanese = await _flutterPytorchHiraganaPlugin.predictHiragana(image);
      if (mounted) {
        setState(() {
          s = japanese;
        });
      }
    }
    // Image img =
    // AssetImage("packages/flutter_pytorch_hiragana/assets/testImg/a.png");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              // Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                  onPressed: onButtonPressed, child: const Text("test")),
              Text(s)
            ],
          ),
        ),
      ),
    );
  }
}
