import 'dart:async';
import 'dart:io';
import 'package:app_favorite/services/models/episode_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastProvider {
  DatabaseFactory dbFactory = kIsWeb ? databaseFactoryWeb : databaseFactoryIo;
  late Database _db;

  final _store = intMapStoreFactory.store("favorite");
  static final SembastProvider _singleton = SembastProvider._internal();
  final List<EpisodeModel> _noteModel = [];
  List<EpisodeModel> get noteModel => _noteModel;

  SembastProvider._internal();

  factory SembastProvider() {
    return _singleton;
  }

  Future<Database> init() async {
    _db = await _openDb();
    return _db;
  }

  Future _openDb() async {
    var dbPath = "";
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        final docsDir = await getApplicationDocumentsDirectory();
        dbPath = join(docsDir.path, "favorite.db");
      } else {
        dbPath = join("favorite.db");
      }
    } else {
      dbPath = join("favorite.db");
    }

    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future<void> insertFavorite(EpisodeModel episode) async {
    await _store.record(episode.id).put(_db, episode.toMap());
  }

  Future<void> deleteFavorite(EpisodeModel episodeModel) async {
    final finder = Finder(filter: Filter.byKey(episodeModel.id));

    await _store.delete(_db, finder: finder);
  }

  Future<List<EpisodeModel>> getFavorites() async {
    final finder = Finder(sortOrders: [SortOrder(Field.key)]);
    final snapshots = await _store.find(_db, finder: finder);

    return snapshots.map((snapshot) {
      final episodeMap = snapshot.value;
      return EpisodeModel.fromMap(episodeMap);
    }).toList();
  }
}
  /* Future getNotes(String filter) async {
    await init();
    final finder = Finder(
        filter: Filter.custom((record) => record['title']!
            .toString()
            .toLowerCase()
            .contains(filter.toLowerCase())),
        sortOrders: [SortOrder(Field.key, false)]);
    final snapshot = await store.find(_db, finder: finder);
    return snapshot.map((item) {
      final pwd = EpisodeModel.fromMap(item.value);
      pwd.id = item.key;
      return pwd;
    }).toList();
  }*/

/*  Future updateNotes(EpisodeModel em) async {
    final finder = Finder(filter: Filter.byKey(em.id));
    await store.update(_db, em.toMap(), finder: finder);
    //  notifyListeners();
  }

  /* Future searchNotes(NoteModel nm) async {
    final finder = Finder(filter: Filter.byKey(nm.id));
    await store.update(_db, nm.toMap(), finder: finder);
    notifyListeners();
  }

  Future deleteNote(NoteModel nm) async {
    final finder = Finder(filter: Filter.byKey(nm.id));
    await store.delete(_db, finder: finder);

  }*/

  Future deleteAll() async {
    await store.delete(_db);
    //   notifyListeners();
  }
}
*/