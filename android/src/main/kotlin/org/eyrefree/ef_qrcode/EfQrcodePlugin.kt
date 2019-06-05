package org.eyrefree.ef_qrcode

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.Rect
import android.text.TextUtils
import android.util.Log
import com.github.sumimakito.awesomeqr.AwesomeQrRenderer
import com.github.sumimakito.awesomeqr.option.RenderOption
import com.github.sumimakito.awesomeqr.option.background.Background
import com.github.sumimakito.awesomeqr.option.background.StillBackground
import com.github.sumimakito.awesomeqr.option.logo.Logo
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream

class EfQrcodePlugin(private val context: Context): MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "ef_qrcode")
      channel.setMethodCallHandler(EfQrcodePlugin(registrar.context()))
    }

    private const val TAG = "EfQRcodePlugin"
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "generate") {
      try {
        // 内容
        val content = call.argument<String>("content") ?: ""
        // 大小
        val size = call.argument<Int>("size") ?: 1024
        // 背景色
        var backgroundColorStr = call.argument<String>("backgroundColor")
        backgroundColorStr = if (backgroundColorStr == "" || backgroundColorStr == null) "#ffffff" else backgroundColorStr
        // 前景色
        var foregroundColorStr = call.argument<String>("foregroundColor")
        foregroundColorStr = if (foregroundColorStr == "" || foregroundColorStr == null) "#000000" else foregroundColorStr
        // 水印（背景）
        val watermarkByteArray = call.argument<ByteArray>("watermark")

        val renderOption = RenderOption()
        renderOption.content = content
        renderOption.size = size
        renderOption.borderWidth = 0

        val color = com.github.sumimakito.awesomeqr.option.color.Color()
        color.background = Color.parseColor(backgroundColorStr)
        color.dark = Color.parseColor(foregroundColorStr)
        renderOption.color = color

        // 水印
        if (watermarkByteArray != null) {
          val bitmap = BitmapFactory.decodeByteArray(watermarkByteArray , 0, watermarkByteArray.size)

          val background = StillBackground()
          background.bitmap = bitmap
          background.clippingRect = Rect(0, 0, bitmap.width, bitmap.height)
          renderOption.background = background
        }

        val renderResult = AwesomeQrRenderer.render(renderOption)
        if (renderResult.bitmap != null) {
          // 正确
          val stream = ByteArrayOutputStream()
          renderResult.bitmap?.compress(Bitmap.CompressFormat.PNG, 100, stream)
          val imageByteArray = stream.toByteArray()
          result.success(imageByteArray)
        } else {
          // 错误
          result.error("Generate QRCode Error!", null, null)
        }

      } catch (e: Exception) { // Catch the exception
        e.printStackTrace()
        result.error(e.toString(), null, null)
      }
    } else if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }
}
