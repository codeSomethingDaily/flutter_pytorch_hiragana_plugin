import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pytorch_hiragana/flutter_pytorch_hiragana_method_channel.dart';

import 'package:image/image.dart' as img;

void main() {
  MethodChannelFlutterPytorchHiragana platform =
      MethodChannelFlutterPytorchHiragana();
  const MethodChannel channel = MethodChannel('flutter_pytorch_hiragana');

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      // return '42';
      if (methodCall.method == "initModel") {
        return null;
      }
      if (methodCall.method == "predict") {
        return List<double>.generate(48, (index) => Random().nextDouble());
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('predict', () async {
    ByteData data = await rootBundle
        .load("packages/flutter_pytorch_hiragana/assets/testImg/c.png");
    var image = img.decodePng(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    expect(image, isNotNull);
    List<double> res = await platform.predict(image!);
    expect(res.length, 48);
  });
}
