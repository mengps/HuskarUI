#version 450

layout(location = 0) in vec4 qt_Vertex;
layout(location = 1) in vec2 qt_MultiTexCoord0;
layout(location = 0) out vec2 qt_TexCoord0;

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

void main() {
    qt_TexCoord0 = qt_MultiTexCoord0;
    gl_Position = qt_Matrix * qt_Vertex;
}
