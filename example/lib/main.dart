import 'dart:async';

import 'package:device_orientation_windows/device_orientation.dart';
import 'package:device_orientation_windows/device_orientation_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DeviceOrientation _deviceOrientation = DeviceOrientation.unknown;
  StreamSubscription<DeviceOrientation>? _subscription;

  Future<void> getDeviceOrientation() async {
    DeviceOrientation deviceOrientation;
    try {
      deviceOrientation = await DeviceOrientationWindows.getDeviceOrientation();
    } on services.PlatformException {
      deviceOrientation = DeviceOrientation.unknown;
    }

    if (mounted) {
      setState(() {
        _deviceOrientation = deviceOrientation;
      });
    }
  }

  void listenOrientationChanged() {
    _subscription ??=
        DeviceOrientationWindows.onOrientationChanged().listen((event) {
      if (mounted) {
        setState(() {
          _deviceOrientation = event;
        });
      }
    });
    setState(() {});
  }

  void cancelOrientationChanged() {
    _subscription?.cancel();
    setState(() {
      _subscription = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Device Orientation Windows Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Device Orientation: ${_deviceOrientation.name}\n'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: getDeviceOrientation,
                child: const Text('Get device orientation'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _subscription == null
                    ? listenOrientationChanged
                    : cancelOrientationChanged,
                child: _subscription == null
                    ? const Text('Listen device orientation event')
                    : const Text('Cancel device orientation event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
