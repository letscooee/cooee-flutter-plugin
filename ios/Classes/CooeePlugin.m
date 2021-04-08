#import "CooeePlugin.h"
#if __has_include(<cooee_plugin/cooee_plugin-Swift.h>)
#import <cooee_plugin/cooee_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cooee_plugin-Swift.h"
#endif

@implementation CooeePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCooeePlugin registerWithRegistrar:registrar];
}
@end
