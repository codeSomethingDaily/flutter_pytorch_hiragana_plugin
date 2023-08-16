package com.codesomethingdaily.flutter_pytorch_hiragana

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import org.pytorch.Module
import org.pytorch.Tensor
import org.pytorch.torchvision.TensorImageUtils
import org.pytorch.IValue

import android.graphics.Bitmap 
import android.graphics.BitmapFactory 

import android.util.Log

class MPytorchModel{
  private var module: Module? = null

  fun setModule(absPath: String){
    module = Module.load(absPath)
  }


  fun predict(image:  Bitmap):DoubleArray{
    var inputTensor:Tensor = TensorImageUtils.bitmapToFloat32Tensor(
      image,
      TensorImageUtils.TORCHVISION_NORM_MEAN_RGB ,
      TensorImageUtils.TORCHVISION_NORM_STD_RGB 
    )
    var TAG: String = "debug";
    Log.v(TAG,"max:" + inputTensor.getDataAsFloatArray().max().toString() );
    Log.v(TAG,"min:" + inputTensor.getDataAsFloatArray().min().toString() );


    var outTensor: Tensor = module?.forward(
      IValue.from(inputTensor)
    )?.toTensor() ?: throw Exception("not initalized");
    var scores:FloatArray = outTensor.getDataAsFloatArray();
// inputTensor  scores
    return scores.map{ it.toDouble() }.toDoubleArray()
    // return scores;
  }
}

/** FlutterPytorchHiraganaPlugin */
class FlutterPytorchHiraganaPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var mModel : MPytorchModel = MPytorchModel();

  private var TAG: String = "FlutterPytorchHiraganaPlugin";

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_pytorch_hiragana")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method){
      "getPlatformVersion"-> {
        result.notImplemented()
      }
      "initModel" -> {
        var absPath: String? = call.argument("model_path")
        if(absPath != null){
          mModel.setModule(absPath);
          result.success(null);
        }
        else{
          result.error("error","cannot init",null)
        }
      }
      "predict" -> {
        var imgData: ByteArray? = call.argument("image_data")
        var offset: Int? = call.argument("offset")
        var length: Int? = call.argument("length")
        if(imgData!=null && offset!=null && length!=null){
          var bitmap: Bitmap = BitmapFactory.decodeByteArray(imgData,offset,length)
          Log.v("width",bitmap.getWidth().toString())
          Log.v("height",bitmap.getHeight().toString())

          var scores:DoubleArray = mModel.predict(bitmap)
          result.success(scores)
        }
      }
      else ->{
        result.notImplemented()
      }
    }
    // if (call.method == "getPlatformVersion") {
    //   result.success("Android ${android.os.Build.VERSION.RELEASE}")
    // } else {
    //   result.notImplemented()
    // }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
