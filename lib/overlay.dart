import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverLayWidget extends StatefulWidget {
  const OverLayWidget({Key? key}) : super(key: key);

  @override
  State<OverLayWidget> createState() => _OverLayWidgetState();
}

class _OverLayWidgetState extends State<OverLayWidget> {
  int data = 0;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      log("$event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0,
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://www.bozemanhelpcenter.org/uploads/4/6/3/7/4637709/editor/faceitcommunity-4.png",
                width: 120.0,
                height: 120.0,
              ),
              const SizedBox(height: 20.0),
              Text("Data: $data"),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}