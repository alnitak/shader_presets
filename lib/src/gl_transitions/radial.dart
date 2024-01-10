// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:shader_buffers/shader_buffers.dart';
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
    this.progress = 0,
    this.smoothness = 1,
  }) : presetController = presetController ?? ShaderPresetController();

  ///
  final dynamic child1;

  ///
  final dynamic child2;

  ///
  final ShaderPresetController? presetController;

  ///
  final double progress;
  final double smoothness;

  @override
  Widget build(BuildContext context) {
    final mainLayer = LayerBuffer(
        shaderAssetsName:
            'packages/shader_presets/assets/shaders/gl_transitions/radial.frag')
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
          presetController!.getDefaultUniforms(ShaderPresetsEnum.radial);

    /// After getting the defaults, set the user passed values.
    mainLayer.uniforms!.setDoubleList([progress, smoothness]);

    final ret = ShaderPresetCommon.common(
      key: key,
      mainLayer: mainLayer,
      presetType: ShaderPresetsEnum.radial,
      presetController: presetController,
      // onPointerMove: (controller, position) {
      //   // Change the [position] uniform with pointer/mouse interaction
      //   presetController?.setUniform(0, position.dx);
      // },
    );

    /// Add a trigger for the "progress" uniform.
    /// When it reach 1.0, we can swap children.
    ret.shaderController.addConditionalOperation(
      (
        layerBuffer: mainLayer,
        param: Param(CommonUniform.customUniform, uniformId: 0),
        checkType: CheckOperator.equal,
        checkValue: 1,
        operation: (ctrl, result) {
          if (result) {
            mainLayer.uniforms!.setValueByIndex(0, 0);

            /// Eventually stop the animation because the animation can
            /// set a new uniform value, so it will override
            /// the new value set here
            ctrl.stopAnimateUniform(
                uniformName: mainLayer.uniforms!.uniforms[0].name);

            ret.shaderController
              ..swapChannels(mainLayer, 0, 1)
              ..rewind();
          }
        },
      ),
    );

    return ret;
  }
}
