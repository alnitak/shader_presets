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

// https://github.com/gl-transitions/gl-transitions/tree/master/transitions/flyeye.glsl

// License: MIT
// Author: Xaychru
// ported by gre from https://gist.github.com/Xaychru/ce1d48f0ce00bb379750

// Author: gre
// License: MIT
uniform float size; // = 0.04
uniform float zoom; // = 50.0
uniform float colorSeparation; // = 0.3

vec4 transition(vec2 p) {
  float inv = 1. - progress;
  vec2 disp = size*vec2(cos(zoom*p.x), sin(zoom*p.y));
  vec4 texTo = getToColor(p + inv*disp);
  vec4 texFrom = vec4(
    getFromColor(p + progress*disp*(1.0 - colorSeparation)).r,
    getFromColor(p + progress*disp).g,
    getFromColor(p + progress*disp*(1.0 + colorSeparation)).b,
    1.0);
  return texTo*progress + texFrom*inv;
}

void main() {
    float tmp = (iFrame/iFrame) * (iMouse.x/iMouse.x) * 
        (iTime/iTime) * (iResolution.x/iResolution.x);
    if (tmp != 1.) tmp = 1.;

    ratio = iResolution.x/iResolution.y;
    vec2 uv = FlutterFragCoord().xy / iResolution.xy * tmp;
    fragColor = transition(vec2(uv.x, 1.0 - uv.y));
}
