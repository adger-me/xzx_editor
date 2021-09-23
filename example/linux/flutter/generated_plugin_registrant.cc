//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <xzx_editor/xzx_editor_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) xzx_editor_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "XzxEditorPlugin");
  xzx_editor_plugin_register_with_registrar(xzx_editor_registrar);
}
