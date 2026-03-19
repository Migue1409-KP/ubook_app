import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class DecorativeImage extends StatelessWidget {
  final String assetPath;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final double width;
  final double height;
  final Duration animationDuration;
  final bool fadeDown;

  const DecorativeImage({
    super.key,
    required this.assetPath,
    required this.width,
    required this.height,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.animationDuration = const Duration(seconds: 1),
    this.fadeDown = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(assetPath)),
      ),
    );

    if (fadeDown) {
      return Positioned(
        left: left > 0 ? left : null,
        right: right > 0 ? right : null,
        top: top,
        bottom: bottom > 0 ? bottom : null,
        width: width,
        height: height,
        child: FadeInDown(duration: animationDuration, child: child),
      );
    }

    return Positioned(
      left: left > 0 ? left : null,
      right: right > 0 ? right : null,
      top: top,
      bottom: bottom > 0 ? bottom : null,
      width: width,
      height: height,
      child: FadeInUp(duration: animationDuration, child: child),
    );
  }
}
