package org.eyrefree.ef_qrcode

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import net.glxn.qrgen.android.QRCode

import android.graphics.Bitmap
import android.graphics.Color
import android.text.TextUtils
import android.util.Log
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

    private const val TAG = "EfQrcodePlugin"
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "generate") {
      val size: Int = 1024
      try {
        val content = call.argument<String>("content")
        val backgroundColorStr = call.argument<String>("backgroundColor")
        val foregroundColorStr = call.argument<String>("foregroundColor")

        val backgroundColor = when  {
          TextUtils.isEmpty(backgroundColorStr) -> Color.WHITE
          else -> Color.parseColor(backgroundColorStr)
        }
        val foregroundColor = when  {
          TextUtils.isEmpty(foregroundColorStr) -> Color.BLACK
          else -> Color.parseColor(foregroundColorStr)
        }
        generate(content, size, backgroundColor, foregroundColor, result)
      } catch (e: Exception) { // Catch the exception
        e.printStackTrace()
      }
    } else if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  private fun saveToFile(image: Bitmap, content: String, result: Result) {
    val path = File(context.externalCacheDir, "ef_qrcode")
    if (!path.exists()) path.mkdir()
    val imageFile = File(path, "$content.jpg")
    if (imageFile.exists()) imageFile.delete()
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

  @Throws(Exception::class)
  private fun generate(content: String?, size: Int, backgroundColor: Int, foregroundColor: Int, result: Result) {
    val bitmap = QRCode.from(content).withSize(1024, 1024).withColor(foregroundColor, backgroundColor).bitmap()
    saveToFile(bitmap, content + "_" + size.toString() + "_" + backgroundColor.toString() + "_" + foregroundColor.toString(), result)
  }
}
