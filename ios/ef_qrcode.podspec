#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'ef_qrcode'
  s.version          = '0.2.2'
  s.summary          = 'A better way to operate quick response code in Flutter.'
  s.description      = <<-DESC
ef_qrcode is a lightweight, pure-Swift library for generating pretty QRCode image with input watermark or icon and recognizing QRCode from image, it is based on CoreGraphics, CoreImage and ImageIO. ef_qrcode provides you a better way to operate QRCode in your app.
                       DESC
  s.homepage         = 'https://github.com/EFPub/ef_qrcode'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'EyreFree' => 'eyrefree@eyrefree.org' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.swift_version = '4.2'
  s.ios.deployment_target = '8.0'
  s.dependency 'EFQRCode', '~> 5.0.0'
end

