// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';

/// How to add a preset:
/// - add a [ShaderPresetsEnum] enum value
/// - add that enum in [ShaderPresetController.getUniforms()] method. If
///   the new shader doesn't have additional float uniforms, then
///   return an empty list
/// - add a factory in [ShaderPreset]
/// 
/// The `dynamic child` represents the texture (the `uniform sampler2D) used
/// by the shader. The `dynamic` must be the asset image path or a Widget.
/// You can add as many childrens as you wish.

enum ShaderPresetsEnum {
  water,
  pageCurl,
  cube,
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

      case ShaderPresetsEnum.cube:
        return Uniforms([
          Uniform(
            name: 'progress',
            range: const RangeValues(0, 1),
            defaultValue: 0,
            value: 0,
          ),
          Uniform(
            name: 'persp',
            range: const RangeValues(0, 2),
            defaultValue: 0.7,
            value: 0.7,
          ),
          Uniform(
            name: 'unzoom',
            range: const RangeValues(0, 10),
            defaultValue: 0.3,
            value: 0.3,
          ),
          Uniform(
            name: 'reflection',
            range: const RangeValues(0, 1),
            defaultValue: 0.4,
            value: 0.4,
          ),
          Uniform(
            name: 'floating',
            range: const RangeValues(0, 30),
            defaultValue: 3,
            value: 3,
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
  void _setUniforms(dynamic newUniforms) {
    assert(
      newUniforms is Uniforms || newUniforms is List<double>,
      'Please use [Uniforms] or [List<double>]!',
    );
    assert(
      newUniforms is List<Object> &&
          newUniforms.length == uniforms.uniforms.length,
      '${preset.name} preset only accepts ${uniforms.uniforms.length} uniforms!',
    );

    var newUniformsList = <double>[];
    if (newUniforms is Uniforms) {
      newUniformsList = List.generate(newUniforms.uniforms.length,
          (index) => newUniforms.uniforms[index].value);
    }
    if (newUniforms is List<double>) newUniformsList = newUniforms;
    mainImage.floatUniforms = newUniformsList;
  }

  /// Common factory to rule them all!
  factory ShaderPreset._common({
    required String frag,
    required ShaderPresetsEnum presetType,
    required List<dynamic> childs,
    Key? key,
    List<(String name, double value)> uValues = const [],
    ShaderPresetController? presetController, 
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
      key: key,
      frag: 'packages/shader_presets/assets/shaders/water.frag',
      presetType: ShaderPresetsEnum.water,
      childs: [child],
      uValues: [
        ('speed', speed),
        ('frequency', frequency),
        ('amplitude', amplitude),
      ],
      presetController: presetController,
    );
  }

  /// Page Curl shader which curls on both X and Y axis
  /// It swaps children when it reach 10% of width from the left edge
  factory ShaderPreset.pageCurl(
    dynamic child1,
    dynamic child2, {
    Key? key,
    ShaderPresetController? presetController,
    double radius = 0.1,
  }) {
    final ret = ShaderPreset._common(
      key: key,
      frag: 'packages/shader_presets/assets/shaders/page_curl.frag',
      presetType: ShaderPresetsEnum.pageCurl,
      childs: [child1, child2],
      uValues: [('radius', radius)],
      presetController: presetController,
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
  /// Cube shader
  factory ShaderPreset.cube(
    dynamic child1,
    dynamic child2, {
    Key? key,
    ShaderPresetController? presetController,
    double progress = 0,
    double persp = 0.7,
    double unzoom = 0.3,
    double reflection = 0.4,
    double floating = 3,
  }) {
    return ShaderPreset._common(
      key: key,
      frag: 'packages/shader_presets/assets/shaders/gl_transitions/cube.frag',
      presetType: ShaderPresetsEnum.cube,
      childs: [child1, child2],
      uValues: [
        ('progress', progress),
        ('persp', persp),
        ('unzoom', unzoom),
        ('reflection', reflection),
        ('floating', floating),
      ],
      presetController: presetController,
    );
  }

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
      key: key,
      frag: 'packages/shader_presets/assets/shaders/gl_transitions/polka_dots_curtain.frag',
      presetType: ShaderPresetsEnum.polkaDotsCurtain,
      childs: [child1, child2],
      uValues: [
        ('progress', progress),
        ('dots', dots),
        ('centerX', centerX),
        ('centerY', centerY),
      ],
      presetController: presetController,
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
      key: key,
      frag: 'packages/shader_presets/assets/shaders/gl_transitions/radial.frag',
      presetType: ShaderPresetsEnum.radial,
      childs: [child1, child2],
      uValues: [
        ('progress', progress),
        ('smoothness', smoothness),
      ],
      presetController: presetController,
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
