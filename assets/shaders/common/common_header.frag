#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;


// add `uniform sampler2D iChannel[0-N];` into frag source as needed
uniform vec2 iResolution;
uniform float iTime;
uniform float iFrame;
uniform vec4 iMouse;

out vec4 fragColor;