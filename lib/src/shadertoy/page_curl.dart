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
    final mainLayer = LayerBuffer(
        shaderAssetsName:
            'packages/shader_presets/assets/shaders/shadertoy/page_curl.frag')
      ..setChannels([
        IChannel(
          assetsTexturePath: child1 is String ? child1 as String : null,
          child: child1 is Widget ? child1 as Widget : null,
        ),
        IChannel(
          assetsTexturePath: child2 is String ? child2 as String : null,
          child: child2 is Widget ? child2 as Widget : null,
        ),
      ])
      ..uniforms =
          presetController!.getDefaultUniforms(ShaderPresetsEnum.pageCurl);

    /// After getting the defaults, set the user passed values.
    mainLayer.uniforms!.setDoubleList([radius]);

    final ret = ShaderPresetCommon.common(
      key: key,
      mainLayer: mainLayer,
      presetType: ShaderPresetsEnum.pageCurl,
      presetController: presetController,
      onPointerUp: (ctrl, position) {
        /// rewind when releasing the pointer
        ctrl
          ..play()
          ..rewind();
      },
    );

    /// Add a trigger for the X touch position.
    /// When moving near the left side, we can swap children
    ret.shaderController.addConditionalOperation(
      (
        layerBuffer: mainLayer,
        param: Param.iMouseXNormalized,
        checkType: CheckOperator.minor,
        checkValue: 0.1,
        operation: (ctrl, result) {
          if (result) {
            ret.shaderController
              ..pause()
              ..swapChannels(mainLayer, 0, 1)
              ..rewind();
          }
        },
      ),
    );

    return ret;
  }
}
