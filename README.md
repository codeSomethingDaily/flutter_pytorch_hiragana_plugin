# flutter_pytorch_hiragana

A Flutter plugin to use my ml model that classify japanese hiragana.

The model used for classification is MobileNetV3 Small, obtained from torchvision.models. It is fine-tuned using the ETL-7 Character Database from http://etlcdb.db.aist.go.jp/.

Reference:
Electrotechnical Laboratory, Japanese Technical Committee for Optical Character Recognition, ETL Character Database, 1973-1984.

To prevent crashes in release mode when using a PyTorch-based Flutter plugin, add the following lines to (your flutter project dir)/android/app/build.gradle file:

```gradle
// (your flutter project dir)/android/app/build.gradle
android{
    buildTypes {
        release {
            shrinkResources false
            minifyEnabled false

            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug
        }
    }
}
```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
