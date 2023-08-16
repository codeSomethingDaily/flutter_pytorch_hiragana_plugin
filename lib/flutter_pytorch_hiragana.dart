import 'dart:math';

import 'flutter_pytorch_hiragana_platform_interface.dart';
import 'package:image/image.dart' as img;

class FlutterPytorchUtil {
  static List<double> softmax(List<double> input) {
    final double divisor =
        input.fold(0, (previousValue, element) => previousValue + exp(element));
    return [for (var ele in input) exp(ele) / divisor];
  }

  static int argmax(List<double> input) {
    int res = 0;
    double curMax = double.negativeInfinity;
    int idx = 0;
    for (var ele in input) {
      if (ele > curMax) {
        curMax = ele;
        res = idx;
      }
      idx += 1;
    }
    return res;
  }
}

class FlutterPytorchHiragana {
  static List<String> classes = [
    'あ',
    'い',
    'う',
    'え',
    'お',
    'か',
    'き',
    'く',
    'け',
    'こ',
    'さ',
    'し',
    'す',
    'せ',
    'そ',
    'た',
    'ち',
    'つ',
    'て',
    'と',
    'な',
    'に',
    'ぬ',
    'ね',
    'の',
    'は',
    'ひ',
    'ふ',
    'へ',
    'ほ',
    'ま',
    'み',
    'む',
    'め',
    'も',
    'や',
    'ゆ',
    'よ',
    'ら',
    'り',
    'る',
    'れ',
    'ろ',
    'わ',
    'を',
    'ん',
    '゙',
    '゚'
  ];

  /// call at least once to init the model
  Future<void> initModel() {
    return FlutterPytorchHiraganaPlatform.instance.initModel();
  }

  /// Returns the result of the network directly, which is a linear output layer
  /// use softmax to get the probability based on training method
  Future<List<double>> predict(img.Image image) {
    return FlutterPytorchHiraganaPlatform.instance.predict(image);
  }

  Future<List<double>> predictProbability(img.Image image) async {
    return FlutterPytorchUtil.softmax(await predict(image));
  }

  Future<String> predictHiragana(img.Image image) async {
    final List<double> res = await predict(image);
    final int idx = FlutterPytorchUtil.argmax(res);
    return classes[idx];
  }
}
