import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_orientation.dart';
import 'device_orientation_windows_method_channel.dart';

abstract class DeviceOrientationWindowsPlatform extends PlatformInterface {
  /// Constructs a DeviceOrientationWindowsPlatform.
  DeviceOrientationWindowsPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceOrientationWindowsPlatform _instance =
      MethodChannelDeviceOrientationWindows();

  /// The default instance of [DeviceOrientationWindowsPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceOrientationWindows].
  static DeviceOrientationWindowsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceOrientationWindowsPlatform] when
  /// they register themselves.
  static set instance(DeviceOrientationWindowsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the current [DeviceOrientation].
  Future<DeviceOrientation> getDeviceOrientation() {
    throw UnimplementedError(
        'getDeviceOrientation() has not been implemented.');
  }

  /// Notifies about changes to any device orientation updates.
  Stream<DeviceOrientation> onOrientationChanged() {
    throw UnimplementedError(
        'onOrientationChanged() has not been implemented.');
  }
}
