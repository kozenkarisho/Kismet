import 'package:flutter/material.dart';

class KismetLogo extends StatelessWidget {
  final double? size;
  final Color? color;

  const KismetLogo({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 34.0;
    final textColor = color ?? const Color(0xFFE3E4CE);

    return Image.asset(
      'assets/images/kismet_logo.png',
      height: logoSize,
      color: textColor,
    );
  }
}
