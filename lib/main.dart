import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

const names = [
  'Talia',
  'Lyla',
  'Billie',
  'Lila',
  'Lance',
  'Noemy',
  'Malika',
  'Emmanuel',
  'Shaniya',
  'Maverick',
  'Charley',
];

final tickerProvider = StreamProvider<int>(
  (ref) => Stream.periodic(
    const Duration(seconds: 1),
    (computationCount) => computationCount + 1,
  ),
);

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.stream).map(
        (i) => names.getRange(0, i),
      ),
);

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
        title: const Text('HomePage'),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final names = ref.watch(namesProvider);
          return names.when(
            data: (names) => ListView.builder(
              itemCount: names.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(names.elementAt(index));
              },
            ),
            error: (_, __) => const Text('Reached end of list'),
            loading: () => const Text('Loading...'),
          );
        },
      ),
    );
  }
}
