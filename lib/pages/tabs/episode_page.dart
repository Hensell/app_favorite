import 'package:app_favorite/pages/episode/episode_detail.dart';
import 'package:app_favorite/services/providers/provider/episode_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodePage extends StatefulWidget {
  const EpisodePage({super.key});

  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Buscar"),
                onChanged: (value) {
                  if (value == '') {
                    Provider.of<EpisodeProvider>(context, listen: false)
                        .getEpisode(0);
                  } else {
                    Provider.of<EpisodeProvider>(context, listen: false)
                        .getEpisodebyName(value);
                  }
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  Provider.of<EpisodeProvider>(context, listen: false)
                      .getEpisode(-1);
                },
                icon: const Icon(Icons.arrow_back)),
            IconButton(
                onPressed: () {
                  Provider.of<EpisodeProvider>(context, listen: false)
                      .getEpisode(1);
                },
                icon: const Icon(Icons.arrow_forward)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<EpisodeProvider>(builder: (context, data, _) {
          if (data.notingToShow) {
            return const Center(
              child: Text("Sin resultados"),
            );
          }
          if (data.isLoading) {
            return const Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Wrap(
              children: List.generate(data.episodes.length, (index) {
                return cardEpisode(
                    data, index, data.episodes[index].isFavorite);
              }),
            );
          }
        }),
      ),
    );
  }

  cardEpisode(EpisodeProvider data, int index, bool isFavorite) {
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
                      episodeModel: data.episodes[index],
                    )));
          },
          title: Text(
            '${data.episodes[index].episodeCode} - ${data.episodes[index].name}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Text(
            data.episodes[index].airDate,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          trailing: IconButton(
              isSelected: data.episodes[index].isFavorite,
              selectedIcon: const Icon(Icons.favorite),
              onPressed: () {
                Provider.of<EpisodeProvider>(context, listen: false)
                    .toggleFavorite(data.episodes[index]);
              },
              icon: const Icon(
                Icons.favorite_border,
              ))),
    );
  }
}
