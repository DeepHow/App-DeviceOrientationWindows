import 'package:device_orientation_windows/device_orientation.dart';
import 'package:device_orientation_windows/device_orientation_windows.dart';
import 'package:device_orientation_windows/device_orientation_windows_platform_interface.dart';
import 'package:device_orientation_windows/device_orientation_windows_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDeviceOrientationWindowsPlatform
    with MockPlatformInterfaceMixin
    implements DeviceOrientationWindowsPlatform {
  @override
  Future<DeviceOrientation> getDeviceOrientation() =>
      Future.value(DeviceOrientation.portraitUp);

  @override
  Stream<DeviceOrientation> onOrientationChanged() =>
      Stream.value(DeviceOrientation.portraitUp);
}

void main() {
  final DeviceOrientationWindowsPlatform initialPlatform =
      DeviceOrientationWindowsPlatform.instance;

  test('$MethodChannelDeviceOrientationWindows is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelDeviceOrientationWindows>());
  });

  test('getDeviceOrientation', () async {
    MockDeviceOrientationWindowsPlatform fakePlatform =
        MockDeviceOrientationWindowsPlatform();
    DeviceOrientationWindowsPlatform.instance = fakePlatform;

    expect(await DeviceOrientationWindows.getDeviceOrientation(),
        DeviceOrientation.portraitUp);
  });

  test('onOrientationChanged', () async {
    MockDeviceOrientationWindowsPlatform fakePlatform =
        MockDeviceOrientationWindowsPlatform();
    DeviceOrientationWindowsPlatform.instance = fakePlatform;

    DeviceOrientationWindows.onOrientationChanged()
        .listen((event) => expect(event, DeviceOrientation.portraitUp));
  });
}
