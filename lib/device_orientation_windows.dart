import 'device_orientation.dart';
import 'device_orientation_windows_platform_interface.dart';

class DeviceOrientationWindows {
  /// Returns the current [DeviceOrientation].
  static Future<DeviceOrientation> getDeviceOrientation() {
    return DeviceOrientationWindowsPlatform.instance.getDeviceOrientation();
  }

  /// Notifies about changes to any device orientation updates.
  static Stream<DeviceOrientation> onOrientationChanged() {
    return DeviceOrientationWindowsPlatform.instance.onOrientationChanged();
  }
}
