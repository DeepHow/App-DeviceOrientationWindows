// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:device_orientation_windows/device_orientation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:device_orientation_windows/device_orientation_windows.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getDeviceOrientation test', (WidgetTester tester) async {
    final DeviceOrientation orientation =
        await DeviceOrientationWindows.getDeviceOrientation();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(DeviceOrientation.values.contains(orientation), true);
  });
}
