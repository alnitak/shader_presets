// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';
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
    final mainLayer = LayerBuffer(
      shaderAssetsName:
          'packages/shader_presets/assets/shaders/shadertoy/water.frag',
    )
      ..setChannels([
        IChannel(
          assetsTexturePath: child is String ? child as String : null,
          child: child is Widget ? child as Widget : null,
        ),
      ])
      ..uniforms =
          presetController!.getDefaultUniforms(ShaderPresetsEnum.water);

    /// After getting the defaults, set the user passed values.
    mainLayer.uniforms!.setDoubleList([speed, frequency, amplitude]);

    return ShaderPresetCommon.common(
      key: key,
      mainLayer: mainLayer,
      presetType: ShaderPresetsEnum.water,
      presetController: presetController,
    );
  }
}
