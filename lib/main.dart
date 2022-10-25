import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod2_course/film.dart';
import 'package:riverpod2_course/provider_logger.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      child: const MyApp(),
    ),
  );
}

const allFilms = [
  Film(
    id: '1',
    title: 'Iron Man',
    description: 'Genius Billionaire Playboy',
    isFavorite: false,
  ),
  Film(
    id: '2',
    title: 'Fast 2 Furious',
    description: 'hehe boii',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'The Edge of Tomorrow',
    description: 'Time travel',
    isFavorite: false,
  ),
  Film(
    id: '4',
    title: '365 days',
    description: 'Will meet you in the hell',
    isFavorite: false,
  ),
];

final favoriteStatusProvider = StateProvider<FavoriteStatus>(
  (ref) => FavoriteStatus.all,
);

final filmsNotifierProvider = StateNotifierProvider<FilmNotifier, List<Film>>(
  (ref) => FilmNotifier(),
);

final filmsProvider = Provider<List<Film>>((ref) {
  final allFilms = ref.watch(filmsNotifierProvider);
  final favStatus = ref.watch(favoriteStatusProvider);
  switch (favStatus) {
    case FavoriteStatus.all:
      return allFilms;
    case FavoriteStatus.favorite:
      return allFilms.where((film) => film.isFavorite).toList();
    case FavoriteStatus.nonFavorite:
      return allFilms.where((film) => !film.isFavorite).toList();
  }
});

enum FavoriteStatus {
  all,
  favorite,
  nonFavorite,
}

class FilmNotifier extends StateNotifier<List<Film>> {
  FilmNotifier() : super(allFilms);

  void updateFilm({
    required Film film,
    required bool isFav,
  }) {
    state = state
        .map((f) => f.id == film.id ? f.copyWith(isFavorite: isFav) : f)
        .toList();
  }
}

// final favFilmsProvider = Provider<List<Film>>(
//   (ref) =>
//       ref.watch(allFilmsProvider).where((film) => film.isFavorite).toList(),
// );

// final nonFavFilmsProvider = Provider<List<Film>>(
//   (ref) =>
//       ref.watch(allFilmsProvider).where((film) => !film.isFavorite).toList(),
// );

class FilmsWidget extends ConsumerWidget {
  const FilmsWidget({
    super.key,
    // required this.provider,
  });

  // final AlwaysAliveProviderBase<Iterable<Film>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(filmsProvider);
    return Expanded(
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (BuildContext context, int index) {
          final film = films.elementAt(index);
          final favIcon = Icon(
            film.isFavorite ? Icons.favorite : Icons.favorite_border,
          );
          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
              onPressed: () {
                ref.read(filmsNotifierProvider.notifier).updateFilm(
                      film: film,
                      isFav: !film.isFavorite,
                    );
              },
              icon: favIcon,
            ),
          );
        },
      ),
    );
  }
}

class FilterWidget extends ConsumerWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton<FavoriteStatus>(
      value: ref.watch(favoriteStatusProvider),
      items: FavoriteStatus.values
          .map(
            (fs) => DropdownMenuItem(
              value: fs,
              child: Text(fs.name),
            ),
          )
          .toList(),
      onChanged: (newStatus) {
        if (newStatus != null) {
          ref.read(favoriteStatusProvider.state).state = newStatus;
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Films'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: const <Widget>[
            FilterWidget(),
            FilmsWidget(),
          ],
        ),
      ),
    );
  }
}
