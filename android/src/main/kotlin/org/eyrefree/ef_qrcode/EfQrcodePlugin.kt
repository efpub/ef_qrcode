package org.eyrefree.ef_qrcode

import android.content.ContentValues.TAG
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.github.sumimakito.awesomeqr.AwesomeQRCode

import android.graphics.Bitmap
import android.graphics.Color
import android.net.Uri
import android.os.Environment
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream
import kotlin.math.absoluteValue

class EfQrcodePlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "ef_qrcode")
      channel.setMethodCallHandler(EfQrcodePlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "generate") {
      var content = "NULL"
      val size: Int = 1024
      var backgroundColor = Color.WHITE
      var foregroundColor = Color.BLACK
      try {
        val contentStr = call.argument<String>("content")!!
        if (contentStr != "") {
          content = contentStr
        }
      } catch (e: Exception) { // Catch the exception
        e.printStackTrace()
      }
      try {
        val backgroundColorStr = call.argument<String>("backgroundColor")!!
        backgroundColor = Color.parseColor(backgroundColorStr)
      } catch (e: Exception) { // Catch the exception
        e.printStackTrace()
      }
      try {
        val foregroundColorStr = call.argument<String>("foregroundColor")!!
        foregroundColor = Color.parseColor(foregroundColorStr)
      } catch (e: Exception) { // Catch the exception
        e.printStackTrace()
      }
      generate(content, size, backgroundColor, foregroundColor, result)
    } else if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  fun saveToFile(image: Bitmap, content: String, result: Result) {
    val path = Environment.getExternalStorageDirectory().toString()
    val imageFile = File(path, content + ".jpg")
    try {
      val stream: OutputStream = FileOutputStream(imageFile)
      image.compress(Bitmap.CompressFormat.JPEG, 100, stream)
      stream.flush()
      stream.close()
      Log.d(TAG, "Image saved successful.")
      result.success(imageFile.absolutePath)
    } catch (e: Exception){ // Catch the exception
      e.printStackTrace()
      Log.d(TAG, "Error to save image.")
      result.error("ERROR", "Could not save image to disk", null)
    }
  }

  fun generate(content: String, size: Int, backgroundColor: Int, foregroundColor: Int, result: Result) {
    AwesomeQRCode.Renderer().contents(content)
            .size(size).margin(20)
            .colorDark(foregroundColor).colorLight(backgroundColor)
            .renderAsync(object : AwesomeQRCode.Callback {
              override fun onRendered(renderer: AwesomeQRCode.Renderer, bitmap: Bitmap) {
                saveToFile(bitmap, content + "_" + size.toString() + "_" + backgroundColor.toString() + "_" + foregroundColor.toString(), result)
              }

              override fun onError(renderer: AwesomeQRCode.Renderer, e: Exception) {
                e.printStackTrace()
                result.error("ERROR", "Generate failed", null)
              }
            })
  }
}
