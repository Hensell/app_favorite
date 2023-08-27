import 'dart:convert';

import 'package:app_favorite/services/models/episode_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../database/sembast_provider.dart';

const url = "https://rickandmortyapi.com/api/episode";

class EpisodeProvider with ChangeNotifier {
  List<EpisodeModel> _episodes = [];
  List<EpisodeModel> get episodes => _episodes;

  List<EpisodeModel> _favorites = [];
  List<EpisodeModel> get favorites => _favorites;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _notingToShow = false;
  bool get notingToShow => _notingToShow;

  int _selectedPage = 1;
  int get selectedPage => _selectedPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  late SembastProvider db;
  EpisodeProvider() {
    db = SembastProvider();
    db.init();
    _init();
  }

  Future<void> _init() async {
    final response = await http.get(Uri.parse('$url?page=$_selectedPage'));
    final favoriteEpisodes = await db.getFavorites();
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> episodeList = jsonData['results'];

      _episodes = episodeList
          .map((episodeData) => EpisodeModel.fromJson(episodeData))
          .toList();

      _isLoading = false;
      _totalPages = jsonData['info']['pages'];
      if (favoriteEpisodes.isNotEmpty) {
        for (final episode in _episodes) {
          episode.isFavorite = !favoriteEpisodes
              .any((favEpisode) => favEpisode.id == episode.id);
        }
      }
      getAllFavorites();
      notifyListeners();
    } else {
      _isLoading = false;
      getAllFavorites();
      notifyListeners();
    }
  }

  Future getEpisode(int page) async {
    _notingToShow = false;
    if ((_selectedPage + page) > 0 &&
        (_selectedPage + page) < _totalPages + 1) {
      _selectedPage = page + _selectedPage;
      final favoriteEpisodes = await db.getFavorites();
      final response = await http.get(Uri.parse('$url?page=$_selectedPage'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> episodeList = jsonData['results'];

        _episodes = episodeList
            .map((episodeData) => EpisodeModel.fromJson(episodeData))
            .toList();

        for (final episode in _episodes) {
          episode.isFavorite =
              favoriteEpisodes.any((favEpisode) => favEpisode.id == episode.id);
        }
        _isLoading = false;
        _totalPages = jsonData['info']['pages'];
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future getEpisodebyName(String name) async {
    _isLoading = true;
    final response = await http.get(Uri.parse('$url/?name=$name'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> episodeList = jsonData['results'];

      _episodes = episodeList
          .map((episodeData) => EpisodeModel.fromJson(episodeData))
          .toList();
      _isLoading = false;
      notifyListeners();
    } else {
      _notingToShow = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(EpisodeModel episodeModel) async {
    if (!episodeModel.isFavorite) {
      await db.insertFavorite(episodeModel);
    } else {
      await db.deleteFavorite(episodeModel);
    }
    episodeModel.isFavorite = !episodeModel.isFavorite;
    getAllFavorites();
    notifyListeners();
  }

  Future<void> deleteFavorite(EpisodeModel episodeModel) async {
    await db.deleteFavorite(episodeModel);
    await getAllFavorites();
    for (final episode in _episodes) {
      episode.isFavorite =
          _favorites.any((favEpisode) => favEpisode.id == episode.id);
    }

    notifyListeners();
  }

  Future<void> getAllFavorites() async {
    final favoriteEpisodes = await db.getFavorites();
    _favorites.clear();
    _favorites = favoriteEpisodes;
  }
}
