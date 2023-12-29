// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';
import 'package:shader_presets/src/shader_preset_common.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// Water shader
class ShaderPresetBarrel extends StatelessWidget {
  ///
  ShaderPresetBarrel({
    required this.child,
    super.key,
    ShaderPresetController? presetController,
    this.distortion = 0,
  }) : presetController = presetController ?? ShaderPresetController();

  ///
  final dynamic child;

  ///
  final ShaderPresetController? presetController;

  ///
  final double distortion;

  @override
  Widget build(BuildContext context) {
    final mainLayer = LayerBuffer(
        shaderAssetsName:
            'packages/shader_presets/assets/shaders/shadertoy/barrel.frag')
      ..setChannels([
        IChannel(
          assetsTexturePath: child is String ? child as String : null,
          child: child is Widget ? child as Widget : null,
        ),
      ])
      ..uniforms =
          presetController!.getDefaultUniforms(ShaderPresetsEnum.barrel);

    /// After getting the defaults, set the user passed values.
    mainLayer.uniforms!.setDoubleList([distortion]);

    return ShaderPresetCommon.common(
      key: key,
      mainLayer: mainLayer,
      presetType: ShaderPresetsEnum.barrel,
      presetController: presetController,
    );
  }
}
