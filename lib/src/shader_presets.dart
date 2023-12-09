// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';

enum ShaderPresetsEnum {
  water,
  polkaDotsCurtain,
}

class Uniform {
  Uniform({
    required this.name,
    required this.range,
    required this.defaultValue,
    required this.value,
  });
  RangeValues range;
  double defaultValue;
  String name;
  double value;
}

class Uniforms {
  Uniforms(this.uniforms);

  final List<Uniform> uniforms;

  void setValue(String name, double value) {
    uniforms.firstWhere((element) => element.name == name).value = value;
  }

  double getValue(String name) {
    return uniforms.firstWhere((element) => element.name == name).value;
  }
}

///
class ShaderPresetController {
  void Function(dynamic uniforms)? _setUniforms;

  void _setController(
    void Function(dynamic uniforms) setUniforms,
  ) {
    _setUniforms = setUniforms;
  }

  void setUniforms(dynamic uniforms) => _setUniforms?.call(uniforms);

  /// Get the preset uniforms
  Uniforms getUniforms(ShaderPresetsEnum preset) {
    switch (preset) {
      case ShaderPresetsEnum.water:
        return Uniforms([
          Uniform(
            name: 'speed',
            range: const RangeValues(0, 1),
            defaultValue: 0.2,
            value: 0.2,
          ),
          Uniform(
            name: 'frequency',
            range: const RangeValues(0, 20),
            defaultValue: 8,
            value: 8,
          ),
          Uniform(
            name: 'amplitude',
            range: const RangeValues(0, 5),
            defaultValue: 1,
            value: 1,
          ), //
        ]);
      case ShaderPresetsEnum.polkaDotsCurtain:
        return Uniforms([
          Uniform(
            name: 'progress',
            range: const RangeValues(0, 1),
            defaultValue: 0,
            value: 0,
          ),
          Uniform(
            name: 'dots',
            range: const RangeValues(2, 80),
            defaultValue: 20,
            value: 20,
          ),
          Uniform(
            name: 'centerX',
            range: const RangeValues(0, 1),
            defaultValue: 0.5,
            value: 0.5,
          ),
          Uniform(
            name: 'centerY',
            range: const RangeValues(0, 1),
            defaultValue: 0.5,
            value: 0.5,
          ),
        ]);
    }
  }
}

/// In case of using a preset with multiple childs, they must have
/// the same size otherwise some of them will be stretched
class ShaderPreset extends StatelessWidget {
  ShaderPreset._({
    required this.mainImage,
    required this.controller,
    this.presetController,
    this.buffers,
    this.startPaused = false,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    super.key,
  });

  /// Sets the uniform values for the current preset.
  /// Accepts a [Uniforms] or [List<double>] param.
  void _setUniforms(dynamic uniforms) {
    assert(
      uniforms is Uniforms || uniforms is List<double>,
      'Please use [Uniforms] or [List<double>]!',
    );
    var newUniforms = <double>[];
    switch (preset) {
      case ShaderPresetsEnum.water:
        assert(
          uniforms is List<Object> && uniforms.length == 3,
          'Water preset only accepts 3 uniforms!',
        );
        if (uniforms is Uniforms) {
          newUniforms = List.generate(
            uniforms.uniforms.length,
            (index) => uniforms.uniforms[index].value,
          );
        }
        if (uniforms is List<double>) {
          for (var i = 0; i < uniforms.length; i++) {
            this.uniforms.uniforms[i].value = uniforms[i];
          }
          newUniforms = uniforms;
        }

      case ShaderPresetsEnum.polkaDotsCurtain:
        assert(
          uniforms is List<double> && uniforms.length == 4,
          'PolkaDotsCurtainUniforms preset only accepts 4 uniforms!',
        );
        if (uniforms is Uniforms) {
          newUniforms = List.generate(uniforms.uniforms.length,
              (index) => uniforms.uniforms[index].value);
        }
        if (uniforms is List<double>) newUniforms = uniforms;
    }
    mainImage.floatUniforms = newUniforms;
  }

