import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'flutter_pytorch_hiragana_platform_interface.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as img;

/// An implementation of [FlutterPytorchHiraganaPlatform] that uses method channels.
class MethodChannelFlutterPytorchHiragana
    extends FlutterPytorchHiraganaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_pytorch_hiragana');

  // @override
  // Future<String?> getPlatformVersion() async {
  //   final version =
  //       await methodChannel.invokeMethod<String>('getPlatformVersion');
  //   return version;
  // }

  @override
  Future<void> initModel() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String path = appDocDir.path;
    final String modelPath = join(path, "model.pt");
    final ByteData data = await rootBundle.load(
        "packages/flutter_pytorch_hiragana/assets/model/trained_model.pt");
    if (File(modelPath).existsSync()) {
      File(modelPath).deleteSync();
    }
    if (!File(modelPath).existsSync()) {
      await File(modelPath).writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    }
    await methodChannel.invokeMethod('initModel', {"model_path": modelPath});
  }

  @override
  Future<List<double>> predict(img.Image image) async {
    if (image.width != 224 || image.width != 224) {
      image = img.copyResize(image, width: 224, height: 224);
    }
    debugPrint("width: ${image.width} height: ${image.height}");
    final encodedBmp = img.encodeBmp(image);
    var res = await methodChannel.invokeListMethod<double>('predict', {
      'image_data': encodedBmp,
      'offset': encodedBmp.offsetInBytes,
      'length': encodedBmp.lengthInBytes
    });
    if (res == null) {
      throw Exception();
    }
    return res;
  }
}
