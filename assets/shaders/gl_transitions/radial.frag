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

// https://github.com/gl-transitions/gl-transitions/tree/master/transitions/Radial.glsl

// License: MIT
// Author: Xaychru
// ported by gre from https://gist.github.com/Xaychru/ce1d48f0ce00bb379750

uniform float smoothness; // = 1.0

const float PI = 3.141592653589;

vec4 transition(vec2 p) {
  vec2 rp = p*2.-1.;
  return mix(
    getToColor(p),
    getFromColor(p),
    smoothstep(0., smoothness, atan(rp.y,rp.x) - (progress-.5) * PI * 2.5)
  );
}

void main() {
    float tmp = (iFrame/iFrame) * (iMouse.x/iMouse.x) * 
        (iTime/iTime) * (iResolution.x/iResolution.x);
    if (tmp != 1.) tmp = 1.;

    ratio = iResolution.x/iResolution.y;
    vec2 uv = FlutterFragCoord().xy / iResolution.xy * tmp;
    fragColor = transition(vec2(uv.x, 1.0 - uv.y));
}
