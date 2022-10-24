import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RiverPod2 Course',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

enum City {
  stockholm,
  paris,
  tokyo,
}

typedef WeatherEmoji = String;
Future<WeatherEmoji> getWeather(City city) async {
  await Future.delayed(const Duration(seconds: 1));
  return {
        City.stockholm: '❄',
        City.paris: '⛈',
        City.tokyo: '🌪',
      }[city] ??
      '🌅';
}

const unknownWeatherEmoji = '🤷';

// UI writes to and reads from this
final cityProvider = StateProvider<City?>((ref) {
  return null;
});

// UI reads this
final weatherProvider = FutureProvider<WeatherEmoji>((ref) async {
  final city = ref.watch(cityProvider);
  if (city == null) return unknownWeatherEmoji;
  return getWeather(city);
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('weather'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
            child: Center(
              child: Consumer(
                builder: (context, ref, child) {
                  final currentWeather = ref.watch(weatherProvider);
                  return currentWeather.when(
                    data: (weatherEmoji) => Text(
                      weatherEmoji,
                      style: const TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    error: (_, __) => const Text('Something wrong !!'),
                    loading: () => const Text('Loading...'),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) => ListView.builder(
                itemCount: City.values.length,
                itemBuilder: (BuildContext context, int index) {
                  final city = City.values[index];
                  final isSelected = ref.watch(cityProvider) == city;
                  return ListTile(
                    title: Text(City.values[index].name),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () {
                      ref.read(cityProvider.notifier).state = city;
                    },
                    selected: isSelected,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
