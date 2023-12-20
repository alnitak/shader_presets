// ignore_for_file: public_member_api_docs

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_preset_example/page1.dart';
import 'package:shader_preset_example/page2.dart';
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
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
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
  bool useImages = true;
  ValueNotifier<List<double>> floatUniforms = ValueNotifier([]);
  ValueNotifier<ShaderPresetsEnum> preset =
      ValueNotifier(ShaderPresetsEnum.raymarchedAurora);
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
                const Divider(),
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
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (!useImages) {
                          if (context.mounted) {
                            setState(() {
                              useImages = true;
                            });
                          }
                        }
                      },
                      child: const Text('use images'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (useImages) {
                          if (context.mounted) {
                            setState(() {
                              useImages = false;
                            });
                          }
                        }
                      },
                      child: const Text('use widgets'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget createPreset(ShaderPresetsEnum p) {
    Widget ret = const SizedBox.shrink();
    final dynamic child1 = useImages ? 'assets/flutter.png' : const Page1();
    final dynamic child2 = useImages ? 'assets/dash.png' : const Page2();
    switch (p) {
      case ShaderPresetsEnum.water:
        ret = ShaderPresetWater(
          child: child1,
          presetController: presetController,
        );
      case ShaderPresetsEnum.pageCurl:
        ret = ShaderPresetPageCurl(
          child1: child1,
          child2: child2,
          presetController: presetController,
        );
      case ShaderPresetsEnum.raymarchedAurora:
        ret = ShaderPresetRaymarchedAurora(
          presetController: presetController,
        );

      case ShaderPresetsEnum.cube:
        ret = ShaderPresetCube(
          child1: child1,
          child2: child2,
          presetController: presetController,
        );
      case ShaderPresetsEnum.polkaDotsCurtain:
        ret = ShaderPresetPolkaDotsCurtain(
          child1: child1,
          child2: child2,
          presetController: presetController,
        );
      case ShaderPresetsEnum.radial:
        ret = ShaderPresetRadial(
          child1: child1,
          child2: child2,
          presetController: presetController,
        );
      case ShaderPresetsEnum.flyeye:
        ret = ShaderPresetFlyeye(
          child1: child1,
          child2: child2,
          presetController: presetController,
        );
    }
    return ret;
  }

  Widget uniformSliders() {
    /// Get the preset min-max ranges and set its uniform to the starting range
    final uniforms = presetController.getDefaultUniforms(preset.value);

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
