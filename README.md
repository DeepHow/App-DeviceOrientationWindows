# device_orientation_windows

A Flutter plugin to get Windows device orientation using wingdi

## Getting Started

Get current device orientation:
```dart
DeviceOrientation deviceOrientation = await DeviceOrientationWindows.getDeviceOrientation();
```

Listen for device orientation change events:
```dart
DeviceOrientation? deviceOrientation;
DeviceOrientationWindows.onOrientationChanged().listen((orientation) {
  deviceOrientation = orientation;
});
```
