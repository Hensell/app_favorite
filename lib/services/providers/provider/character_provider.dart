import 'dart:convert';

import 'package:app_favorite/services/models/character_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const url = "https://rickandmortyapi.com/api/character";

class CharacterProvider with ChangeNotifier {
  List<CharacterModel> _characters = [];
  List<CharacterModel> get characters => _characters;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future getMultipleCharacter(List<String> idsList) async {
    final ids = idsList.map((url) => extractIdFromUrl(url)).toList();
    final response = await http.get(Uri.parse('$url/$ids'));
    if (response.statusCode == 200) {
      final List<dynamic> characterJsonList = json.decode(response.body);
      _characters = characterJsonList
          .map((characterJson) => CharacterModel.fromJson(characterJson))
          .toList();
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  int extractIdFromUrl(String url) {
    final uri = Uri.parse(url);
    final id = uri.pathSegments.last;
    return int.tryParse(id) ?? -1;
  }
}
