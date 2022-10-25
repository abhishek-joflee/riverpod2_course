import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod2_course/person.dart';
import 'package:riverpod2_course/provider_logger.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      child: const MyApp(),
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

final personsProvider = ChangeNotifierProvider(
  (ref) {
    return PersonDataModel();
  },
  name: 'personsProvider',
);

final nameTextController = TextEditingController();
final ageTextController = TextEditingController();

Future<Person?> createOrUpdateDialog(
  BuildContext context, {
  Person? existingPerson,
}) async {
  nameTextController.text = existingPerson?.name ?? '';
  ageTextController.text = existingPerson?.age.toString() ?? '';

  return showDialog<Person?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create a Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: nameTextController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: ageTextController,
              decoration: const InputDecoration(
                labelText: 'Age',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameTextController.text;
              final age = ageTextController.text;
              if (name.isEmpty || age.isEmpty) {
                Navigator.pop(context);
                return;
              }
              Navigator.pop(
                context,
                Person(
                  uuid: existingPerson?.uuid,
                  name: name,
                  age: int.tryParse(age) ?? 0,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final persons = ref.watch(personsProvider).persons;
          return ListView.builder(
            itemCount: persons.length,
            itemBuilder: (BuildContext context, int index) {
              final p = persons[index];
              return ListTile(
                title: Text(p.displayName),
                onTap: () async {
                  final updatePerson = await createOrUpdateDialog(
                    context,
                    existingPerson: p,
                  );
                  print(updatePerson.toString());
                  if (updatePerson != null) {
                    ref.read(personsProvider).update(updatePerson);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final createdPerson = await createOrUpdateDialog(context);
          if (createdPerson != null) {
            ref.read(personsProvider).add(createdPerson);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
