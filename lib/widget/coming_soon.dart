import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iamsmart/util/colors.dart';
import 'package:iamsmart/util/theme.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/undraw_under_construction_-46-pa.svg',
            width: 150,
            height: 150,
          ),
          const SizedBox(
            height: defaultPadding,
          ),
          Text(
            'Coming Soon',
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: primaryColor),
          ),
          Text(
            'This feature is under development',
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(color: textColorLight),
          ),
        ],
      ),
    );
  }
}
