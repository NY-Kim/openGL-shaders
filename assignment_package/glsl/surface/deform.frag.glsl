#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader
uniform int u_Time;

in vec3 fs_Pos;
in vec3 fs_Nor;
in vec3 fs_LightVec;
in float fs_Noise;

layout(location = 0) out vec3 out_Col;

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

void main()
{
    // Calculate the diffuse term for Lambert shading
    float t = dot(normalize(fs_Nor), normalize(fs_LightVec));
    // Avoid negative lighting values
    t = clamp(t, 0, 1);

    float n = noise(fs_Pos) * 0.3;
    vec3 a = vec3(1, 0.85, 0.88) + cos(0.03 * u_Time) * n;
    vec3 b = vec3(0.67, 1, 0.97) + cos(0.03 * u_Time) * n;
    vec3 c = vec3(0.79, 0.91, 0.97) + cos(0.03 * u_Time) * n;
    vec3 d = vec3(1, 0.78, 0.46) + cos(0.03 * u_Time) * n;

    out_Col = a + b * cos(2 * 3.14159 * (c * t + d)); // Iridescent shader
}
