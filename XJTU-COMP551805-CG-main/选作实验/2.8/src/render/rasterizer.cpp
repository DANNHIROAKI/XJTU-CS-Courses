#include <array>
#include <limits>
#include <tuple>
#include <vector>
#include <algorithm>
#include <cmath>
#include <mutex>

#include <Eigen/Core>
#include <Eigen/Geometry>
#include <spdlog/spdlog.h>

#include "rasterizer.h"
#include "triangle.h"
#include "render_engine.h"
#include "../utils/math.hpp"

using Eigen::Matrix4f;
using Eigen::Vector2i;
using Eigen::Vector3f;
using Eigen::Vector4f;
using std::fill;
using std::tuple;

// 给定坐标(x,y)以及三角形的三个顶点坐标，判断(x,y)是否在三角形的内部
bool Rasterizer::inside_triangle(int x, int y, const Vector4f* vertices) 
{
    //v[0]=v0,v[1]=v1,v[2]=v1
    Eigen::Vector2f v[3];
    for (int i = 0; i < 3; ++i) {
        v[i] = Eigen::Vector2f(vertices[i][0], vertices[i][1]);
    }

    Eigen::Vector2f P(x, y);

    //vP[0]=v0P,vP[1]=v1P,vP[2]=v2P
    Eigen::Vector2f vP[3];
    for (int i = 0; i < 3; ++i) {
        vP[i] = P - v[i];
    }

    //vx[0]=v01,vx[1]=v02
    Eigen::Vector2f vx[2];
    vx[0] = v[1] - v[0];
    vx[1] = v[2] - v[0];

    float area1 = vx[0].x() * vx[1].y();
    float area2 = vx[0].y() * vx[1].x();
    float area = area1 - area2;

    float alpha1 = (vP[1].x() * vP[2].y()) / area;
    float alpha2 = (vP[1].y() * vP[2].x()) / area;
    float alpha = alpha1 - alpha2;

    float beta1 = (vP[2].x() * vP[0].y()) / area;
    float beta2 = (vP[2].y() * vP[0].x()) / area;
    float beta = beta1 - beta2;

    float gamma = 1 - alpha - beta;

    bool bool_a = (alpha >= 0);
    bool bool_b = (beta >= 0);
    bool bool_y = (gamma >= 0);

    bool result = bool_a && bool_b && bool_y;

    return result;
}

// 给定坐标(x,y)以及三角形的三个顶点坐标，计算(x,y)对应的重心坐标[alpha, beta, gamma]
tuple<float, float, float> Rasterizer::compute_barycentric_2d(float x, float y, const Vector4f* v) {
    Eigen::Vector2f points[3], P(x, y);
    for (int i = 0; i < 3; ++i) {
        points[i] = Eigen::Vector2f(v[i][0], v[i][1]);
    }

    Eigen::Vector2f vectors[2] = { points[1] - points[0], points[2] - points[0] };

    float area_parts[2] = { vectors[0].x() * vectors[1].y(), vectors[0].y() * vectors[1].x() };
    float area = area_parts[0] - area_parts[1];

    float barycentric_parts[6] = {
        (points[1] - P).x() * (points[2] - P).y(),
        (points[1] - P).y() * (points[2] - P).x(),
        (points[2] - P).x() * (points[0] - P).y(),
        (points[2] - P).y() * (points[0] - P).x()
    };

    float alpha = (barycentric_parts[0] - barycentric_parts[1]) / area;
    float beta = (barycentric_parts[2] - barycentric_parts[3]) / area;
    float gamma = 1.0f - alpha - beta;

    auto results = std::make_tuple(alpha, beta, gamma);

    return results;
}

// 对当前渲染物体的所有三角形面片进行遍历，进行几何变换以及光栅化
void Rasterizer::draw(const std::vector<Triangle>& TriangleList, const GL::Material& material,
                      const std::list<Light>& lights, const Camera& camera)
{
    auto triangleIterator = TriangleList.begin();

    while (triangleIterator != TriangleList.end()) {
        const Triangle& tri = *triangleIterator;
        std::array<VertexShaderPayload, 3> transformed_vertices;
        std::array<Vector3f, 3> world_positions;

        // 处理第一个顶点
        VertexShaderPayload payload0 { tri.vertex[0], tri.normal[0] };
        transformed_vertices[0] = vertex_shader(payload0);
        Eigen::Vector4f world_pos0 = model * tri.vertex[0];
        world_positions[0] = world_pos0.head<3>(); // 只取前三个分量(x, y, z)

        // 处理第二个顶点
        VertexShaderPayload payload1 { tri.vertex[1], tri.normal[1] };
        transformed_vertices[1] = vertex_shader(payload1);
        Eigen::Vector4f world_pos1 = model * tri.vertex[1];
        world_positions[1] = world_pos1.head<3>(); // 只取前三个分量(x, y, z)

        // 处理第三个顶点
        VertexShaderPayload payload2 { tri.vertex[2], tri.normal[2] };
        transformed_vertices[2] = vertex_shader(payload2);
        Eigen::Vector4f world_pos2 = model * tri.vertex[2];
        world_positions[2] = world_pos2.head<3>(); // 只取前三个分量(x, y, z)


        Triangle tramsformed_triangle;

        tramsformed_triangle.vertex[0] = transformed_vertices[0].position; // 顶点位置
        tramsformed_triangle.normal[0] = transformed_vertices[0].normal;   // 法线向量
        tramsformed_triangle.vertex[1] = transformed_vertices[1].position; // 顶点位置
        tramsformed_triangle.normal[1] = transformed_vertices[1].normal;   // 法线向量
        tramsformed_triangle.vertex[2] = transformed_vertices[2].position; // 顶点位置
        tramsformed_triangle.normal[2] = transformed_vertices[2].normal;   // 法线向量


        rasterize_triangle(tramsformed_triangle, world_positions, material, lights, camera);
        ++triangleIterator;
    }
}

