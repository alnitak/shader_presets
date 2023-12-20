#include "../common/common_header.frag"


// ------ START SHADERTOY CODE -----
uniform float MAX_STEPS;
uniform float VOL_STEPS;
uniform float VOL_LENGTH;
uniform float VOL_DENSITY;

float hash(float n) 
{ 
    return fract(sin(n)*43758.5453); 
}

float noise(in vec3 x) 
{
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;
    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

float sdBox(vec3 p, vec3 b)
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

vec4 GetVolume(vec3 p) {

    p.x += (noise(p*0.02 + sin(iTime*0.01))-0.5)*50.0*cos(noise(vec3(iTime*0.2)));
    
    vec3 c = vec3(40.0, 0.0, 0.0);
    vec3 q = mod(p + 2.5*c, c) - 0.5*c;
    
    float d = 1.0 - sdBox(
        (q - vec3(sin(q.z * 0.1 + iTime)*10.0 + noise(q*0.1)*10.0, sin(q.z * 0.2)*2.0, 200.0)), // position
        vec3(1.0 - max(p.y*0.25, 0.5) + noise(vec3(q.x*0.2))*3.0, 10.0 * clamp((1.8 - p.z*0.01), 0.0, 1.2) + noise(p.zzz*0.1)*4.0, 200.0) // size
    );
    
    // Color
    vec3 col = mix(vec3(0.0, 1.0, 0.0), vec3(0.6 + (sin(iTime*0.08)*0.3), 0.8, 0.6), (p.y + 10.0) * 0.03);
    
    return vec4(col, d);

}

vec4 RayMarch(vec3 ro, vec3 rd) {

    float stepLength = VOL_LENGTH / float(VOL_STEPS);
    
    float volumeDensity = VOL_DENSITY;

    float density = 0.0;
    float transmittance = 1.0;
    vec3 energy = vec3(0.0);
    
    vec3 p = ro + rd;
    
    for (int i=0; i<MAX_STEPS; i++){
    
        if (transmittance < 0.05) break;
        
        float dsample = GetVolume(p).w;
    
        if (dsample > 0.001){
            
            density = clamp(dsample * volumeDensity, 0.0, 1.0);
            transmittance *= 1.0 - density;
            
            energy += density * transmittance;
        
        }
        
        p += rd * stepLength;
    }
    
    vec3 col = GetVolume(p).rgb;
    
    return vec4(energy, transmittance) * mix(vec4(0.5, 1.0 * (cos(iTime*0.1)*0.5 + 1.0), 1.0 * (sin(iTime*0.2)*0.5 + 1.0), 1.0), vec4(col, 1.0), transmittance);
    
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{

    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    uv.x = uv.x*2.0 - 1.0;
    uv.y = uv.y*2.0 - 0.5;
    if (uv.x < -1.0 || uv.y < -0.5) discard;
    
    // Ray origin
    vec3 ro = vec3(-20.0, -50.0, 0.0);
    // Ray direction
    vec3 rd = normalize(vec3(uv.x + 1.0, uv.y + 0.7, 1.0));
    
    vec4 col = RayMarch(ro, rd);
    
    // Sky color
    vec3 top_col = vec3(0.02, 0.04, 0.053);
    vec3 bot_col = vec3(0.1, 0.13, 0.25);
    vec3 sky = col.rgb + mix(top_col, bot_col, -uv.y*0.5) * col.a;
    
    // Stars
    float stars = clamp((0.013 - clamp(noise(vec3(uv.x, uv.y, 1.0) * 200.0f), 0.0, 0.013)) * 100.0, 0.0, 1.0);
    
    fragColor = vec4(sky + stars, 1.0);
    
}
// ------ END SHADERTOY CODE -----



#include "../common/main_shadertoy.frag"
