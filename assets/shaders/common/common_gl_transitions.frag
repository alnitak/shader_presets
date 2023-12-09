uniform sampler2D iChannel0;
uniform sampler2D iChannel1;

// a value that moves from 0.0 to 1.0 during the transition.
uniform float progress;
// the ratio of the viewport. It equals width / height.
float ratio;

vec4 getFromColor(vec2 uv) {
  return texture( iChannel0, uv );
}

vec4 getToColor(vec2 uv) {
  return texture( iChannel1, uv );
}