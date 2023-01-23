import 'package:flutter/material.dart';

import '../util/colors.dart';
import '../util/theme.dart';

class ActiveButton extends StatelessWidget {
  const ActiveButton({Key? key, required this.onPressed, required this.label})
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
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: primaryColor,
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                  letterSpacing: 1.0),
            ),
          ),
        ),
      ),
    );
  }
}
