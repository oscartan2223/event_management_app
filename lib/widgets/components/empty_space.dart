import 'package:flutter/material.dart';

class VerticalEmptySpace extends StatelessWidget {
  const VerticalEmptySpace({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height ?? 12,);
  }
}

class HorizontalEmptySpace extends StatelessWidget {
  const HorizontalEmptySpace({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width ?? 12,);
  }
}