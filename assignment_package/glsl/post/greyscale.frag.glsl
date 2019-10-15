#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

void main()
{
    vec4 diffuse_color = texture(u_RenderedTexture, fs_UV);
    float grey = diffuse_color.r * 0.21 + diffuse_color.g * 0.72 + diffuse_color.b * 0.07;

    float dist = distance(fs_UV, vec2(0.5, 0.5));
    float vignette = 1 - dist * 1.5;
    color = vec3(grey * vignette, grey * vignette, grey * vignette);
}
