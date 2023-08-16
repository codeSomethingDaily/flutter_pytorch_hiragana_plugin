import 'package:image/image.dart' as img;
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_pytorch_hiragana_method_channel.dart';

abstract class FlutterPytorchHiraganaPlatform extends PlatformInterface {
  /// Constructs a FlutterPytorchHiraganaPlatform.
  FlutterPytorchHiraganaPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPytorchHiraganaPlatform _instance =
      MethodChannelFlutterPytorchHiragana();

  /// The default instance of [FlutterPytorchHiraganaPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPytorchHiragana].
  static FlutterPytorchHiraganaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPytorchHiraganaPlatform] when
  /// they register themselves.
  static set instance(FlutterPytorchHiraganaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Future<String?> getPlatformVersion() {
  //   throw UnimplementedError('platformVersion() has not been implemented.');
  // }

  Future<void> initModel() {
    throw UnimplementedError('initModel() has not been implemented.');
  }

  Future<List<double>> predict(img.Image image) {
    throw UnimplementedError('predict() has not been implemented');
  }
}
