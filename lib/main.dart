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
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

extension AddisonTools<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow == null) return null;
    return shadow + (other ?? 0) as T;
  }
}

class CounterNotifier extends StateNotifier<int?> {
  CounterNotifier() : super(null);
  void increment() => state = (state == null ? 1 : state + 1);
}

final counterProvider = StateNotifierProvider<CounterNotifier, int?>(
  (ref) => CounterNotifier(),
);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final counter = ref.watch(counterProvider);
            final text = counter?.toString() ?? 'Press the button';
            return Text(
              text,
              style: Theme.of(context).textTheme.headline3,
            );
          },
        ),
        centerTitle: true,
      ),
      body: Center(
        child: TextButton.icon(
          onPressed: ref.read(counterProvider.notifier).increment,
          icon: const Icon(Icons.add),
          label: const Text(
            'add',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
