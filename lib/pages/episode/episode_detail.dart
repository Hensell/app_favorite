import 'package:app_favorite/services/models/episode_model.dart';
import 'package:app_favorite/services/providers/provider/character_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EpisodeDetail extends StatefulWidget {
  const EpisodeDetail({super.key, required this.episodeModel});
  final EpisodeModel episodeModel;

  @override
  State<EpisodeDetail> createState() => _EpisodeDetailState();
}

class _EpisodeDetailState extends State<EpisodeDetail> {
  @override
  void initState() {
    Provider.of<CharacterProvider>(context, listen: false)
        .getMultipleCharacter(widget.episodeModel.characters);
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.episodeModel.episodeCode} ${widget.episodeModel.name}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<CharacterProvider>(builder: (context, data, _) {
            if (data.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 130,
                  child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: List.generate(data.characters.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundImage:
                                    NetworkImage(data.characters[index].image),
                              ),
                              Text(data.characters[index].name.length < 12
                                  ? data.characters[index].name
                                  : '${data.characters[index].name.substring(0, 11)}...')
                            ],
                          ),
                        );
                      })),
                ),
              );
            }
          }),
          Text(
            'Air date: ${widget.episodeModel.airDate}',
          ),
          Text(
            'URL: ${widget.episodeModel.url}',
          ),
          Text(
            'Create: ${widget.episodeModel.created}',
          ),
        ],
      ),
    );
  }
}
