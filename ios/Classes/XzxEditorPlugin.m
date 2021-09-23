#import "XzxEditorPlugin.h"
#if __has_include(<xzx_editor/xzx_editor-Swift.h>)
#import <xzx_editor/xzx_editor-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "xzx_editor-Swift.h"
#endif

@implementation XzxEditorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftXzxEditorPlugin registerWithRegistrar:registrar];
}
@end
