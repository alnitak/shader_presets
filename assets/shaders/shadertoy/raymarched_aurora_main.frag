#include "../common/common_header.frag"

uniform sampler2D iChannel0;

// credits:
// https://www.shadertoy.com/view/clSyDt


// ------ START SHADERTOY CODE -----
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;
    uv += 1.0;
    uv *= 0.5;
    
    fragColor = texture(iChannel0, uv);
    
}
// ------ END SHADERTOY CODE -----



#include "../common/main_shadertoy.frag"
