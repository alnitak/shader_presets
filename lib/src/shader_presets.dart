// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';
import 'package:shader_buffers/shader_buffers.dart';

enum ShaderPresets {
  water,
}

/// In case of using a preset with multiple childs, they must have
/// the same size otherwise some of them will be stretched
class ShaderPreset extends StatelessWidget {
  const ShaderPreset._({
    required this.fragSource,
    required this.mainImage,
    required this.controller,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.child,
    super.key,
  });

  factory ShaderPreset.water(Widget child, double multiplier, {Key? key}) {
    final main = LayerBuffer(
      shaderAssetsName: 'packages/shader_presets/assets/shaders/water.frag',
      floatUniforms: [multiplier],
    )..setChannels([IChannel(child: child)]);

    return ShaderPreset._(
      key: key,
      fragSource: 'package',
      mainImage: main,
      controller: ShaderBuffersController(),
      child: child,
    );
  }

  factory ShaderPreset.pageCurl(Widget child1, Widget child2, {Key? key}) {
    final main = LayerBuffer(
      shaderAssetsName: 'packages/shader_presets/assets/shaders/page_curl.frag',
    )..setChannels([
        IChannel(child: child1),
        IChannel(child: child2),
      ]);
    final ctrl = ShaderBuffersController();
    // ignore: cascade_invocations
    ctrl.addConditionalOperation(
      (
        layerBuffer: main,
        param: Param.iMouseXNormalized,
        checkType: CheckOperator.minor,
        checkValue: 0.1,
        operation: (result) {
          if (result) {
            main.swapChannels(0, 1);
            ctrl
              ..pause()
              ..rewind();
          }
        },
      ),
    );

    return ShaderPreset._(
      key: key,
      fragSource: 'package',
      mainImage: main,
      controller: ctrl,
      onPointerDown: (position) {
        ctrl.play();
      },
      onPointerUp: (position) {
        ctrl
          ..pause()
          ..rewind();
      },
      child: child1,
    );
  }

  final String fragSource;
  final Widget? child;
  final LayerBuffer? mainImage;
  final ShaderBuffersController? controller;
  final void Function(Offset position)? onPointerDown;
  final void Function(Offset position)? onPointerMove;
  final void Function(Offset position)? onPointerUp;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ShaderBuffers(
      controller: controller,
      width: size.width,
      height: size.height,
      mainImage: mainImage!,
      startPaused: true,
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
    );
  }
}
