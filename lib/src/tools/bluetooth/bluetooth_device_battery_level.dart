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

    return RotatedBox(
      quarterTurns: 1,
      child: Icon(
        bluetoothDeviceBatteryLevel,
        color: Colors.grey,
      ),
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
}
