import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "wireless_controller.dart";

class WirelessPopup extends StatelessWidget {
  const WirelessPopup({Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Consumer<WirelessController>(
      builder: (
        BuildContext context,
        WirelessController value,
        Widget? child,
      ) =>
          this._buildContent(context, value),
    );
  }

  Widget _buildContent(
      final BuildContext context, final WirelessController controller) {
    //
    // TO DO something with controller
    //
    return TextButton(
      onPressed: () {
        if (controller.isEnabled) {
          controller.disable();
        } else {
          controller.enable();
        }
      },
      child: const Text("WirelessPopup"),
    );
  }
}
