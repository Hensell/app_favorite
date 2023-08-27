import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/providers/provider/episode_provider.dart';
import '../episode/episode_detail.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: Consumer<EpisodeProvider>(builder: (context, data, _) {
        return Wrap(
          children: List.generate(data.favorites.length, (index) {
            return cardEpisode(data, index);
          }),
        );
      }),
    );
  }

  cardEpisode(EpisodeProvider data, int index) {
    return Container(
      width: MediaQuery.of(context).size.width < 600
          ? (MediaQuery.of(context).size.width / 2) - 10
          : (MediaQuery.of(context).size.width / 4) - 10,
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
      decoration: const BoxDecoration(
        color: Colors.black54,
        image: DecorationImage(
            opacity: 0.3,
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover),
      ),
      child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EpisodeDetail(
                      episodeModel: data.favorites[index],
                    )));
          },
          title: Text(
            '${data.favorites[index].episodeCode} - ${data.favorites[index].name}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Text(
            data.favorites[index].airDate,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          trailing: IconButton(
              isSelected: false,
              onPressed: () {
                Provider.of<EpisodeProvider>(context, listen: false)
                    .deleteFavorite(data.favorites[index]);
              },
              icon: const Icon(Icons.favorite))),
    );
  }
}
