#include "include/device_orientation_windows/device_orientation_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "device_orientation_windows_plugin.h"

void DeviceOrientationWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  device_orientation_windows::DeviceOrientationWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
