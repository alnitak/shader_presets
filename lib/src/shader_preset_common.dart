// ignore_for_file:  sort_constructors_first, must_be_immutable

import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// In case of using a preset with multiple childs, they must have
/// the same size otherwise some of them will be stretched to the first
/// child found.
///
/// Valid uniforms are only those set for [mainLayer]
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

  /// Common factory
  factory ShaderPresetCommon.common({
    required LayerBuffer mainLayer,
    required ShaderPresetsEnum presetType,
    Key? key,
    List<LayerBuffer> buffers = const [],
    bool startPaused = false,
    ShaderPresetController? presetController,
    void Function(ShaderController controller, Offset position)? onPointerDown,
    void Function(ShaderController controller, Offset position)? onPointerMove,
    void Function(ShaderController controller, Offset position)? onPointerUp,
  }) {
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
      ..uniforms = mainLayer.uniforms
      ..mainLayer = mainLayer;
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

  /// Callback that give back the normalized position (0-1 range)
  final void Function(ShaderController controller, Offset position)?
      onPointerMove;

  /// Callback that give back the normalized position (0-1 range)
  final void Function(ShaderController controller, Offset position)?
      onPointerUp;

  /// Control the preset shader paramaters
  final ShaderPresetController? presetController;

  /// The main layer shader
  late LayerBuffer mainLayer;

  /// The current preset
  late ShaderPresetsEnum preset;

  /// The shader uniforms
  Uniforms? uniforms;

  ShaderController _getShaderController() {
    return shaderController;
  }

  /// Sets the uniform values for the current preset.
  /// Accepts a [Uniforms] or [List<double>] param.
  void _setUniforms(dynamic newUniforms) {
    if (uniforms == null) return;

    // Check type of [newUniforms]
    assert(
      newUniforms is Uniforms || newUniforms is List<double>,
      'Please use [Uniforms] or [List<double>]!',
    );

    // Generate the double list
    if (newUniforms is Uniforms) {
      uniforms = newUniforms;
    }
    if (newUniforms is List<double>) {
      for (var i = 0; i < mainLayer.uniforms!.uniforms.length; i++) {
        mainLayer.uniforms!.uniforms[i].value = newUniforms[i];
      }
    }

    mainLayer.uniforms = uniforms;
  }

  /// Set the uniform at [index]
  void _setUniform(int index, double value) {
    if (uniforms == null) return;

    assert(
      index < uniforms!.uniforms.length,
      'Uniform index out of range!',
    );
    var newValue = value;
    if (value > uniforms!.uniforms[index].range.end) {
      newValue = uniforms!.uniforms[index].range.end;
    }
    if (value < uniforms!.uniforms[index].range.start) {
      newValue = uniforms!.uniforms[index].range.start;
    }
    uniforms!.uniforms[index].value = newValue;
    mainLayer.uniforms = uniforms;
  }

  /// Get the current uniforms
  Uniforms? _getUniforms() {
    return uniforms;
  }

  @override
  Widget build(BuildContext context) {
    presetController!.setController(
      _setUniforms,
      _setUniform,
      _getUniforms,
      _getShaderController,
    );

    return ShaderBuffers(
      controller: shaderController,
      mainImage: mainLayer,
      buffers: buffers,
      startPaused: startPaused,
      onPointerDownNormalized: onPointerDown,
      onPointerMoveNormalized: onPointerMove,
      onPointerUpNormalized: onPointerUp,
    );
  }
}
