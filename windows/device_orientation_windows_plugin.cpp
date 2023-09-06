#include "device_orientation_windows_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/event_channel.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

using ::flutter::EncodableValue;
using ::flutter::EventSink;
using ::flutter::StreamHandlerError;

namespace device_orientation_windows {

// static
void DeviceOrientationWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<EncodableValue>>(
          registrar->messenger(), "device_orientation_windows",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<DeviceOrientationWindowsPlugin>(registrar);

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  auto eventHandler = std::make_unique<
  flutter::StreamHandlerFunctions<EncodableValue>>(
      [plugin_pointer = plugin.get()](const auto *arguments, auto &&events) {
        return plugin_pointer->OnListen(arguments, std::move(events));
      },
      [plugin_pointer = plugin.get()](const auto *arguments) {
        return plugin_pointer->OnCancel(arguments);
      });

  auto eventChannel = std::make_unique<flutter::EventChannel<EncodableValue>>(
      registrar->messenger(), "device_orientation_windows/orientation_event",
      &flutter::StandardMethodCodec::GetInstance());

  eventChannel->SetStreamHandler(std::move(eventHandler));

  registrar->AddPlugin(std::move(plugin));
}

DeviceOrientationWindowsPlugin::DeviceOrientationWindowsPlugin(
    flutter::PluginRegistrarWindows *registrar)
    : registrar(registrar) {
  window_proc_id = registrar->RegisterTopLevelWindowProcDelegate(
      [this](HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam) {
        return HandleWindowProc(hwnd, message, wParam, lParam);
      });
}

DeviceOrientationWindowsPlugin::~DeviceOrientationWindowsPlugin() {
  registrar->UnregisterTopLevelWindowProcDelegate(window_proc_id);
}

void DeviceOrientationWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<EncodableValue>> result) {
  if (method_call.method_name().compare("getDeviceOrientation") == 0) {
    result->Success(GetDeviceOrientation());
  } else {
    result->NotImplemented();
  }
}

std::optional<LRESULT> DeviceOrientationWindowsPlugin::HandleWindowProc(
    HWND hwnd,
    UINT message,
    WPARAM wParam,
    LPARAM lParam) {
  std::optional<LRESULT> result = std::nullopt;

  if (message == WM_DISPLAYCHANGE) {
    if (orientation_events != nullptr) {
      orientation_events->Success(GetDeviceOrientation());
    }
  }

  return result;
}

std::unique_ptr<StreamHandlerError<EncodableValue>>
    DeviceOrientationWindowsPlugin::OnListen(
        const EncodableValue *arguments,
        std::unique_ptr<EventSink<EncodableValue>> &&events) {
  orientation_events = std::move(events);
  orientation_events->Success(GetDeviceOrientation());
  return nullptr;
}

std::unique_ptr<StreamHandlerError<EncodableValue>>
    DeviceOrientationWindowsPlugin::OnCancel(const EncodableValue *arguments) {
  orientation_events = nullptr;
  return nullptr;
}

EncodableValue DeviceOrientationWindowsPlugin::GetDeviceOrientation() {
  DEVMODE devMode;
  ZeroMemory(&devMode, sizeof(DEVMODE));
  devMode.dmSize = sizeof(DEVMODE);
  devMode.dmFields = DM_PELSWIDTH | DM_PELSHEIGHT | DM_DISPLAYORIENTATION;

  auto output = flutter::EncodableMap::map();

  if (EnumDisplaySettingsEx(NULL,
                            ENUM_CURRENT_SETTINGS,
                            &devMode,
                            EDS_RAWMODE)) {
    // Get display device width (in pixels)
    int width = devMode.dmPelsWidth;
    output.insert(std::pair<EncodableValue, EncodableValue>(
        EncodableValue("width"),
        EncodableValue(width)));

    // Get display device height (in pixels)
    int height = devMode.dmPelsHeight;
    output.insert(std::pair<EncodableValue, EncodableValue>(
        EncodableValue("height"),
        EncodableValue(height)));

    // Get display device orientation
    // DMDO_DEFAULT: 0
    // DMDO_90: 1
    // DMDO_180: 2
    // DMDO_270: 3
    int orientation = devMode.dmDisplayOrientation;
    output.insert(std::pair<EncodableValue, EncodableValue>(
        EncodableValue("orientation"),
        EncodableValue(orientation)));
  }
  
  return EncodableValue(output);
}

}  // namespace device_orientation_windows
