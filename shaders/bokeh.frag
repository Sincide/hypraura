#version 330 core
out vec4 FragColor;

uniform vec2 u_resolution;
uniform float u_time;

float rnd(vec2 n){return fract(sin(dot(n, vec2(12.9898,78.233))) * 43758.5453);}

void main(){
  vec2 uv = gl_FragCoord.xy / u_resolution;
  float t = u_time * 0.2;
  float glow = 0.0;
  for(int i=0;i<5;i++){
    vec2 p = vec2(rnd(vec2(i,0.1))*u_resolution.x, rnd(vec2(i,0.2))*u_resolution.y);
    float d = length(gl_FragCoord.xy - p + vec2(0.0, t*40.0));
    glow += smoothstep(40.0,20.0,d);
  }
  FragColor = vec4(vec3(glow*0.1), glow*0.1);
}
