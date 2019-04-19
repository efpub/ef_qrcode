# ef_qrcode

[![pub package](https://img.shields.io/pub/v/ef_qrcode.svg)](https://pub.dartlang.org/packages/ef_qrcode)

A flutter plugin can be used to generate QRCode.

## Example

<img src="https://raw.githubusercontent.com/efpub/ef_qrcode/master/example/example.jpg" width="33%"/>

## Getting Started

This project is a starting point for a Flutter [plug-in package](https://flutter.io/developing-packages/), a specialized package that includes platform-specific implementation code for Android and/or iOS.

For help getting started with Flutter, view our [online documentation](https://flutter.io/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Use

### Android

This pub need `WRITE_EXTERNAL_STORAGE` permission, so add this to `AndroidManifest.xml` in your project first:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" tools:remove="android:maxSdkVersion"/>
```

And do not forget to request permissions before use with some approaches like `checkSelfPermission` or `shouldShowRequestPermissionRationale`.

### iOS

Nothing.

### Flutter

1. Dependency

In your `pubspec.yaml`, add the following config:

```yaml
dependencies:
   ef_qrcode: 0.2.0
```

2. Generate

The method statement is as follows:

```dart
static Future<File> generate(String content, String backgroundColor, String foregroundColor)
```

You can call this method liek this:

```dart
void generateImage() async {
   try {
      var imageFile = await EfQrcode.generate("content", "#ffffff", "#000000");
      setState(() {
         _imageFile = imageFile;
      });
   }
   catch (e) {
      print(e);
   }
}
```

For more information, you can see the [example](https://github.com/EFPub/ef_qrcode/blob/master/example/lib/main.dart) project.

## Author

EyreFree, eyrefree@eyrefree.org
