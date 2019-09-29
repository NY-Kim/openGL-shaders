#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec3 fs_Nor;
in vec3 fs_LightVec;

layout(location = 0) out vec3 out_Col;

void main()
{
    float t = dot(normalize(fs_Nor), normalize(fs_LightVec));
    t = clamp(t, 0, 1);

    vec3 a = vec3(1, 0.85, 0.88);
    vec3 b = vec3(0.67, 1, 0.97);
    vec3 c = vec3(0.79, 0.91, 0.97);
    vec3 d = vec3(1, 0.78, 0.46);

    out_Col = a + b * cos(2 * 3.14 * (c * t + d));
}
