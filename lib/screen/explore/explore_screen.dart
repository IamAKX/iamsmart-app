import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/screen/explore/explore_detail_screen.dart';

import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading(title: 'Explore'),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return Column(
      children: [
        CarouselSlider(
          items: [
            Image.asset(
              'assets/banner/banner1.png',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Image.asset(
              'assets/banner/banner2.jpeg',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Image.asset(
              'assets/banner/banner3.jpeg',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ],
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: true,
            autoPlay: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            enlargeFactor: 1,
            scrollDirection: Axis.horizontal,
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  title: Text(
                    'Some long long long long long long title $index',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  subtitle: Text(
                    '${index + 1} days ago',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  leading: Hero(
                    tag: '$index',
                    child: Image.asset(
                      'assets/image/logo_bg_512.png',
                      height: 80,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () => context.push(
                    ExploreDetailScreen.exploreDetailRoute
                        .replaceAll(':exploreId', '$index'),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.chevronRight,
                    size: 15,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  color: dividerColor,
                  indent: 120,
                );
              },
              itemCount: 10),
        ),
      ],
    );
  }
}
