import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_ui/boxes_view.dart';

import 'Boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());

  Boxes.initHive();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Hive UI",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        child: const Text("OPEN HIVE UI"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HiveBoxesView(
                    hiveBoxes: Boxes.allBoxes,
                    onError: (String errorMessage) => {print(errorMessage)})),
          );
        },
      ),
    );
  }
}
