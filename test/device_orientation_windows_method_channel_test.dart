import 'package:device_orientation_windows/device_orientation.dart';
import 'package:device_orientation_windows/device_orientation_windows_method_channel.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDeviceOrientationWindows platform =
      MethodChannelDeviceOrientationWindows();
  const services.MethodChannel channel =
      services.MethodChannel('device_orientation_windows');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (services.MethodCall methodCall) async {
        if (methodCall.method == 'getDeviceOrientation') {
          return {
            'width': 1920,
            'height': 1080,
            'orientation': WindowsOrientation.DMDO_DEFAULT.value,
          };
        }
        throw UnimplementedError(
            '${methodCall.method}() has not been implemented.');
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getDeviceOrientation', () async {
    expect(
        await platform.getDeviceOrientation(), DeviceOrientation.landscapeLeft);
  });
}
