// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:shader_presets/src/shader_preset_common.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// Water shader
class ShaderPresetWater extends StatelessWidget {
  ///
  ShaderPresetWater({
    required this.child,
    super.key,
    ShaderPresetController? presetController,
    this.speed = 0.2,
    this.frequency = 8,
    this.amplitude = 1,
  }) : presetController = presetController ?? ShaderPresetController();

  ///
  final dynamic child;

  ///
  final ShaderPresetController? presetController;

  ///
  final double speed;
  final double frequency;
  final double amplitude;

  @override
  Widget build(BuildContext context) {
    return ShaderPresetCommon.common(
      key: key,
      frag: 'packages/shader_presets/assets/shaders/shadertoy/water.frag',
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
}
