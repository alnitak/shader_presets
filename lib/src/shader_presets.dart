// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shader_buffers/shader_buffers.dart';

/// How to add a preset:
/// - add a [ShaderPresetsEnum] enum value
/// - add that enum in [ShaderPresetController.getUniforms()] method. If
///   the new shader doesn't have additional float uniforms, then
///   return an empty list
/// - write the [StatelessWidget] class (see `src/gl_transitions/` or
///   `src/shadertoy` folder for reference)
/// - add the shader reference in `shaders` section of `pubspec.yaml`
///
/// The `dynamic child` represents the texture (the `uniform sampler2D`) used
/// by the shader. The `dynamic` must be the asset image path or a Widget.
/// You can add as many childrens as you wish.

enum ShaderPresetsEnum {
  water,
  pageCurl,
  barrel,

  cube,
  polkaDotsCurtain,
  radial,
  flyeye,
}

///
class ShaderPresetController {
  void Function(dynamic uniforms)? _setUniforms;
  void Function(int index, double newValue)? _setUniform;
  Uniforms? Function()? _getUniforms;
  ShaderController Function()? _getShaderController;

  void setController(
    void Function(dynamic uniforms) setUniforms,
    void Function(int index, double newValue) setUniform,
    Uniforms? Function() getUniforms,
    ShaderController Function() getShaderController,
  ) {
    _setUniforms = setUniforms;
    _setUniform = setUniform;
    _getUniforms = getUniforms;
    _getShaderController = getShaderController;
  }

  void setUniforms(dynamic uniforms) => _setUniforms?.call(uniforms);

  void setUniform(int index, double value) => _setUniform?.call(index, value);

  Uniforms? getUniforms() => _getUniforms?.call();

  ShaderController? getShaderController() => _getShaderController?.call();

  /// Get the preset uniforms
  Uniforms getDefaultUniforms(ShaderPresetsEnum preset) {
    switch (preset) {
      /// Shadertoy
      /// ////////////////////////////////////
      case ShaderPresetsEnum.water:
        return Uniforms([
          Uniform(
            name: 'speed',
            range: const RangeValues(0, 1),
            defaultValue: 0.2,
            value: 0.2,
          ),
          Uniform(
            name: 'frequency',
            range: const RangeValues(0, 20),
            defaultValue: 8,
            value: 8,
          ),
          Uniform(
            name: 'amplitude',
            range: const RangeValues(0, 5),
            defaultValue: 1,
            value: 1,
          ), //
        ]);

      case ShaderPresetsEnum.pageCurl:
        return Uniforms([
          Uniform(
            name: 'radius',
            range: const RangeValues(0, 1),
            defaultValue: 0.1,
            value: 0.1,
          ),
        ]);

      case ShaderPresetsEnum.barrel:
        return Uniforms([
          Uniform(
            name: 'distortion',
            range: const RangeValues(-2, 2),
            defaultValue: 0,
            value: 0,
          ),
        ]);

      /// GL Transitions
      /// ///////////////////////////////////////
      case ShaderPresetsEnum.cube:
        return Uniforms([
          Uniform(
            name: 'progress',
            range: const RangeValues(0, 1),
            defaultValue: 0,
            value: 0,
          ),
          Uniform(
            name: 'persp',
            range: const RangeValues(0, 2),
            defaultValue: 0.7,
            value: 0.7,
          ),
          Uniform(
            name: 'unzoom',
            range: const RangeValues(0, 10),
            defaultValue: 0.3,
            value: 0.3,
          ),
          Uniform(
            name: 'reflection',
            range: const RangeValues(0, 1),
            defaultValue: 0.4,
            value: 0.4,
          ),
          Uniform(
            name: 'floating',
            range: const RangeValues(0, 30),
            defaultValue: 3,
            value: 3,
          ),
        ]);

      case ShaderPresetsEnum.polkaDotsCurtain:
        return Uniforms([
          Uniform(
            name: 'progress',
            range: const RangeValues(0, 1),
            defaultValue: 0,
            value: 0,
          ),
          Uniform(
            name: 'dots',
            range: const RangeValues(2, 80),
            defaultValue: 20,
            value: 20,
          ),
          Uniform(
            name: 'centerX',
            range: const RangeValues(0, 1),
            defaultValue: 0.5,
            value: 0.5,
          ),
          Uniform(
            name: 'centerY',
            range: const RangeValues(0, 1),
            defaultValue: 0.5,
            value: 0.5,
          ),
        ]);

      case ShaderPresetsEnum.radial:
        return Uniforms([
          Uniform(
            name: 'progress',
            range: const RangeValues(0, 1),
            defaultValue: 0,
            value: 0,
          ),
          Uniform(
            name: 'smoothness',
            range: const RangeValues(0, 3),
            defaultValue: 1,
            value: 1,
          ),
        ]);
      case ShaderPresetsEnum.flyeye:
        return Uniforms([
          Uniform(
            name: 'progress',
            range: const RangeValues(0, 1),
            defaultValue: 0,
            value: 0,
          ),
          Uniform(
            name: 'size',
            range: const RangeValues(0, 0.1),
            defaultValue: 0.04,
            value: 0.04,
          ),
          Uniform(
            name: 'zoom',
            range: const RangeValues(1, 100),
            defaultValue: 50,
            value: 50,
          ),
          Uniform(
            name: 'colorSeparation',
            range: const RangeValues(0, 3),
            defaultValue: 0.3,
            value: 0.3,
          ),
        ]);
    }
  }
}
