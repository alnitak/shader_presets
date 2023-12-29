#include "../common/common_header.frag"

uniform sampler2D iChannel0;
uniform float distortion;


// credits:
// https://www.shadertoy.com/view/WlscD4


// ------ START SHADERTOY CODE -----
vec2 BarrelDistortion(vec2 uv, float distortion, float k){
    vec2 center = uv - 0.5;
    float radius = length(center);
    float radiusp2 = (k + pow(radius, 2.0)) * radius;
    float f = mix(radius, radiusp2, distortion);
   	float a = atan(center.y, center.x);
    
    return vec2(cos(a), sin(a)) * f + 0.5;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    float k = 0.6;
    float offset = 0.025 * log(distortion+1.);

    vec2 barrel = BarrelDistortion(uv, distortion, k + offset);
    
    // Output to screen
    fragColor = texture(iChannel0, barrel);
}
// ------ END SHADERTOY CODE -----



#include "../common/main_shadertoy.frag"