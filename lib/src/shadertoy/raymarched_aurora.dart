// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';
import 'package:shader_presets/src/shader_preset_common.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// Raymarched Aurora shader
class ShaderPresetRaymarchedAurora extends StatelessWidget {
  ///
  ShaderPresetRaymarchedAurora({
    super.key,
    ShaderPresetController? presetController,
    this.maxSteps = 250,
    this.volSteps = 260,
    this.volLength = 175,
    this.volDensity = 0.02,
  }) : presetController = presetController ?? ShaderPresetController();

  ///
  final ShaderPresetController? presetController;

  /// Shader uniforms
  final double maxSteps;
  final double volSteps;
  final double volLength;
  final double volDensity;

  @override
  Widget build(BuildContext context) {
    final bufferA = LayerBuffer(
        shaderAssetsName:
            'packages/shader_presets/assets/shaders/shadertoy/raymarched_aurora_buffer_a.frag')
    ..floatUniforms = [
      maxSteps,
      volSteps,
      volLength,
      volDensity,
    ];
    
    return ShaderPresetCommon.common(
      key: key,
      frag:
          'packages/shader_presets/assets/shaders/shadertoy/raymarched_aurora_main.frag',
      presetType: ShaderPresetsEnum.raymarchedAurora,
      childs: [bufferA],
      uValues: [
        ('maxSteps', maxSteps),
        ('volSteps', volSteps),
        ('volLength', volLength),
        ('volDensity', volDensity),
      ],
      presetController: presetController,
    );
  }
}
