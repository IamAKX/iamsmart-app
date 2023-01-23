import 'package:flutter/material.dart';

import '../util/colors.dart';
import '../util/theme.dart';

class InactiveButton extends StatelessWidget {
  const InactiveButton({Key? key, required this.onPressed, required this.label})
      : super(key: key);
  final VoidCallback onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultPadding, right: defaultPadding, top: defaultPadding),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(
              color: primaryColor,
              width: 0.35,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w100,
                  fontSize: 16.5,
                  letterSpacing: 1.2),
            ),
          ),
        ),
      ),
    );
  }
}