// 对顶点的某一属性插值
Vector3f Rasterizer::interpolate(float alpha, float beta, float gamma, const Eigen::Vector3f& vert1,
                                 const Eigen::Vector3f& vert2, const Eigen::Vector3f& vert3,
                                 const Eigen::Vector3f& weight, const float& Z)
{
    Vector3f interpolated_res;
    for (int i = 0; i < 3; i++) {
        interpolated_res[i] = alpha * vert1[i] / weight[0] + beta * vert2[i] / weight[1] +
                              gamma * vert3[i] / weight[2];
    }
    interpolated_res *= Z;
    return interpolated_res;
}

// 对当前三角形进行光栅化
void Rasterizer::rasterize_triangle(const Triangle& t, const std::array<Vector3f, 3>& world_pos, 
                                    GL::Material material, const std::list<Light>& lights,
                                    Camera camera)
{

    int x = 0;
    while (x < width) {
        int y = 0;
        while (y < height) {
            // 判断像素是否在三角形内部
            bool inside = inside_triangle(x, y, t.vertex);
            if (inside == 1) {
                tuple<float, float, float> barycentric_tuple = compute_barycentric_2d(x, y, t.vertex);
                
                // parameter[0]=alpha,parameter[1]=beta,parameter[2]=gamma
                float parameter[3];
                parameter[0] = std::get<0>(barycentric_tuple);
                parameter[1] = std::get<1>(barycentric_tuple);
                parameter[2] = std::get<2>(barycentric_tuple);

                Eigen::Vector3f weight;
                for (int i = 0; i < 3; ++i) {
                    weight[i] = t.vertex[i][3];
                }


                float z = 0;
                for (int i = 0; i <= 2; i++) {
                    z = z + (parameter[i] / weight[i]);
                }
                float Z = 1 / z;
                
                float depth = 0;
                for (int i = 0; i <= 2; i++) {
                    depth = depth + parameter[i] * t.vertex[i][2] / weight[i];
                }

                depth *= Z;

                int now_index = get_index(x, y);
                int condition = depth < depth_buf[now_index] ? 0 : 1;  // 使用一个额外的变量来代表条件结果
                switch (condition) {
                   case 0:
                       depth_buf[now_index] = depth;
                       break;
                   case 1:
                      y++;
                      continue;
                      break;
                  default:
                      break;
                }

                
                std::array<Vector3f, 3> world_vertex_pos = world_pos;  // 世界坐标系下的顶点坐标

                Eigen::Vector3f interpolated[2];
                interpolated[0] = interpolate((std::get<0>(barycentric_tuple)), (std::get<1>(barycentric_tuple)), (std::get<2>(barycentric_tuple)), world_vertex_pos[0], world_vertex_pos[1], world_vertex_pos[2], weight, Z);
                interpolated[1] = interpolate((std::get<0>(barycentric_tuple)), (std::get<1>(barycentric_tuple)), (std::get<2>(barycentric_tuple)), (t.normal[0]), (t.normal[1]), (t.normal[2]), weight, Z);
                
                Eigen::Vector3f interpolated_vertex = interpolated[0];
                Eigen::Vector3f interpolated_normal = interpolated[1];
                interpolated_normal = interpolated_normal.normalized();

                FragmentShaderPayload interpolate_payload(interpolated_vertex, interpolated_normal);

                Eigen::Vector2i point(x, y);
                set_pixel(point, (Eigen::Vector3f)phong_fragment_shader(interpolate_payload, material, lights, camera));
            }
            y++;
        }
        x++;
    }
}

// 初始化整个光栅化渲染器
void Rasterizer::clear(BufferType buff)
{
    if ((buff & BufferType::Color) == BufferType::Color) {
        fill(frame_buf.begin(), frame_buf.end(), RenderEngine::background_color * 255.0f);
    }
    if ((buff & BufferType::Depth) == BufferType::Depth) {
        fill(depth_buf.begin(), depth_buf.end(), std::numeric_limits<float>::infinity());
    }
}

Rasterizer::Rasterizer(int w, int h) : width(w), height(h)
{
    frame_buf.resize(w * h);
    depth_buf.resize(w * h);
}

// 给定像素坐标(x,y)，计算frame buffer里对应的index
int Rasterizer::get_index(int x, int y)
{
    return (height - 1 - y) * width + x;
}

// 给定像素点以及fragement shader得到的结果，对frame buffer中对应存储位置进行赋值
void Rasterizer::set_pixel(const Vector2i& point, const Vector3f& res)
{
    int idx        = get_index(point.x(), point.y());
    frame_buf[idx] = res;
}
