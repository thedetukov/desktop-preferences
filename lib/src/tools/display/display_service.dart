// import "package:flutter/material.dart";
// import "dart:convert";
import "dart:async" show Future;
import "dart:io" show InternetAddress, HttpServer;

import "package:shelf/shelf.dart"
    show MiddlewareExtensions, Request, Response, logRequests;

import "display_service_contract.dart" show DisplayService, DisplayDevice;
import "package:shelf/shelf_io.dart" as shelf_io;

class DisplayServiceStub extends DisplayService {
  ///
  /// List of connected displays.
  ///
  @override
  final List<DisplayDevice> displays;

  HttpServer? _server;

  ///
  /// On/Off Dark Mode Display.
  ///
  @override
  bool isDarkModeEnabled;

  @override
  void disableDarkMode() {
    this.isDarkModeEnabled = false;
  }

  @override
  void enableDarkMode() {
    this.isDarkModeEnabled = true;
  }

  ///
  /// On/Off Night Mode Display.
  ///
  @override
  bool isNightModeEnabled;

  @override
  void disableNightMode() {
    this.isNightModeEnabled = false;
  }

  @override
  void enableNightMode() {
    this.isNightModeEnabled = true;
  }

  ///
  /// Call this method to set the brightness display.
  ///
  @override
  void setBrightness(final DisplayDevice display, final double brightness) {
    // ignore: avoid_print
    print("Brightness is: $brightness");
    if (brightness < 0 || brightness > 1) {
      throw ArgumentError.value(brightness);
    }
    if (display is! _DisplayDevice) {
      throw ArgumentError.value(display, "Wrong display instance");
    }

    display.brightness = brightness;
  }

  ///
  /// Create the list of connected fake displays.
  ///
  DisplayServiceStub()
      : this.isDarkModeEnabled = false,
        this.isNightModeEnabled = false,
        this.displays = List<DisplayDevice>.unmodifiable(
          <DisplayDevice>[
            _DisplayDevice("Display_1", 0.3),
            _DisplayDevice("Display_2", 0.4),
            _DisplayDevice("Display_3", 0.5),
          ],
        ) {
    // See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
    shelf_io
        .serve(
      logRequests().addHandler(this._handler),
      InternetAddress.anyIPv4, // Allows external connections
      8080,
    )
        .then(
      (final HttpServer value) {
        this._server = value;
      },
    ).catchError(
      (err) {
        //
        print(err);
      },
    );
  }

  Future<Response> _handler(final Request request) async {
    //
    print(request.method);
    if (request.method == "GET") {
      return Response.ok(
        "Hello",
        headers: {
          // "Content-Type": contentType.toString(),
          // "Cache-Control": "no-cache"
        },
      );
    }
    throw Exception("Go to widget");
  }

  // Future<void> speaker() async {
  //   while (true) {
  //     print("Enter your brightness value from 0 to 100:");
  //     final String brightnessStr = await readLine();

  //     if (!RegExp(r"^[0-9]+$").hasMatch(brightnessStr)) {
  //       continue;
  //     }

  //     final double brightness = double.parse(brightnessStr) / 100;
  //     print("Brightness set to: $brightness");

  //     if (brightness < 0 || brightness > 1) {
  //       continue;
  //     }

  //     final _DisplayDevice display = this.displays.first as _DisplayDevice;
  //     display.brightness = brightness;
  //   }
  // }
}

///
/// Properties of the Display device.
///
class _DisplayDevice implements DisplayDevice {
  ///
  /// Name of the Display device
  ///
  @override
  String name;

  ///
  /// Brightness of the Display device
  ///
  @override
  double brightness;

  _DisplayDevice(this.name, this.brightness);
}

// /// Reads a single line from [stdin] asynchronously.
// Future<String> readLine() async {
//   final Completer<String> completer = Completer<String>(); // completer
//   final StreamSubscription<String> stream = stdin // stdin
//       .transform(utf8.decoder) // decode
//       .transform(const LineSplitter()) // split line
//       .asBroadcastStream() // make it stream
//       .listen((String line) =>
//           !completer.isCompleted ? completer.complete(line) : 0); // listen

//   final String output = await completer.future; // get output from future
//   stream.cancel(); // cancel stream after future is completed
//   return output;
// }