  /// Polka Dots Curtain shader
  factory ShaderPreset.polkaDotsCurtain(
    dynamic child1,
    dynamic child2, {
    Key? key,
    ShaderPresetController? presetController,
    double progress = 0,
    double dots = 20,
    double centerX = 0.5,
    double centerY = 0.5,
  }) {
    assert(
      child1 is Widget ||
          child1 is String ||
          child2 is Widget ||
          child2 is String,
      "Childs can be of type Widget or String('assets/texture/path') only.",
    );

    final main = LayerBuffer(
      shaderAssetsName:
          'packages/shader_presets/assets/shaders/gl_transitions/polka_dots_curtain.frag',
      floatUniforms: [progress, dots, centerX, centerY],
    )..setChannels([
        IChannel(
          child: child1 is Widget ? child1 : null,
          assetsTexturePath: child1 is String ? child1 : null,
        ),
        IChannel(
          child: child2 is Widget ? child2 : null,
          assetsTexturePath: child2 is String ? child2 : null,
        ),
      ]);

    presetController ??= ShaderPresetController();
    final uniforms =
        presetController.getUniforms(ShaderPresetsEnum.polkaDotsCurtain)
          ..setValue('progress', progress)
          ..setValue('dots', dots)
          ..setValue('centerX', centerX)
          ..setValue('centerY', centerY);

    return ShaderPreset._(
      key: key,
      mainImage: main,
      controller: ShaderBuffersController(),
      presetController: presetController,
    )
      ..preset = ShaderPresetsEnum.polkaDotsCurtain
      ..uniforms = uniforms;
  }

  /// Water shader
  factory ShaderPreset.water(
    dynamic child, {
    Key? key,
    ShaderPresetController? presetController,
    double speed = 0.2,
    double frequency = 8,
    double amplitude = 1,
  }) {
    assert(
      child is Widget || child is String,
      "Child can be of type Widget or String('assets/texture/path') only",
    );

    final main = LayerBuffer(
      shaderAssetsName: 'packages/shader_presets/assets/shaders/water.frag',
      floatUniforms: [speed, frequency, amplitude],
    )..setChannels([
        IChannel(
          child: child is Widget ? child : null,
          assetsTexturePath: child is String ? child : null,
        ),
      ]);

    presetController ??= ShaderPresetController();
    final uniforms = presetController.getUniforms(ShaderPresetsEnum.water)
      ..setValue('speed', speed)
      ..setValue('frequency', frequency)
      ..setValue('amplitude', amplitude);

    return ShaderPreset._(
      key: key,
      mainImage: main,
      controller: ShaderBuffersController(),
      presetController: presetController,
    )
      ..preset = ShaderPresetsEnum.water
      ..uniforms = uniforms;
  }

  /// Page curl.
  /// [radius] radius of the curl.
  // factory ShaderPreset.pageCurl(
  //   dynamic child1,
  //   dynamic child2, {
  //   Key? key,
  //   double radius = 0.1,
  // }) {
  //   assert(
  //     child1 is Widget ||
  //         child1 is String ||
  //         child2 is Widget ||
  //         child2 is String,
  //     'childs can be of type Widget or String only',
  //   );
  //   final main = LayerBuffer(
  //     shaderAssetsName: 'packages/shader_presets/assets/shaders/page_curl.frag',
  //     floatUniforms: [radius],
  //   )..setChannels([
  //       IChannel(
  //         child: child2 is Widget ? child2 : null,
  //         assetsTexturePath: child2 is String ? child2 : null,
  //       ),
  //       IChannel(
  //         child: child1 is Widget ? child1 : null,
  //         assetsTexturePath: child1 is String ? child1 : null,
  //       ),
  //     ]);
  //   final ctrl = ShaderBuffersController();
  //
  //   /// swap children when moving to the leff edge
  //   ctrl.addConditionalOperation(
  //     (
  //       layerBuffer: main,
  //       param: Param.iMouseXNormalized,
  //       checkType: CheckOperator.minor,
  //       checkValue: 0.1,
  //       operation: (result) {
  //         if (result) {
  //           main.swapChannels(0, 1);
  //           ctrl
  //             ..pause()
  //             ..rewind();
  //         }
  //       },
  //     ),
  //   );
  //
  //   return ShaderPreset._(
  //     key: key,
  //     startPaused: true,
  //     mainImage: main,
  //     controller: ctrl,
  //     onPointerDown: (position) {
  //       ctrl.play();
  //     },
  //     onPointerUp: (position) {
  //       ctrl
  //         ..pause()
  //         ..rewind();
  //     },
  //   )
  //   ..usingPrest = ShaderPresetsEnum.pageCurl;
  // }

  final bool startPaused;
  final LayerBuffer mainImage;
  final List<LayerBuffer>? buffers;
  final ShaderBuffersController? controller;
  final void Function(Offset position)? onPointerDown;
  final void Function(Offset position)? onPointerMove;
  final void Function(Offset position)? onPointerUp;
  final ShaderPresetController? presetController;

  late ShaderPresetsEnum preset;
  late Uniforms uniforms;

  @override
  Widget build(BuildContext context) {
    presetController!._setController(_setUniforms);

    return ShaderBuffers(
      controller: controller,
      mainImage: mainImage,
      buffers: buffers,
      startPaused: startPaused,
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
    );
  }
}
