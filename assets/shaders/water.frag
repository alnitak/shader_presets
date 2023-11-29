#version 460 core
#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform sampler2D iChannel0;
uniform vec2 iResolution;
uniform float iTime;
uniform float iFrame;
uniform vec4 iMouse;

uniform float multiplier;

out vec4 fragColor;

// credits:
// https://www.shadertoy.com/view/ldXGz7


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
//	uv.y = -uv.y;
	
	uv.y += (cos((uv.y + (iTime * 0.04 * multiplier)) * 45.0 * multiplier) * 0.0019) +
		(cos((uv.y + (iTime * 0.1 * multiplier)) * 10.0 * multiplier) * 0.002);

	uv.x += (sin((uv.y + (iTime * 0.07 * multiplier)) * 15.0 * multiplier) * 0.0029) +
		(sin((uv.y + (iTime * 0.1 * multiplier)) * 15.0 * multiplier) * 0.002);
		

	vec4 texColor = texture(iChannel0,uv);
	fragColor = texColor;
}


void main() {
    // Shader compiler optimizations will remove unusued uniforms.
    // Since [LayerBuffer.computeLayer] needs to always set these uniforms, when 
    // this happens, an error occurs when calling setFloat()
    // `IndexError (RangeError (index): Index out of range: index should be less than 3: 3)`
    // With the following line, the compiler will not remove unusued
    float tmp = (iFrame/iFrame) * (iMouse.x/iMouse.x) * 
        (iTime/iTime) * (iResolution.x/iResolution.x);

    mainImage( fragColor, FlutterFragCoord().xy * tmp );
}