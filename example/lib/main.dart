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
  ValueNotifier<List<double>> floatUniforms = ValueNotifier([]);
  ValueNotifier<ShaderPresetsEnum> preset =
      ValueNotifier(ShaderPresetsEnum.water);
  final presetController = ShaderPresetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Shader Presets demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ValueListenableBuilder(
          valueListenable: preset,
          builder: (_, p, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // width: 600,
                  // height: 700,
                  child: createPreset(p),
                ),
                const SizedBox(height: 16),
                Wrap(
                  children: List.generate(
                    ShaderPresetsEnum.values.length,
                    (index) {
                      return ElevatedButton(
                        onPressed: () {
                          preset.value = ShaderPresetsEnum.values[index];
                        },
                        child: Text(ShaderPresetsEnum.values[index].name),
                      );
                    },
                  ),
                ),
                uniformSliders(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget createPreset(ShaderPresetsEnum p) {
    Widget ret = const SizedBox.shrink();
    switch (p) {
      case ShaderPresetsEnum.water:
        ret = ShaderPresetWater(
          child: 'assets/flutter.png',
          presetController: presetController,
        );
      case ShaderPresetsEnum.pageCurl:
        ret = ShaderPresetPageCurl(
          child1: 'assets/flutter.png',
          child2: 'assets/dash.png',
          presetController: presetController,
        );
      case ShaderPresetsEnum.cube:
        ret = ShaderPresetCube(
          child1: 'assets/flutter.png',
          child2: 'assets/dash.png',
          presetController: presetController,
        );
      case ShaderPresetsEnum.polkaDotsCurtain:
        ret = ShaderPresetPolkaDotsCurtain(
          child1: 'assets/flutter.png',
          child2: 'assets/dash.png',
          presetController: presetController,
        );
      case ShaderPresetsEnum.radial:
        ret = ShaderPresetRadial(
          child1: 'assets/flutter.png',
          child2: 'assets/dash.png',
          presetController: presetController,
        );
      case ShaderPresetsEnum.flyeye:
        ret = ShaderPresetFlyeye(
          child1: 'assets/flutter.png',
          child2: 'assets/dash.png',
          presetController: presetController,
        );
    }
    return ret;
  }

  Widget uniformSliders() {
    /// Get the preset min-max ranges and set its uniform to the starting range
    final uniforms = presetController.getUniforms(preset.value);

    /// Build the uniforms list
    floatUniforms = ValueNotifier(
      List.generate(uniforms.uniforms.length, (index) {
        return uniforms.uniforms[index].value;
      }),
    );

    /// Build slider for each uniforms
    return ValueListenableBuilder(
      valueListenable: floatUniforms,
      builder: (_, uniform, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            uniforms.uniforms.length,
            (index) {
              return Flex(
                direction: Axis.horizontal,
                children: [
                  Text('${uniforms.uniforms[index].name} \t\t'
                      '${uniform[index].toStringAsFixed(2)}'),
                  Expanded(
                    child: Slider(
                      value: uniform[index],
                      min: uniforms.uniforms[index].range.start,
                      max: uniforms.uniforms[index].range.end,
                      onChanged: (value) {
                        floatUniforms.value[index] = value;
                        floatUniforms.value = floatUniforms.value.toList();
                        presetController.setUniforms(floatUniforms.value);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
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
