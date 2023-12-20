// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:shader_presets/src/shader_preset_common.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// Cube shader
class ShaderPresetFlyeye extends StatelessWidget {
  ///
  ShaderPresetFlyeye({
    required this.child1,
    required this.child2,
    super.key,
    ShaderPresetController? presetController,
    this.progress = 0,
    this.size = 0.04,
    this.zoom = 50,
    this.colorSeparation = 0.3,
  }) : presetController = presetController ?? ShaderPresetController();

  ///
  final dynamic child1;

  ///
  final dynamic child2;

  ///
  final ShaderPresetController? presetController;

  ///
  final double progress;
  final double size;
  final double zoom;
  final double colorSeparation;

  @override
  Widget build(BuildContext context) {
    return ShaderPresetCommon.common(
      key: key,
      frag: 'packages/shader_presets/assets/shaders/gl_transitions/flyeye.frag',
      presetType: ShaderPresetsEnum.flyeye,
      childs: [child1, child2],
      uValues: [
        ('progress', progress),
        ('size', size),
        ('zoom', zoom),
        ('colorSeparation', colorSeparation),
      ],
      presetController: presetController,
      onPointerMove: (controller, position) {
        // Change the [position] uniform with pointer/mouse interaction
        presetController?.setUniform(0, position.dx);
      },
    );
  }
}
