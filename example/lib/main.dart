// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:shader_presets/shader_presets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shader Preset demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Shader Presets demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ShaderPreset.pageCurl(
            const Widget1(),
            const Widget2(),
          ),
        ),
      ),
    );
  }
}

class Widget1 extends StatelessWidget {
  const Widget1({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.account_circle, size: 42),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Widget 1',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Text('shader_preset'),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                print('Widget 1');
              },
              child: const Text('Widget 1'),
            ),
            const Icon(Icons.add_box_rounded, size: 42),
          ],
        ),
      ),
    );
  }
}

class Widget2 extends StatelessWidget {
  const Widget2({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow[100],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.ac_unit, color: Colors.red, size: 42),
            const SizedBox(width: 16),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Widget 2',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Text('shader_preset'),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                print('Widget 2');
              },
              child: const Text('Widget 2'),
            ),
            const Spacer(),
            const Icon(Icons.delete_forever, color: Colors.red, size: 42),
          ],
        ),
      ),
    );
  }
}
