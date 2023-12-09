#include "common/common_header.frag"

uniform sampler2D iChannel0;


uniform float speed;     // 0.2
uniform float frequency; // 8.0
uniform float amplitude; // 1.0


// credits:
// https://www.shadertoy.com/view/Mls3DH


// [2TC 15] Water2D
// Copyleft {c} 2015 Michael Pohoreski
// Chars: 260
//
// Notes:
// - If you want to speed up / slow this down, change the contant in `d` iTime*0.2
//
// - A "naive" water filter is: 
//     #define F cos(x)*cos(y),sin(x)*sin(y)
//   We use this one:
//     #define F cos(x-y)*cos(y),sin(x+y)*sin(y)
// Feel free to post your suggestions!
//
// For uber minification,
// - You can replace:
//     2.0 / uvResolution.x
//   With say a hard-coded constant:
//     0.007
// Inline the #define

// Minified

#if 0

#define F cos(x-y)*cos(y),sin(x+y)*sin(y)
vec2 s(vec2 p){float d=iTime*0.2,x=8.*(p.x+d),y=8.*(p.y+d);return vec2(F);}
void mainImage( out vec4 f, in vec2 w ){vec2 i=iResolution.xy,r=w/i,q=r+2./iResolution.x*(s(r)-s(r+i));q.y=1.-q.y;f=texture(iChannel0,q);}


#else
// Cleaned up Source

vec2 shift( vec2 p ) {                        
    float d = iTime*speed;
    vec2 f = frequency * (p + d);
    vec2 q = cos( vec2(                        
       cos(f.x-f.y)*cos(f.y),                       
       sin(f.x+f.y)*sin(f.y) ) );                   
    return q;                                  
}                                             

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {                                 
    vec2 r = fragCoord.xy / iResolution.xy; 
    r.y = 1. - r.y;                     
    vec2 p = shift( r );             
    vec2 q = shift(r + 1.0);                        
    float amp = amplitude * 60.0 / iResolution.x;   
    vec2 s = r + amp * (p - q);
    s.y = 1. - s.y; // flip Y axis for ShaderToy
    fragColor = texture( iChannel0, s );
}
#endif 



#include "common/main_shadertoy.frag"
