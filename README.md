# flutter_pytorch_hiragana

A Flutter plugin to use my ml model that classify japanese hiragana.

The model used for classification is MobileNetV3 Small, obtained from torchvision.models. It is fine-tuned using the ETL-7 Character Database from http://etlcdb.db.aist.go.jp/.

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

## Reference:

```
@misc{howard2019searching,
      title={Searching for MobileNetV3},
      author={Andrew Howard and Mark Sandler and Grace Chu and Liang-Chieh Chen and Bo Chen and Mingxing Tan and Weijun Wang and Yukun Zhu and Ruoming Pang and Vijay Vasudevan and Quoc V. Le and Hartwig Adam},
      year={2019},
      eprint={1905.02244},
      archivePrefix={arXiv},
      primaryClass={cs.CV}
}
```

- Electrotechnical Laboratory, Japanese Technical Committee for Optical Character Recognition, ETL Character Database, 1973-1984.
