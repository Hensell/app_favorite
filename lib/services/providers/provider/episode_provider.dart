import 'dart:convert';

import 'package:app_favorite/services/models/episode_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const url = "https://rickandmortyapi.com/api/episode";

class EpisodeProvider with ChangeNotifier {
  List<EpisodeModel> _episodes = [];
  List<EpisodeModel> get episodes => _episodes;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int _selectedPage = 1;
  int get selectedPage => _selectedPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  Future getEpisode(int page) async {
    if ((_selectedPage + page) > 0 &&
        (_selectedPage + page) < _totalPages + 1) {
      _selectedPage = page + _selectedPage;

      final response = await http.get(Uri.parse('$url?page=$_selectedPage'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> episodeList = jsonData['results'];

        _episodes = episodeList
            .map((episodeData) => EpisodeModel.fromJson(episodeData))
            .toList();

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
      _isLoading = false;
      notifyListeners();
    }
  }
}
