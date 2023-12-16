// ignore_for_file:  sort_constructors_first, must_be_immutable

import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// In case of using a preset with multiple childs, they must have
/// the same size otherwise some of them will be stretched
class ShaderPresetCommon extends StatelessWidget {
  ShaderPresetCommon._({
    required this.shaderController,
    this.presetController,
    this.buffers = const [],
    this.startPaused = false,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    super.key,
  });

  /// Common factory to rule them all
  factory ShaderPresetCommon.common({
    required String frag,
    required ShaderPresetsEnum presetType,
    required List<dynamic> childs,
    Key? key,
    List<LayerBuffer> buffers = const [],
    List<(String name, double value)> uValues = const [],
    bool startPaused = false,
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

    return ShaderPresetCommon._(
      key: key,
      buffers: buffers,
      shaderController: ShaderController(),
      startPaused: startPaused,
      presetController: presetController,
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
    )
      ..preset = presetType
      ..uniforms = u
      ..mainImage = main;
  }

  /// Set the shader state at start
  final bool startPaused;

  /// Layer buffers
  final List<LayerBuffer> buffers;

  /// Controller
  final ShaderController shaderController;

  /// Callbacks that give back the normalized position (0-1 range)
  final void Function(ShaderController controller, Offset position)?
      onPointerDown;
  final void Function(ShaderController controller, Offset position)?
      onPointerMove;
  final void Function(ShaderController controller, Offset position)?
      onPointerUp;
  final ShaderPresetController? presetController;

  /// The main layer shader
  late LayerBuffer mainImage;

  /// The current preset
  late ShaderPresetsEnum preset;

  /// The shader uniforms
  late Uniforms uniforms;

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
      newUniformsList = List.generate(
        newUniforms.uniforms.length,
        (index) => newUniforms.uniforms[index].value,
      );
    }
    if (newUniforms is List<double>) newUniformsList = newUniforms;
    mainImage.floatUniforms = newUniformsList;
  }

  @override
  Widget build(BuildContext context) {
    presetController!.setController(_setUniforms, _getShaderController);

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
