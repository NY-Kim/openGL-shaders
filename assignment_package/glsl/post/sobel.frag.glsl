#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

void main()
{
    mat3 kernel_h = mat3(vec3(3, 10, 3), vec3(0, 0, 0), vec3(-3, -10, -3));
    mat3 kernel_v = mat3(vec3(3, 0, -3), vec3(10, 0, -10), vec3(3, 0, -3));
    vec3 color_h;
    vec3 color_v;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            vec2 uv = fs_UV + vec2((i - 1) * 1.0 / u_Dimensions[0], (j - 1) * 1.0 / u_Dimensions[1]);
            vec4 col = texture(u_RenderedTexture, uv);
            color_h += kernel_h[i][j] * vec3(col);
            color_v += kernel_v[i][j] * vec3(col);
        }
    }

    color = vec3(sqrt(pow(color_h.r, 2) + pow(color_v.r, 2)),
                 sqrt(pow(color_h.g, 2) + pow(color_v.g, 2)),
                 sqrt(pow(color_h.b, 2) + pow(color_v.b, 2)));
//    color = vec3(0, 0, 0);


}
