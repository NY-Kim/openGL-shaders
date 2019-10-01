#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;
uniform vec3 u_Camera;
uniform int u_Time;

in vec4 vs_Pos;
in vec4 vs_Nor;

out vec3 fs_Pos;
out vec3 fs_Nor;
out vec3 fs_LightVec;

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
    // TODO Homework 4
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    float n = noise(vec3(vs_Pos));
    vec4 pos = vec4(vs_Pos[0] * 0.2 * sin(0.03 * u_Time),
                    vs_Pos[1] * 0.1 * sin(0.02 * u_Time),
                    vs_Pos[2] * 0.3 * sin(0.025 * u_Time),
                    0);
    float s = smoothstep(0.0f, 1.0f, 0.3f);
    vec4 modelposition = u_Model * vs_Pos + s * vec4(fs_Nor, 0) + pos;
    fs_Pos = vec3(modelposition);
    fs_LightVec = vec3((inverse(u_View) * vec4(0,0,0,1)) - modelposition);
    gl_Position = u_Proj * u_View * modelposition;
}
