// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:shader_presets/src/shader_preset_common.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// Radial shader
class ShaderPresetRadial extends StatelessWidget {
  ///
  ShaderPresetRadial({
    required this.child1,
    required this.child2,
    super.key,
    ShaderPresetController? presetController,
    this.smoothness = 1,
  }) : presetController = presetController ?? ShaderPresetController();

  ///
  final dynamic child1;

  ///
  final dynamic child2;

  ///
  final ShaderPresetController? presetController;

  ///
  final double smoothness;

  @override
  Widget build(BuildContext context) {
    return ShaderPresetCommon.common(
      key: key,
      frag: 'packages/shader_presets/assets/shaders/gl_transitions/radial.frag',
      presetType: ShaderPresetsEnum.radial,
      childs: [child1, child2],
      uValues: [
        ('smoothness', smoothness),
      ],
      presetController: presetController,
      onPointerMove: (controller, position) {
        // Change the [position] uniform with pointer/mouse interaction
        presetController?.setUniform(0, position.dx);
      },
    );
  }
}
