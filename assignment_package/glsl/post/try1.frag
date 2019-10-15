#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}

vec2 random2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5,183.3)))) * 43758.5453);
}

float WorleyNoise(vec2 uv, float rand) {
    uv *= rand; // Now the space is 10x10 instead of 1x1. Change this to any number you want.
    vec2 uvInt = floor(uv);
    vec2 uvFract = fract(uv);
    float minDist = 1.0; // Minimum distance initialized to max.
    for(int y = -1; y <= 1; ++y) {
        for(int x = -1; x <= 1; ++x) {
            vec2 neighbor = vec2(float(x), float(y)); // Direction in which neighbor cell lies
            vec2 point = random2(uvInt + neighbor); // Get the Voronoi centerpoint for the neighboring cell
            vec2 diff = neighbor + point - uvFract; // Distance between fragment coord and neighbor’s Voronoi point
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}


void main()
{
    float kernel[121] = float[](0.006849, 0.007239, 0.007559, 0.007795, 0.007941, 0.007990, 0.007941, 0.007795, 0.007559, 0.007239, 0.006849,
                                0.007239, 0.007653, 0.007990, 0.008240, 0.008394, 0.008446, 0.008394, 0.008240, 0.007990, 0.007653, 0.007239,
                                0.007559, 0.007990, 0.008342, 0.008604, 0.008764, 0.008819, 0.008764, 0.008604, 0.008342, 0.007990, 0.007559,
                                0.007795, 0.008240, 0.008604, 0.008873, 0.009039, 0.009095, 0.009039, 0.008873, 0.008604, 0.008240, 0.007795,
                                0.007941, 0.008394, 0.008764, 0.009039, 0.009208, 0.009265, 0.009208, 0.009039, 0.008764, 0.008394, 0.007941,
                                0.007990, 0.008446, 0.008819, 0.009095, 0.009265, 0.009322, 0.009265, 0.009095, 0.008819, 0.008446, 0.007990,
                                0.007941, 0.008394, 0.008764, 0.009039, 0.009208, 0.009265, 0.009208, 0.009039, 0.008764, 0.008394, 0.007941,
                                0.007795, 0.008240, 0.008604, 0.008873, 0.009039, 0.009095, 0.009039, 0.008873, 0.008604, 0.008240, 0.007795,
                                0.007559, 0.007990, 0.008342, 0.008604, 0.008764, 0.008819, 0.008764, 0.008604, 0.008342, 0.007990, 0.007559,
                                0.007239, 0.007653, 0.007990, 0.008240, 0.008394, 0.008446, 0.008394, 0.008240, 0.007990, 0.007653, 0.007239,
                                0.006849, 0.007239, 0.007559, 0.007795, 0.007941, 0.007990, 0.007941, 0.007795, 0.007559, 0.007239, 0.006849);

    for (int i = 0; i < 11; i++)
    {
        for (int j = 0; j < 11; j++)
        {
            float dist = WorleyNoise(fs_UV, mod289(u_Time) * 100 + 200);
            vec2 uv = fs_UV + vec2((i - 5) * 1.0 / u_Dimensions[0], (j - 5) * 1.0 / u_Dimensions[1]);
            if (u_Time % 10 < 1) {
                uv -= vec2(0.3 * sin(0.03 * u_Time), 0);
            } else if (u_Time % 10 > 4 && u_Time % 10 < 4) {
                uv += vec2(0, 0.4 * sin(15 * u_Time));
            } else if (u_Time % 10 > 7 && u_Time % 10 < 8) {
                uv -= vec2(0.2 * sin(20 * u_Time), 0.5 * sin(0.03 * u_Time));
            } else if (u_Time % 10 >= 9) {
                uv += vec2(0.2 * sin(20 * u_Time), 0.5 * sin(0.03 * u_Time));
            }

            vec4 col = texture(u_RenderedTexture, uv);
            float luminance = col.r * 0.21 + col.g * 0.72 + col.b * 0.07;
            if (dist < luminance || mod289(dist * u_Time) < 0.5) {
                color = vec3(1, 1, 1);
            } else {
                color = vec3(0, 0, 0);
            }
        }
    }
}
