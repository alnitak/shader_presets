import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';
import 'package:shader_presets/src/shader_preset_common.dart';
import 'package:shader_presets/src/shader_presets.dart';

/// Page Curl shader which curls on both X and Y axis
/// It swaps children when it reach 10% of width from the left edge
class ShaderPresetPageCurl extends StatelessWidget {
  ///
  ShaderPresetPageCurl({
    required this.child1,
    required this.child2,
    super.key,
    ShaderPresetController? presetController,
    this.radius = 0.1,
  }) : presetController = presetController ?? ShaderPresetController();

  ///
  final dynamic child1;

  ///
  final dynamic child2;

  ///
  final ShaderPresetController? presetController;

  ///
  final double radius;

  @override
  Widget build(BuildContext context) {
    final ret = ShaderPresetCommon.common(
      key: key,
      frag: 'packages/shader_presets/assets/shaders/shadertoy/page_curl.frag',
      presetType: ShaderPresetsEnum.pageCurl,
      childs: [child1, child2],
      uValues: [('radius', radius)],
      presetController: presetController,
      onPointerDown: (ctrl, position) {
        /// set `play` state when touching
        ctrl.play();
      },
      onPointerUp: (ctrl, position) {
        /// when release the pointer, pause again and rewind
        ctrl
          ..pause()
          ..rewind();
      },
    );

    /// Add a trigger for the X touch position.
    /// When moving near the left side, we can swap children
    ret.shaderController.addConditionalOperation(
      (
        layerBuffer: ret.mainImage,
        param: Param.iMouseXNormalized,
        checkType: CheckOperator.minor,
        checkValue: 0.1,
        operation: (result) {
          if (result) {
            ret.mainImage.swapChannels(0, 1);
            ret.shaderController
              ..pause()
              ..rewind();
          }
        },
      ),
    );

    return ret;
  }
}
