// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:shader_presets/src/shader_preset_common.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// Cube shader
class ShaderPresetCube extends StatelessWidget {
  ///
  ShaderPresetCube({
    required this.child1,
    required this.child2,
    super.key,
    ShaderPresetController? presetController,
    this.progress = 0,
    this.persp = 0.7,
    this.unzoom = 0.3,
    this.reflection = 0.4,
    this.floating = 3,
  }) : presetController = presetController ?? ShaderPresetController();

  ///
  final dynamic child1;

  ///
  final dynamic child2;

  ///
  final ShaderPresetController? presetController;

  ///
  final double progress;
  final double persp;
  final double unzoom;
  final double reflection;
  final double floating;

  @override
  Widget build(BuildContext context) {
    return ShaderPresetCommon.common(
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
}
