#version 330 core
out vec4 FragColor;

uniform vec2 u_resolution;
uniform float u_time;
uniform float u_level; // audio level 0-1

#include "noise.glsl"

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;
  float n = snoise(uv * 3.0 + vec2(0.0, u_time * 0.05));
  float band = smoothstep(0.4,0.6,n + u_level*0.3);
  vec3 col = mix(vec3(0.0,0.2,0.3), vec3(0.6,0.8,1.0), band);
  FragColor = vec4(col,1.0);
}
