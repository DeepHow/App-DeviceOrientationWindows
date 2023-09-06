#ifndef FLUTTER_PLUGIN_DEVICE_ORIENTATION_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_DEVICE_ORIENTATION_WINDOWS_PLUGIN_H_

#include <flutter/encodable_value.h>
#include <flutter/event_stream_handler.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace device_orientation_windows {

class DeviceOrientationWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DeviceOrientationWindowsPlugin(flutter::PluginRegistrarWindows *registrar);

  virtual ~DeviceOrientationWindowsPlugin();

  // Disallow copy and assign.
  DeviceOrientationWindowsPlugin(const DeviceOrientationWindowsPlugin&) = delete;
  DeviceOrientationWindowsPlugin& operator=(const DeviceOrientationWindowsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  flutter::PluginRegistrarWindows *registrar;

  std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> &&orientation_events = nullptr;

  // The ID of the WindowProc delegate registration.
  int window_proc_id = -1;

  // Called for top-level WindowProc delegation.
  std::optional<LRESULT> HandleWindowProc(HWND hwnd,
                                          UINT message,
                                          WPARAM wParam,
                                          LPARAM lParam);

  // Called when Stream.listen is called on this plugin's event channel from Dart.
  std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnListen(
      const flutter::EncodableValue *arguments,
      std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> &&events);

  // Called when StreamSubscription.cancel is called on this plugin's event channel from Dart.
  std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnCancel(
      const flutter::EncodableValue *arguments);

  // Get dmPelsWidth, dmPelsHeight and dmDisplayOrientation through wingdi API.
  flutter::EncodableValue GetDeviceOrientation();
};

}  // namespace device_orientation_windows

#endif  // FLUTTER_PLUGIN_DEVICE_ORIENTATION_WINDOWS_PLUGIN_H_
