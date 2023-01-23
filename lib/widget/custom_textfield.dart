import 'package:flutter/material.dart';

import '../util/theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.hint,
      required this.controller,
      required this.keyboardType,
      required this.obscure,
      required this.icon,
      this.enabled})
      : super(key: key);

  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final IconData icon;

  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsets.only(
    //     left: 12.0,
    //     right: 12.0,
    //     top: 10.0,
    //   ),
    //   child: Theme(
    //     data: ThemeData(hintColor: dividerColor),
    //     child: Padding(
    //       padding: const EdgeInsets.only(left: 10.0),
    //       child: TextFormField(
    //         textAlign: TextAlign.start,
    //         obscureText: obscure,
    //         enabled: enabled ?? true,
    //         controller: controller,
    //         keyboardType: keyboardType,
    //         autocorrect: false,
    //         autofocus: false,
    //         decoration: InputDecoration(
    //           prefixIcon: Icon(icon),
    //           labelText: hint,
    //           hintText: hint,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultPadding,
          right: defaultPadding,
          top: defaultPadding / 2,
          bottom: defaultPadding / 2),
      child: TextField(
        enabled: enabled ?? true,
        keyboardType: keyboardType,
        autocorrect: true,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          labelText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
