import 'package:flutter/material.dart';
import 'package:iamsmart/util/constants.dart';
import 'package:iamsmart/util/theme.dart';

class ExploreDetailScreen extends StatefulWidget {
  const ExploreDetailScreen({super.key, required this.exploreId});
  static const String exploreDetailRoute =
      '/mainContainer/explore/exploreDetail/:exploreId';
  final String exploreId;

  @override
  State<ExploreDetailScreen> createState() => _ExploreDetailScreenState();
}

class _ExploreDetailScreenState extends State<ExploreDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: getBody(),
    );
  }

  getBody() {
    return ListView(
      children: [
        Hero(
          tag: widget.exploreId,
          child: Image.asset(
            'assets/image/logo_bg_512.png',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          child: Text(
            'Some long long long long long long title ${widget.exploreId}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          child: Text(
            'Posted ${widget.exploreId} days ago',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2),
          child: Text(
            loremIpsum,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
