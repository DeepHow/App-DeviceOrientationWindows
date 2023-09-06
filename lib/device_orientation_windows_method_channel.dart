import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' as services;

import 'device_orientation.dart';
import 'device_orientation_windows_platform_interface.dart';

/// An implementation of [DeviceOrientationWindowsPlatform] that uses method channels.
class MethodChannelDeviceOrientationWindows
    extends DeviceOrientationWindowsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const services.MethodChannel('device_orientation_windows');

  /// The event channel used to interact with the native platform.
  @visibleForTesting
  final eventChannel = const services.EventChannel(
      'device_orientation_windows/orientation_event');

  @override
  Future<DeviceOrientation> getDeviceOrientation() async {
    Map<String, dynamic>? data = await methodChannel
        .invokeMapMethod<String, dynamic>('getDeviceOrientation');

    if (data == null || data.isEmpty) {
      return DeviceOrientation.unknown;
    }

    int width = data['width'] ?? 0;
    int height = data['height'] ?? 0;
    int orientation = data['orientation'] ?? 0;

    return _parseDeviceOrientation(width, height, orientation);
  }

  @override
  Stream<DeviceOrientation> onOrientationChanged() {
    return eventChannel.receiveBroadcastStream().map((event) {
      if (event is Map) {
        int width = event['width'] ?? 0;
        int height = event['height'] ?? 0;
        int orientation = event['orientation'] ?? 0;

        return _parseDeviceOrientation(width, height, orientation);
      }
      return DeviceOrientation.unknown;
    });
  }

  /// Returns the current [DeviceOrientation] based on width, height and
  /// orientation.
  DeviceOrientation _parseDeviceOrientation(
      int width, int height, int orientation) {
    final windowsOrientation = WindowsOrientation.parse(orientation);
    if (width > height) {
      switch (windowsOrientation) {
        case WindowsOrientation.DMDO_DEFAULT:
        case WindowsOrientation.DMDO_90:
          return DeviceOrientation.landscapeLeft;
        case WindowsOrientation.DMDO_180:
        case WindowsOrientation.DMDO_270:
          return DeviceOrientation.landscapeRight;
      }
    } else {
      switch (windowsOrientation) {
        case WindowsOrientation.DMDO_DEFAULT:
        case WindowsOrientation.DMDO_90:
          return DeviceOrientation.portraitUp;
        case WindowsOrientation.DMDO_180:
        case WindowsOrientation.DMDO_270:
          return DeviceOrientation.portraitDown;
      }
    }
  }
}
