#version 450

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    // custom uniforms
    vec2 resolution;
    float refraction;
    float bevelDepth;
    float bevelWidth;
    float frost;
    float radius;
    float specularIntensity;
    float tiltX;
    float tiltY;
    float magnify;
    float iTime;
};

layout(binding = 1) uniform sampler2D source;

float sdRoundBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + r;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float edgeFactor(vec2 uv, float radius_px) {
    vec2 p_px = (uv - 0.5) * resolution;
    vec2 b_px = 0.5 * resolution;
    float d = -sdRoundBox(p_px, b_px, radius_px);   // inside = positive
    float bevel_px = bevelWidth * min(resolution.x, resolution.y);
    return 1.0 - smoothstep(0.0, bevel_px, d);
}

void main() {
    vec2 uv = qt_TexCoord0;

    vec2 p = uv - 0.5;
    p.x *= resolution.x / resolution.y;

    vec2 p_px = (uv - 0.5) * resolution;
    vec2 b_px = 0.5 * resolution;
    float dmask = sdRoundBox(p_px, b_px, radius);

    float inShape = 1.0 - smoothstep(-1.0, 1.0, dmask);

    if (inShape <= 0.0) {
        fragColor = vec4(0.0);
        return;
    }

    float edge = edgeFactor(uv, radius);
    float offsetAmt = edge * refraction + pow(edge, 10.0) * bevelDepth;
    float centreBlend = smoothstep(0.15, 0.45, length(p));
    vec2 offset = normalize(p + vec2(0.0001)) * offsetAmt * centreBlend;

    float tiltRefractionScale = 0.05;
    vec2 tiltOff = vec2(tan(radians(tiltY)), -tan(radians(tiltX))) * tiltRefractionScale;

    float magnifyScale = max(1.0 / max(magnify, 0.001), 1.0);
    float refrScale = 1.0 + 2.0 * (refraction + bevelDepth);
    float srcScale = max(max(magnifyScale, refrScale), 1.1);

    vec2 localUV = (uv - 0.5) / (srcScale * magnify) + 0.5;
    vec2 refracted = localUV + offset / srcScale - tiltOff / srcScale;

    float oob = max(max(-refracted.x, refracted.x - 1.0),
                    max(-refracted.y, refracted.y - 1.0));
    float blendOob = 1.0 - smoothstep(0.0, 0.01, oob);
    vec2 sampleUV = mix(localUV, refracted, blendOob);
    sampleUV = clamp(sampleUV, vec2(0.001), vec2(0.999));

    vec4 baseCol = texture(source, clamp(localUV, vec2(0.001), vec2(0.999)));

    vec2 texel = 1.0 / resolution;
    vec4 refrCol;

    if (frost > 0.0) {
        float blurRadius = frost * 4.0 * (1.0 - edge);
        vec4 sum = vec4(0.0);
        const int SAMPLES = 16;
        for (int i = 0; i < SAMPLES; i++) {
            float angle = random(uv + float(i)) * 6.283185;
            float dist  = sqrt(random(uv - float(i))) * blurRadius;
            vec2 off = vec2(cos(angle), sin(angle)) * texel * dist;
            sum += texture(source, clamp(sampleUV + off, vec2(0.001), vec2(0.999)));
        }
        refrCol = sum / float(SAMPLES);
    } else {
        /* 5-tap cross filter (equal weight, matching liquidGL) */
        refrCol  = texture(source, sampleUV);
        refrCol += texture(source, clamp(sampleUV + vec2( texel.x, 0.0), vec2(0.001), vec2(0.999)));
        refrCol += texture(source, clamp(sampleUV + vec2(-texel.x, 0.0), vec2(0.001), vec2(0.999)));
        refrCol += texture(source, clamp(sampleUV + vec2(0.0,  texel.y), vec2(0.001), vec2(0.999)));
        refrCol += texture(source, clamp(sampleUV + vec2(0.0, -texel.y), vec2(0.001), vec2(0.999)));
        refrCol /= 5.0;
    }

    if (refrCol.a < 0.1) {
        refrCol = baseCol;
    }

    vec4 finalCol = refrCol;

    if (specularIntensity > 0.0) {
        vec2 lp1 = vec2(sin(iTime * 0.2), cos(iTime * 0.3)) * 0.6 + 0.5;
        vec2 lp2 = vec2(sin(iTime * -0.4 + 1.5), cos(iTime * 0.25 - 0.5)) * 0.6 + 0.5;
        float h = 0.0;
        h += smoothstep(0.4, 0.0, distance(uv, lp1)) * 0.1;
        h += smoothstep(0.5, 0.0, distance(uv, lp2)) * 0.08;
        finalCol.rgb += h * specularIntensity;
    }

    finalCol *= inShape;

    fragColor = finalCol * qt_Opacity;
}
