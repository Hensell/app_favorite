import 'package:app_favorite/pages/home.dart';
import 'package:app_favorite/services/providers/provider/character_provider.dart';
import 'package:app_favorite/services/providers/provider/episode_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EpisodeProvider()),
        ChangeNotifierProvider(create: (_) => CharacterProvider()),
      ],
      child: MaterialApp(
          title: 'Rick and Morty',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xff0e94a2),
                brightness: Brightness.dark),
            useMaterial3: true,
          ),
          home: const Home()),
    );
  }
}
