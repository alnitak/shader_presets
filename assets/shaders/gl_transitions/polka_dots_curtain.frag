#include "../common/common_header.frag"
#include "../common/common_gl_transitions.frag"

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


#include "../common/main_gl_transitions.frag"
