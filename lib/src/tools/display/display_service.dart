// ignore_for_file: prefer_interpolation_to_compose_strings

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
    print(request.method);
    // If GET request return html form.
    if (request.method == "GET") {
      return Response.ok(
        """<!DOCTYPE html>
                       <html>
                       <body>
                          <h1>Desktop Preferences</h1>
                          <form method="post">
                              <label for="display">Select display:</label>
                              <input type="text" id="display" name="display" required><br><br>

                              <label for="brightness">Set brightness from 0 to 100:</label>
                              <input type="text" id="brightness" name="brightness"><br><br>

                              <input type="submit" value="Submit">
                          </form>
                       </body>
                       </html>""",
        headers: <String, Object>{
          "Content-Type": "text/html",
          "Cache-Control": "no-cache",
        },
      );
    } else if (request.method == "POST") {
      // parsing data POST request extract key/value pairs of information from the query string.
      final String content = await request.readAsString();
      final Map<String, String> data = Uri(query: content).queryParameters;
      final String? queryParametersDisplay = data["display"];
      final String? queryParametersBrightness = data["brightness"];

      int displayIndex;
      double brightness;

      if (queryParametersDisplay == null) {
        return Response.badRequest(
            body: "Display is not selected. Please select the display.");
      }

      final int? queryParametersDisplayInt =
          int.tryParse(queryParametersDisplay);
      if (queryParametersDisplayInt == null) {
        return Response.badRequest(
            body:
                "Unable to read entered data. Please, set the correct display name.");
      }

      if (queryParametersDisplayInt < 0 ||
          queryParametersDisplayInt > this.displays.length) {
        return Response.badRequest(
            body:
                "Display is not in the specified range. Please, set in the correct range.");
      }

      if (queryParametersBrightness == null) {
        return Response.badRequest(
            body: "Brightness is not set. Please, set the brightness.");
      }

      final double? queryParametersBrightnessDouble =
          double.tryParse(queryParametersBrightness);
      if (queryParametersBrightnessDouble == null) {
        return Response.badRequest(
            body:
                "Unable to read entered data. Please, set the correct display brightness.");
      }

      if (queryParametersBrightnessDouble < 0 ||
          queryParametersBrightnessDouble > 100) {
        return Response.badRequest(
            body:
                "Brightness is not in the specified range. Please, set in the correct range.");
      }

      displayIndex = queryParametersDisplayInt;
      brightness = queryParametersBrightnessDouble;

      final _DisplayDevice display =
          this.displays[displayIndex] as _DisplayDevice;
      display.brightness = brightness;
    }
    throw Exception("Unknow request method. Send GET or POST request.");
  }
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
