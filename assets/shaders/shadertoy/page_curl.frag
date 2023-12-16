#include "../common/common_header.frag"

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;

uniform float radius;


// credits:
// https://www.shadertoy.com/view/ls3cDB

// ------ START SHADERTOY CODE -----
#define pi 3.14159265359

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float aspect = iResolution.x / iResolution.y;

    vec2 uv = fragCoord * vec2(aspect, 1.) / iResolution.xy;
    vec2 mouse = iMouse.xy  * vec2(aspect, 1.) / iResolution.xy;
//    mouse.y = 0.; // fix movements horizontally
    vec2 mouseDir = normalize(abs(iMouse.zw) - iMouse.xy);
//    mouseDir.y = 0.; // fix movements horizontally
    vec2 origin = clamp(mouse - mouseDir * mouse.x / mouseDir.x, 0., 1.);
//    origin.y = 0.; // fix movements horizontally

    float mouseDist = clamp(length(mouse - origin)
                            + (aspect - (abs(iMouse.z) / iResolution.x) * aspect) / mouseDir.x, 0., aspect / mouseDir.x);

    if (mouseDir.x < 0.)
    {
        mouseDist = distance(mouse, origin);
    }

    float proj = dot(uv - origin, mouseDir);
    float dist = proj - mouseDist;

    vec2 linePoint = uv - dist * mouseDir;

    if (dist > radius)
    {
        fragColor = texture(iChannel1, uv * vec2(1. / aspect, 1.));
        fragColor.rgb *= pow(clamp(dist - radius, 0., 1.) * 1.5, .2);
    }
    else if (dist >= 0.)
    {
        // map to cylinder point
        float theta = asin(dist / radius);
        vec2 p2 = linePoint + mouseDir * (pi - theta) * radius;
        vec2 p1 = linePoint + mouseDir * theta * radius;
        uv = (p2.x <= aspect && p2.y <= 1. && p2.x > 0. && p2.y > 0.) ? p2 : p1;
        fragColor = texture(iChannel0, uv * vec2(1. / aspect, 1.));
        fragColor.rgb *= pow(clamp((radius - dist) / radius, 0., 1.), .2);
    }
    else
    {
        vec2 p = linePoint + mouseDir * (abs(dist) + pi * radius);
        uv = (p.x <= aspect && p.y <= 1. && p.x > 0. && p.y > 0.) ? p : uv;
        fragColor = texture(iChannel0, uv * vec2(1. / aspect, 1.));
    }
}
// ------ END SHADERTOY CODE -----



#include "../common/main_shadertoy.frag"
