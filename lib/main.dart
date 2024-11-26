import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

//Breakpoint of two screensizes
class Breakpoints {
  static const sm = 420;
  static const md = 740;
}

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  Get.lazyPut<HeadacheController>(() => HeadacheController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      //navigation to the different pages
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/statistics/:username', page: () => StatisticsScreen()),
        GetPage(name: '/changeName', page: () => ChangeNameScreen()),
        GetPage(name: '/grid', page: () => GridScreen()),
      ],
    );
  }
}


class HeadacheController {
  final storage = Hive.box("storage");
  final entries = <dynamic>[].obs;
  final userName = ''.obs;

  HeadacheController() {
    List<dynamic> storedEntries = storage.get('entries', defaultValue: []);
    entries.addAll(storedEntries);

    String storedName = storage.get('userName', defaultValue: 'Guest');
    userName.value = storedName;
  }

  void updateEntries(String entry) {
    entries.add(entry);
    storage.put('entries', entries);
  }

  void updateName(String name) {
    userName.value = name;
    storage.put('userName', name);
  }

  Map<String, int> calculateFrequency() {
    Map<String, int> frequency = {};
    for (var entry in entries) {
      String level = entry.split(' ').last;
      frequency[level] = (frequency[level] ?? 0) + 1;
    }
    return frequency;
  }

  double calculateAverage() {
    List<int> levels = entries.map((e) => int.tryParse(e.split(' ').last) ?? 0).toList();
    if (levels.isEmpty) return 0;
    return levels.reduce((a, b) => a + b) / levels.length;
  }
}

class HomeScreen extends StatelessWidget {
  final headacheController = Get.find<HeadacheController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Obx(() {
        final lastEntry = headacheController.entries.isNotEmpty
            ? headacheController.entries.last
            : "No data yet";

        return Column(
          children: [
            ListTile(
              title: Text("Welcome ${headacheController.userName.value}"),
              subtitle: Text("Last entry: $lastEntry"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed('/changeName'),
              child: Text("Change your name"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed('/grid'),
              child: Text("Add a headache"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed('/statistics/${headacheController.userName.value}'),
              child: Text("Statistics"),
            ),
          ],
        );
      }),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  final headacheController = Get.find<HeadacheController>();

  @override
  Widget build(BuildContext context) {
    // Extract the username from the path variable to be able to add it on other places
    final username = Get.parameters['username'] ?? 'Guest';
    final stats = headacheController.calculateFrequency();
    final average = headacheController.calculateAverage();

    return Scaffold(
      appBar: AppBar(title: Text('Statistics for $username')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Statistics for $username', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Average Headache Level: ${average.toStringAsFixed(2)}'),
            SizedBox(height: 10),
            ...stats.entries.map((e) => Text('Level ${e.key}: ${e.value} times')).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeNameScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final headacheController = Get.find<HeadacheController>();

  _saveContent() {
    if (_formKey.currentState!.saveAndValidate()) {
      final newName = _formKey.currentState!.value['name'];
      headacheController.updateName(newName);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Name')),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              initialValue: headacheController.userName.value,
              decoration: InputDecoration(labelText: 'Edit name'),
              validator: FormBuilderValidators.required(),
            ),
            ElevatedButton(
              onPressed: _saveContent,
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

class GridScreen extends StatefulWidget {
  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final headacheController = Get.find<HeadacheController>();

  bool level0Value = false;
  bool level1Value = false;
  bool level2Value = false;
  bool level3Value = false;

  _saveContent() {
    if (_formKey.currentState!.saveAndValidate()) {
      String lastHeadache;

      if (level0Value) {
        lastHeadache = '0';
      } else if (level1Value) {
        lastHeadache = '1';
      } else if (level2Value) {
        lastHeadache = '2';
      } else if (level3Value) {
        lastHeadache = '3';
      } else {
        lastHeadache = 'No headache level selected';
      }

      headacheController.updateEntries('Your last headache was level: $lastHeadache');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //Make the page responsive by adding a breakpoint
    int crossAxisCount = screenWidth > Breakpoints.md ? 2 : 1;

    return Scaffold(
      appBar: AppBar(title: Text('Add a headache')),
      body: FormBuilder(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: crossAxisCount,
                childAspectRatio: 5,
                children: [
                  FormBuilderCheckbox(
                    name: 'level0',
                    initialValue: level0Value,
                    title: Text("Level 0"),
                    onChanged: (val) {
                      setState(() {
                        level0Value = val ?? false;
                      });
                    },
                  ),
                  FormBuilderCheckbox(
                    name: 'level1',
                    initialValue: level1Value,
                    title: Text("Level 1"),
                    onChanged: (val) {
                      setState(() {
                        level1Value = val ?? false;
                      });
                    },
                  ),
                  FormBuilderCheckbox(
                    name: 'level2',
                    initialValue: level2Value,
                    title: Text("Level 2"),
                    onChanged: (val) {
                      setState(() {
                        level2Value = val ?? false;
                      });
                    },
                  ),
                  FormBuilderCheckbox(
                    name: 'level3',
                    initialValue: level3Value,
                    title: Text("Level 3"),
                    onChanged: (val) {
                      setState(() {
                        level3Value = val ?? false;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _saveContent,
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
