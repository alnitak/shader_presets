# Shader Presets

A package that implements some ready-to-use shaders, like transitions from [gl-transitions](https://gl-transitions.com/) and effects from [ShaderToy](https://www.shadertoy.com/).

It uses the [shader_buffers](https://github.com/alnitak/shader_buffers) package which simplifies the use of shaders.

There are few presets and more can be added quite easily

## Getting Started
Simply as:

```dart
final presetController = ShaderPresetController();
ShaderPresetCube(
    child1: child1, // children can be either the path to the asset image or a widget
    child2: child2,
    presetController: presetController,
    progress: 0, // This is common to all gl-transitions
    reflection: 1, // This is one parameter of this Cube shader
)
```

`presetController` lets you get/set uniforms and get the shader controller.
The Shader controller lets you play/pause/rewind, add conditionals operation to check pointer position, get its state, swap texture channels, and animate custom uniform values.

**animate a custom uniform**:
```dart
presetController.getShaderController()!.animateUniform(
    uniformName: 'progress',
    begin: 0,
    end: 1,
    duration: const Duration(milliseconds: 600),
    curve: Curves.decelerate,
    onAnimationEnded: (ctrl, uniformValue) {
        ...
    },
);
```


Here all the current presets available with their uniform parameters, many others can be easily added:
|from *ShaderToy*||
|-|-|
|**ShaderPresetBarrel**<br/>distortion|![img](https://github.com/alnitak/shader_presets/blob/main/img/barrel.gif)|
|**ShaderPresetWater**<br/>speed, frequency, amplitude||
|**ShaderPresetPageCurl**<br/>radius||

|from *gl-transitions*||
|-|-|
|**ShaderPresetCube**<br/>progress, persp, unzoom, reflection, floating||
|**ShaderPresetPolkaDotsCurtain**<br/>progress, dots, centerX, centerY|
|**ShaderPresetRadial**<br/>progress, smoothness||
|**ShaderPresetFlyeye**<br/>progress, size, zoom, colorSeparation||


## Contributing

#### Adding a preset

In `shader_presets.dart`
- add a [ShaderPresetsEnum] enum value
- add that enum in [ShaderPresetController.getUniforms()] method. If the new shader doesn't have additional float uniforms, then return an empty list
- write the [StatelessWidget] class (see `src/gl_transitions/` or `src/shadertoy` folder for reference)
- add a shader reference in `shaders` section of `pubspec.yaml` to your fragment source

The `dynamic child` represents the texture (the `uniform sampler2D`) the shader uses. It must be the asset image path or a Widget.
You can add as many children as you wish based on the fragment usage.

#### Add/Write the fragment shader

There are some common headers to put at the beginning or at the end of the fragment source:

**common_header.frag** this is common to all the sources. It defines the common uniforms the `shader_buffers` package uses and the uniforms it adds can be used when writing your own fragment and must be imported in the first line of the fragment source:
```
uniform vec2 iResolution; // The viewport resolution in pixels
uniform float iTime;      // The shader playback time (in seconds)
uniform float iFrame;     // The shader playback frame
uniform vec4 iMouse;      // Mouse pixel coords. xy: current (if MLB down), zw: click

out vec4 fragColor;       // The shader output
```
These uniforms are also useful when using a fragment from ShaderToy.

**common_gl_transitions.frag** this is the common header for gl_transitions sources and it adds:
```
uniform sampler2D iChannel0; // The 1st texture
uniform sampler2D iChannel1; // The 2nd texture

// a value that moves from 0.0 to 1.0 during the transition.
uniform float progress;
// the ratio of the viewport. It equals width / height.
float ratio;
 ```
 It also adds `getFromColor` and `getToColor` functions commonly used in gl-transitions shaders.

There are also other two sources to import at the end of the source code:
**main_shadertoy.frag**
and
**main_gl_transitions.frag**

#### gl-transition example
```
// mandatory include for all fragment sources
#include "../common/common_header.frag"
// mandatory include for gl-transitions sources
#include "../common/common_gl_transitions.frag"

//------------------ Here starts gl-transition source
...
//------------------ Here ends gl-transition source

// mandatory include for gl-transitions sources
#include "../common/main_gl_transitions.frag"
```

#### ShaderToy example
```
#include "../common/common_header.frag"

// Define here the iChannel[0-3] used in the source
uniform sampler2D iChannel0;

//------------------ Here starts ShaderToy source
...
//------------------ Here ends ShaderToy source


#include "../common/main_shadertoy.frag"
```
