import 'package:flutter/material.dart';

class BgWidget extends StatelessWidget {
  final String? bgImagePath;
  final Widget? child;

  const BgWidget({
    super.key,
    this.bgImagePath,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: bgImagePath != null
          ? BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage(bgImagePath!),
          fit: BoxFit.cover,
        ),
      )
          : null,
      child: child,
    );
  }
}
