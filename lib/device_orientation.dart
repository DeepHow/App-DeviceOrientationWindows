// ignore_for_file: constant_identifier_names

/// Specifies a particular device orientation.
///
/// To determine which values correspond to which orientations, first position
/// the device in its default orientation (this is the orientation that the
/// system first uses for its boot logo, or the orientation in which the
/// hardware logos or markings are upright, or the orientation in which the
/// cameras are at the top). If this is a portrait orientation, then this is
/// [portraitUp]. Otherwise, it's [landscapeLeft]. As you rotate the device by
/// 90 degrees in a counter-clockwise direction around the axis that pierces the
/// screen, you step through each value in this enum in the order given.
///
/// For a device with a landscape default orientation, the orientation obtained
/// by rotating the device 90 degrees clockwise from its default orientation is
/// [portraitUp].
enum DeviceOrientation {
  /// If the device shows its boot logo in portrait, then the boot logo is shown
  /// in [portraitUp]. Otherwise, the device shows its boot logo in landscape
  /// and this orientation is obtained by rotating the device 90 degrees
  /// clockwise from its boot orientation.
  portraitUp,

  /// The orientation that is 90 degrees clockwise from [portraitUp].
  ///
  /// If the device shows its boot logo in landscape, then the boot logo is
  /// shown in [landscapeLeft].
  landscapeLeft,

  /// The orientation that is 180 degrees from [portraitUp].
  portraitDown,

  /// The orientation that is 90 degrees counterclockwise from [portraitUp].
  landscapeRight,

  /// The orientation that is unknown.
  unknown,
}

/// For display devices only, the orientation at which images should be
/// presented in Windows.
/// 
/// For more information, see the
/// [DEVMODE documentation](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-devmodea).
enum WindowsOrientation {
  /// The display orientation is the natural orientation of the display device.
  /// It should be used as the default.
  DMDO_DEFAULT(0),

  /// The display orientation is rotated 90 degrees (measured clockwise) from
  /// DMDO_DEFAULT.
  DMDO_90(1),

  /// The display orientation is rotated 180 degrees (measured clockwise) from
  /// DMDO_DEFAULT.
  DMDO_180(2),

  /// The display orientation is rotated 270 degrees (measured clockwise) from
  /// DMDO_DEFAULT.
  DMDO_270(3);

  /// Parse `dmDisplayOrientation` value to [WindowsOrientation].
  static WindowsOrientation parse(int value) {
    switch (value) {
      case 3:
        return DMDO_270;
      case 2:
        return DMDO_180;
      case 1:
        return DMDO_90;
      default:
        return DMDO_DEFAULT;
    }
  }

  const WindowsOrientation(this.value);

  /// `dmDisplayOrientation` value from Windows.
  final int value;
}
