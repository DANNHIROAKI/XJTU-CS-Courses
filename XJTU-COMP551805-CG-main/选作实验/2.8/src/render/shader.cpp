#include "shader.h"
#include "../utils/math.hpp"

#ifdef _WIN32
#undef min
#undef max
#endif

using Eigen::Vector3f;
using Eigen::Vector4f;

// vertex shader & fragement shader can visit
// all the static variables below from Uniforms structure
Eigen::Matrix4f Uniforms::MVP;
Eigen::Matrix4f Uniforms::inv_trans_M;
int Uniforms::width;
int Uniforms::height;

float normalizeCoordinate(float coordinate, float dimension) {
    return (coordinate + 1.0f) * dimension / 2.0f;
}
void adjustPosition(Eigen::Vector4f& position) {
    if (position.w() != 0.0f) {
        position.x() = position.x()/position.w();
        position.y() = position.y()/position.w();
    }

    position.x() = normalizeCoordinate(position.x(), Uniforms::width);
    position.y() = normalizeCoordinate(position.y(), Uniforms::height);
}
VertexShaderPayload vertex_shader(const VertexShaderPayload& payload)
{
    VertexShaderPayload output;

    // Transforming the normal vector
    Eigen::Vector4f normal_4d;
    for (int i = 0; i < 3; ++i) {
        normal_4d[i] = payload.normal[i];
    }
    normal_4d[3] = 0.0f; // 显式设置 w 分量为 0

    normal_4d = Uniforms::inv_trans_M * normal_4d;
    normal_4d.normalize();

    Eigen::Vector3f normal_3d;
    for (int i = 0; i < 3; ++i) {
        normal_3d[i] = normal_4d[i];
    }
    output.normal = normal_3d;

    Eigen::Vector4f position = Uniforms::MVP * payload.position;
    adjustPosition(position); // 使用重构后的函数来调整位置
    output.position = position;

    return output;
}

Vector3f phong_fragment_shader(const FragmentShaderPayload& payload, GL::Material material,
                               const std::list<Light>& lights, Camera camera)
{
    Eigen::Vector3f color;
    for (int i = 0; i < 3; ++i) {
        color[i] = 0;
    }


    auto light_it = lights.begin();
    while (light_it != lights.end())
    {
        color = color            ////////极度抽象写法，仅供娱乐，请勿模仿
              + (std::max(((light_it->position 
              - (payload.world_pos)).normalized()).dot((payload.world_normal.normalized())), 0.0f)) 
              * material.diffuse 
              * (light_it->intensity 
              / ((light_it->position 
              - (payload.world_pos)).squaredNorm())) 
              + (pow(std::max((payload.world_normal.normalized()).dot(((((light_it->position 
              - (payload.world_pos)).normalized()) 
              + ((camera.position 
              - (payload.world_pos)).normalized())).normalized())), 0.0f), material.shininess)) 
              * material.specular 
              * (light_it->intensity 
              / ((light_it->position 
              - (payload.world_pos)).squaredNorm()));

        ++light_it;
    }

    color = color + material.ambient;

    color = color.cwiseMin(Vector3f(1, 1, 1));
    color = color*255.0f;

    return color;
}
