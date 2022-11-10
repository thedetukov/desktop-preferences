import "package:flutter/material.dart";

class BluetoothDeviceBatteryLevel extends StatelessWidget {
  final double batteryLevel;
  final bool isConnected;

  const BluetoothDeviceBatteryLevel({
    Key? key,
    required this.batteryLevel,
    this.isConnected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconData? bluetoothDeviceBatteryLevel =
        BluetoothDeviceBatteryLevel._resolveBatteryLevelData(batteryLevel);

    final String bluetoothTranslateBatteryLevel =
        BluetoothDeviceBatteryLevel._translateBatteryLevel(batteryLevel);

    return Icon(
      bluetoothDeviceBatteryLevel,
    );
  }

// Assigning a charge level icon to each device
  static IconData? _resolveBatteryLevelData(double batteryLevel) {
    if (batteryLevel >= 0 && batteryLevel < 0.2) {
      return Icons.battery_0_bar_rounded;
    } else if (batteryLevel >= 0.2 && batteryLevel < 0.4) {
      return Icons.battery_1_bar_rounded;
    } else if (batteryLevel >= 0.4 && batteryLevel < 0.6) {
      return Icons.battery_2_bar_rounded;
    } else if (batteryLevel >= 0.6 && batteryLevel < 0.8) {
      return Icons.battery_3_bar_rounded;
    } else if (batteryLevel >= 0.8 && batteryLevel < 1) {
      return Icons.battery_4_bar_rounded;
    }
    return Icons.battery_full_rounded;
  }

  static String _translateBatteryLevel(double batteryLevel) {
    // todo implement it
    for (int level = 0; level < 100; level++) {
      if (level == 0) {
        return "0%";
      }
      final double doubleLevel = level / 100;
      final double intermediateDoubleLevel = doubleLevel * 1000;
      final String stringLevel = intermediateDoubleLevel.toStringAsFixed(0);

      return "$stringLevel%";
    }
    return "100 %";
  }
}
