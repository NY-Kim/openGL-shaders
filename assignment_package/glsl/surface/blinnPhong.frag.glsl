#version 330

//This is a fragment shader. If you've opened this file first, please open and read lambert.vert.glsl before reading on.
//Unlike the vertex shader, the fragment shader actually does compute the shading of geometry.
//For every pixel in your program's output screen, the fragment shader is run for every bit of geometry that particular pixel overlaps.
//By implicitly interpolating the position data passed into the fragment shader by the vertex shader, the fragment shader
//can compute what color to apply to its pixel based on things like vertex position, light position, and vertex color.

uniform sampler2D u_Texture; // The texture to be read from by this shader

//These are the interpolated values out of the rasterizer, so you can't know
//their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec2 fs_UV;

in vec4 fs_CameraPos;
in vec4 fs_Pos;

layout(location = 0) out vec3 out_Col;//This is the final output color that you will see on your screen for the pixel that is currently being processed.

void main()
{
    vec4 diffuse_color = texture(u_Texture, fs_UV);

    float diffuse_term = dot(normalize(fs_Nor), normalize(fs_LightVec));
    diffuse_term = clamp(diffuse_term, 0, 1);
    float ambient_term = 0.2f;

    vec4 view_vector = fs_CameraPos - fs_Pos;
    vec4 light_vector = fs_LightVec;
    vec4 halfway_vector = normalize((view_vector + light_vector) / 2);

    float exp = 50.0f;
    vec4 surface_normal = normalize(fs_Nor);
    float specular_intensity = max(pow(dot(halfway_vector, surface_normal), exp), 0);

    float light_intensity = diffuse_term + ambient_term + specular_intensity; 

    out_Col = vec3(diffuse_color.rgb * light_intensity);
}
