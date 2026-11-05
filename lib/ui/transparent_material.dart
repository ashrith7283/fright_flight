import 'package:flutter/material.dart';

/// `MaterialApp.builder` that gives every screen a transparent [Material]
/// ancestor. Without one, `Text` falls back to Flutter's yellow double
/// underline style.
Widget transparentMaterialBuilder(BuildContext context, Widget? child) =>
    Material(type: MaterialType.transparency, child: child);
