import "package:flutter/material.dart";

class MyExpansionWidget extends StatefulWidget {
  const MyExpansionWidget(
      {Key? key, required Text header, required Column body})
      : super(key: key);

  @override
  State<MyExpansionWidget> createState() => _MyExpansionWidget();
}

class _MyExpansionWidget extends State<MyExpansionWidget> {
  @override
  Widget build(
    final BuildContext context,
  ) {
    return const Text("Test");
  }
}
