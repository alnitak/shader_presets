// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';

enum ShaderPresetsEnum {
  water,
  pageCurl,
  polkaDotsCurtain,
  radial,
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
  ShaderController Function()? _getShaderController;

  void _setController(
    void Function(dynamic uniforms) setUniforms,
    ShaderController Function() getShaderController,
  ) {
    _setUniforms = setUniforms;
    _getShaderController = getShaderController;
  }

  void setUniforms(dynamic uniforms) => _setUniforms?.call(uniforms);

  ShaderController? getShaderController() => _getShaderController?.call();

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
      case ShaderPresetsEnum.pageCurl:
        return Uniforms([
          Uniform(
            name: 'radius',
            range: const RangeValues(0, 1),
            defaultValue: 0.1,
            value: 0.1,
          ),
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
      case ShaderPresetsEnum.radial:
        return Uniforms([
          Uniform(
            name: 'progress',
            range: const RangeValues(0, 1),
            defaultValue: 0,
            value: 0,
          ),
          Uniform(
            name: 'smoothness',
            range: const RangeValues(0, 3),
            defaultValue: 1,
            value: 1,
          ),
        ]);
    }
  }
}

/// In case of using a preset with multiple childs, they must have
/// the same size otherwise some of them will be stretched
class ShaderPreset extends StatelessWidget {
  ShaderPreset._({
    required this.shaderController,
    this.presetController,
    this.buffers,
    this.startPaused = false,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    super.key,
  });

  ShaderController _getShaderController() {
    return shaderController;
  }

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

      case ShaderPresetsEnum.pageCurl:
        assert(
          uniforms is List<Object> && uniforms.length == 1,
          'Water preset only accepts 1 uniforms!',
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

      case ShaderPresetsEnum.radial:
        assert(
          uniforms is List<double> && uniforms.length == 2,
          'Radial preset only accepts 2 uniforms!',
        );
        if (uniforms is Uniforms) {
          newUniforms = List.generate(uniforms.uniforms.length,
              (index) => uniforms.uniforms[index].value);
        }
        if (uniforms is List<double>) newUniforms = uniforms;
    }
    mainImage.floatUniforms = newUniforms;
  }

  /// Common factory to rule them all
  factory ShaderPreset._common(
    Key? key,
    String frag,
    ShaderPresetsEnum presetType,
    List<dynamic> childs,
    List<(String name, double value)> uValues,
    ShaderPresetController? presetController, {
    void Function(ShaderController controller, Offset position)? onPointerDown,
    void Function(ShaderController controller, Offset position)? onPointerMove,
    void Function(ShaderController controller, Offset position)? onPointerUp,
  }) {
    /// Check [childs]
    var a = true;
    for (final child in childs) {
      a |= child is Widget || child is String;
    }
    assert(a, "Child(s) can be of type Widget or String('assets/path') only");

    /// create layer
    final main = LayerBuffer(
      shaderAssetsName: frag,
      floatUniforms:
          List.generate(uValues.length, (index) => uValues[index].$2),
    )..setChannels(
        List.generate(
          childs.length,
          (index) => IChannel(
            child: childs[index] is Widget ? childs[index] as Widget : null,
            assetsTexturePath:
                childs[index] is String ? childs[index] as String : null,
          ),
        ),
      );

    /// Set user uniforms
    final controller = presetController ?? ShaderPresetController();
    final u = controller.getUniforms(presetType);
    for (final uniform in uValues) {
      u.setValue(uniform.$1, uniform.$2);
    }

    return ShaderPreset._(
      key: key,
      shaderController: ShaderController(),
      presetController: presetController,
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
    )
      ..preset = presetType
      ..uniforms = u
      ..mainImage = main;
  }

  ////////////////////////////////////////
  /// ShaderToy shaders
  ////////////////////////////////////////
  ///
  /// Water shader
  factory ShaderPreset.water(
    dynamic child, {
    Key? key,
    ShaderPresetController? presetController,
    double speed = 0.2,
    double frequency = 8,
    double amplitude = 1,
  }) {
    return ShaderPreset._common(
      key,
      'packages/shader_presets/assets/shaders/water.frag',
      ShaderPresetsEnum.water,
      [child],
      [
        ('speed', speed),
        ('frequency', frequency),
        ('amplitude', amplitude),
      ],
      presetController,
    );
  }

  /// Page Curl shader
  factory ShaderPreset.pageCurl(
    dynamic child1,
    dynamic child2, {
    Key? key,
    ShaderPresetController? presetController,
    double radius = 0.1,
  }) {
    final ret = ShaderPreset._common(
      key,
      'packages/shader_presets/assets/shaders/page_curl.frag',
      ShaderPresetsEnum.pageCurl,
      [child1, child2],
      [
        ('radius', radius),
      ],
      presetController,
      onPointerDown: (ctrl, position) {
        /// set `play` state when touching
        ctrl.play();
      },
      onPointerUp: (ctrl, position) {
        /// when release the pointer, pause again and rewind
        ctrl
          ..pause()
          ..rewind();
      },
    );

    /// Add a trigger for the X touch position.
    /// When moving near the left side, we can swap children
    ret.shaderController.addConditionalOperation(
      (
        layerBuffer: ret.mainImage,
        param: Param.iMouseXNormalized,
        checkType: CheckOperator.minor,
        checkValue: 0.1,
        operation: (result) {
          if (result) {
            ret.mainImage.swapChannels(0, 1);
            ret.shaderController
              ..pause()
              ..rewind();
          }
        },
      ),
    );

    return ret;
  }

  ////////////////////////////////////////
  /// GL Transitions shaders
  ////////////////////////////////////////
  ///
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
    return ShaderPreset._common(
      key,
      'packages/shader_presets/assets/shaders/gl_transitions/polka_dots_curtain.frag',
      ShaderPresetsEnum.polkaDotsCurtain,
      [child1, child2],
      [
        ('progress', progress),
        ('dots', dots),
        ('centerX', centerX),
        ('centerY', centerY),
      ],
      presetController,
    );
  }

  /// Radial shader
  factory ShaderPreset.radial(
    dynamic child1,
    dynamic child2, {
    Key? key,
    ShaderPresetController? presetController,
    double progress = 0,
    double smoothness = 1,
  }) {
    return ShaderPreset._common(
      key,
      'packages/shader_presets/assets/shaders/gl_transitions/radial.frag',
      ShaderPresetsEnum.radial,
      [child1, child2],
      [
        ('progress', progress),
        ('smoothness', smoothness),
      ],
      presetController,
    );
  }

  final bool startPaused;
  final List<LayerBuffer>? buffers;
  final ShaderController shaderController;
  final void Function(ShaderController controller, Offset position)?
      onPointerDown;
  final void Function(ShaderController controller, Offset position)?
      onPointerMove;
  final void Function(ShaderController controller, Offset position)?
      onPointerUp;
  final ShaderPresetController? presetController;

  late LayerBuffer mainImage;
  late ShaderPresetsEnum preset;
  late Uniforms uniforms;

  @override
  Widget build(BuildContext context) {
    presetController!._setController(_setUniforms, _getShaderController);

    return ShaderBuffers(
      key: UniqueKey(),
      controller: shaderController,
      mainImage: mainImage,
      buffers: buffers,
      startPaused: startPaused,
      onPointerDownNormalized: onPointerDown,
      onPointerMoveNormalized: onPointerMove,
      onPointerUpNormalized: onPointerUp,
    );
  }
}
