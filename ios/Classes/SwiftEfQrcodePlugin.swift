import Flutter
import UIKit
import EFQRCode

public class SwiftEfQrcodePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ef_qrcode", binaryMessenger: registrar.messenger())
        let instance = SwiftEfQrcodePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "generate":
            guard let arguments: [String: Any] = call.arguments as? [String: Any] else {
                result(FlutterError(code: "UNAVAILABLE", message: "Arguments unavailable", details: nil))
                return
            }
            
            let content = arguments["content"] as? String ?? ""
            let size = arguments["size"] as? Int ?? 1024
            var backgroundColorStr = arguments["backgroundColor"] as? String ?? "#ffffff"
            backgroundColorStr = (backgroundColorStr == "") ? "#ffffff" : backgroundColorStr
            var foregroundColorStr = arguments["foregroundColor"] as? String ?? "#000000"
            foregroundColorStr = (foregroundColorStr == "") ? "#000000" : foregroundColorStr
            let watermarkData = (arguments["watermark"] as? FlutterStandardTypedData)?.data
            
            let generator = EFQRCodeGenerator(content: content)
            // 大小
            generator.setSize(size: EFIntSize(width: size, height: size))
            // 颜色
            generator.setColors(backgroundColor: (UIColor(valueRGBString: backgroundColorStr) ?? UIColor.white).cgColor,
                                foregroundColor: (UIColor(valueRGBString: foregroundColorStr) ?? UIColor.black).cgColor)
            // 水印
            if let data = watermarkData {
                let image = UIImage(data: data)
                generator.setWatermark(watermark: image?.cgImage)
            }
            // 最终生成的二维码
            if let cgImage = generator.generate(),
                let data = UIImage(cgImage: cgImage).pngData() {
                result(FlutterStandardTypedData(bytes: data))
            } else {
                result(FlutterError(code: "ERROR", message: "Generate failed", details: nil))
            }
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterError(code: "UNAVAILABLE", message: "Method unavailable", details: nil))
        }
    }

}

