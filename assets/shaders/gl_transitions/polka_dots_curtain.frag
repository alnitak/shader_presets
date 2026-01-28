#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform vec2 iResolution;
uniform float iTime;
uniform float iFrame;
uniform vec4 iMouse;

out vec4 fragColor;

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;

uniform float progress;
float ratio;

vec4 getFromColor(vec2 uv) {
  return texture( iChannel0, vec2(uv.x, 1.0 - uv.y) );
}

vec4 getToColor(vec2 uv) {
  return texture( iChannel1, vec2(uv.x, 1.0 - uv.y) );
}

// https://github.com/gl-transitions/gl-transitions/tree/master/transitions/PolkaDotsCurtain.glsl

// author: bobylito
// license: MIT
const float SQRT_2 = 1.414213562373;
uniform float dots;// = 20.0;
uniform vec2 center;// = vec2(0, 0);

vec4 transition(vec2 uv) {
  bool nextImage = distance(fract(uv * dots), vec2(0.5, 0.5)) < ( progress / distance(uv, center));
  return nextImage ? getToColor(uv) : getFromColor(uv);
}

void main() {
    float tmp = (iFrame/iFrame) * (iMouse.x/iMouse.x) * 
        (iTime/iTime) * (iResolution.x/iResolution.x);
    if (tmp != 1.) tmp = 1.;

    ratio = iResolution.x/iResolution.y;
    vec2 uv = FlutterFragCoord().xy / iResolution.xy * tmp;
    fragColor = transition(vec2(uv.x, 1.0 - uv.y));
}
