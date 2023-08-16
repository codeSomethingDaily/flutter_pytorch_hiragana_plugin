import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pytorch_hiragana/flutter_pytorch_hiragana.dart';
import 'package:flutter_pytorch_hiragana/flutter_pytorch_hiragana_platform_interface.dart';
import 'package:flutter_pytorch_hiragana/flutter_pytorch_hiragana_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:image/image.dart' as img;

class MockFlutterPytorchHiraganaPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPytorchHiraganaPlatform {
  // @override
  // Future<String?> getPlatformVersion() => Future.value('42');
  @override
  Future<void> initModel() async {
    return Future.value(null);
  }

  @override
  Future<List<double>> predict(img.Image image) async {
    return Future.value(
        List<double>.generate(48, (index) => Random().nextDouble()));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final FlutterPytorchHiraganaPlatform initialPlatform =
      FlutterPytorchHiraganaPlatform.instance;

  test('$MethodChannelFlutterPytorchHiragana is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelFlutterPytorchHiragana>());
  });

  test('predict', () async {
    FlutterPytorchHiragana flutterPytorchHiraganaPlugin =
        FlutterPytorchHiragana();
    MockFlutterPytorchHiraganaPlatform fakePlatform =
        MockFlutterPytorchHiraganaPlatform();
    FlutterPytorchHiraganaPlatform.instance = fakePlatform;

    ByteData data = await rootBundle
        .load("packages/flutter_pytorch_hiragana/assets/testImg/c.png");
    var image = img.decodePng(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    expect(image, isNotNull);

    final res = await flutterPytorchHiraganaPlugin.predict(image!);
    expect(res.length, 48);
  });
  test('softmax', () {
    // 0.30060961, 0.33222499, 0.3671654 , according to scipy
    List<double> res = FlutterPytorchUtil.softmax([0.1, 0.2, 0.3]);
    debugPrint(res.toString());
    expect(res[0], moreOrLessEquals(0.30060960535572734));
    expect(res[1], moreOrLessEquals(0.3322249935333472));
    expect(res[2], moreOrLessEquals(0.3671654011109255));
  });

  test('argmax', () {
    int res = FlutterPytorchUtil.argmax(
        [0.1, 1.3, 1.31, 1.4, double.nan, double.negativeInfinity, 0.2, 0.3]);
    expect(res, 3);
  });
}
