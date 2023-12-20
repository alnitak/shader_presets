// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:shader_presets/src/shader_preset_common.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// Polka Dots Curtain shader
class ShaderPresetPolkaDotsCurtain extends StatelessWidget {
  ///
  ShaderPresetPolkaDotsCurtain({
    required this.child1,
    required this.child2,
    super.key,
    ShaderPresetController? presetController,
    this.progress = 0,
    this.dots = 20,
    this.centerX = 0.5,
    this.centerY = 0.5,
  }) : presetController = presetController ?? ShaderPresetController();

  ///
  final dynamic child1;

  ///
  final dynamic child2;

  ///
  final ShaderPresetController? presetController;

  ///
  final double progress;
  final double dots;
  final double centerX;
  final double centerY;

  @override
  Widget build(BuildContext context) {
    return ShaderPresetCommon.common(
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
      onPointerMove: (controller, position) {
        // Change the [position] uniform with pointer/mouse interaction
        presetController?.setUniform(0, position.dx);
      },
    );
  }
}
