import 'package:app_favorite/pages/tabs/episode_page.dart';
import 'package:app_favorite/pages/tabs/favorite_page.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(children: [EpisodePage(), FavoritePage()]),
          bottomNavigationBar: TabBar(tabs: [
            Tab(icon: Icon(Icons.tv)),
            Tab(
              icon: Icon(Icons.favorite),
            )
          ]),
        ));
  }
}
