import 'package:flutter/material.dart';

import '../util/colors.dart';
import '../util/theme.dart';

class ActiveButton extends StatelessWidget {
  ActiveButton(
      {Key? key, required this.onPressed, required this.label, this.isDisabled})
      : super(key: key);
  final VoidCallback onPressed;
  final String label;
  bool? isDisabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultPadding, right: defaultPadding, top: defaultPadding),
      child: GestureDetector(
        onTap: isDisabled ?? false ? null : onPressed,
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            color: isDisabled ?? false
                ? primaryColor.withOpacity(0.4)
                : primaryColor,
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
