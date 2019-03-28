#import "EfQrcodePlugin.h"
#import <ef_qrcode/ef_qrcode-Swift.h>

@implementation EfQrcodePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEfQrcodePlugin registerWithRegistrar:registrar];
}
@end
