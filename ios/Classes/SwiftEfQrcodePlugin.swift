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
                result(FlutterError.init(code: "UNAVAILABLE", message: "Arguments unavailable", details: nil))
                return
            }
            let content: String = arguments["content"] as? String ?? ""
            let backgroundColorStr: String = arguments["backgroundColor"] as? String ?? "#ffffff"
            let foregroundColorStr: String = arguments["foregroundColor"] as? String ?? "#000000"
            let size: EFIntSize = EFIntSize(width: 1024, height: 1024)
            let backgroundColor: CGColor = (UIColor(valueRGBString: backgroundColorStr) ?? UIColor.white).cgColor
            let foregroundColor: CGColor = (UIColor(valueRGBString: foregroundColorStr) ?? UIColor.black).cgColor
            generate(content: content, size: size, backgroundColor: backgroundColor, foregroundColor: foregroundColor, result: result)
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterError.init(code: "UNAVAILABLE", message: "Method unavailable", details: nil))
        }
    }

    func generate(content: String, size: EFIntSize, backgroundColor: CGColor, foregroundColor: CGColor, result: @escaping FlutterResult) {
        guard let image: CGImage = EFQRCode.generate(
            content: content,
            size: size,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
            ) else {
                result(FlutterError.init(code: "ERROR", message: "Generate failed", details: nil))
                return
        }
        result(saveToFile(image: UIImage(cgImage: image)))
    }

    // https://medium.com/coding-with-flutter/intro-to-platform-channels-building-an-image-picker-in-flutter-7e79c20065
    func saveToFile(image: UIImage) -> Any {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return FlutterError(code: "ERROR", message: "Could not encode image", details: nil)
        }
        let tempDir = NSTemporaryDirectory()
        let imageName = "image_ef_qrcode_\(ProcessInfo().globallyUniqueString).jpg"
        let filePath = tempDir.appending(imageName)
        if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil) {
            return filePath
        } else {
            return FlutterError(code: "ERROR", message: "Could not save image to disk", details: nil)
        }
    }
}
