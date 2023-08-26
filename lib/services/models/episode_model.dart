class EpisodeModel {
  final int id;
  final String name;
  final String airDate;
  final String episodeCode;
  final List<String> characters;
  final String url;
  final String created;
  final bool isFavorite;

  EpisodeModel(
      {required this.id,
      required this.name,
      required this.airDate,
      required this.episodeCode,
      required this.characters,
      required this.url,
      required this.created,
      this.isFavorite = false});

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'],
      name: json['name'],
      airDate: json['air_date'],
      episodeCode: json['episode'],
      characters: List<String>.from(json['characters']),
      url: json['url'],
      created: json['created'],
    );
  }
}
