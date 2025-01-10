#include "ray.h"

#include <cmath>
#include <array>

#include <Eigen/Dense>
#include <spdlog/spdlog.h>

#include "../utils/math.hpp"

using Eigen::Matrix3f;
using Eigen::Matrix4f;
using Eigen::Vector2f;
using Eigen::Vector3f;
using Eigen::Vector4f;
using std::numeric_limits;
using std::optional;
using std::size_t;

constexpr float infinity = 1e5f;
constexpr float eps      = 1e-5f;

Intersection::Intersection() : t(numeric_limits<float>::infinity()), face_index(0)
{
}

Ray generate_ray(int width, int height, int x, int y, Camera& camera, float depth)
{
    // these lines below are just for compiling and can be deleted
    (void)width;
    (void)height;
    (void)x;
    (void)y;
    (void)depth;
    // these lines above are just for compiling and can be deleted


    // The ratio between the specified plane (width x height)'s depth and the image plane's depth.
    
    // Transfer the view-space position to world space.
    Vector3f world_pos;
    return {camera.position, (world_pos - camera.position).normalized()};
}

optional<Intersection> ray_triangle_intersect(const Ray& ray, const GL::Mesh& mesh, size_t index)
{
    // these lines below are just for compiling and can be deleted
    (void)ray;
    (void)mesh;
    (void)index;
    // these lines above are just for compiling and can be deleted
    Intersection result;
    
    if (result.t - infinity < -eps) {
        return result;
    } else {
        return std::nullopt;
    }
}









optional<Intersection> naive_intersect(const Ray& ray, const GL::Mesh& mesh, const Matrix4f& model) {
    Intersection result;
    float min_t = std::numeric_limits<float>::infinity();

    size_t i = 0; // 迭代变量
    while (i < mesh.faces.count()) {
        const auto& face = mesh.face(i);

        // 获取三角面的第一个顶点，并转换为全局坐标
        Eigen::Vector4f v0_homogeneous = mesh.vertex(face[0]).homogeneous();
        Vector3f v0 = (model * v0_homogeneous).hnormalized();

        // 获取三角面的第二个顶点，并转换为全局坐标
        Eigen::Vector4f v1_homogeneous = mesh.vertex(face[1]).homogeneous();
        Vector3f v1 = (model * v1_homogeneous).hnormalized();

        // 获取三角面的第三个顶点，并转换为全局坐标
        Eigen::Vector4f v2_homogeneous = mesh.vertex(face[2]).homogeneous();
        Vector3f v2 = (model * v2_homogeneous).hnormalized();


        // 计算三角面的法向量
        Vector3f normal = (v1 - v0).cross(v2 - v0).normalized();

        // 判断射线是否与平面相交
        float denominator = normal.dot(ray.direction);
        if (std::abs(denominator) < 1e-6) { // 避免除以零
            i++;
            continue;
        }

        float t = (v0 - ray.origin).dot(normal) / denominator;
        if (t < 0 || t >= min_t) { // 如果交点在射线起点之前或之后，则忽略
            i++;
            continue;
        }

        // 计算交点，并判断是否在三角形内
        Vector3f p = ray.origin + t * ray.direction;
        Vector3f c;

        // 边 v0v1
        Vector3f edge = v1 - v0;
        Vector3f vp = p - v0;
        c = edge.cross(vp);
        if (normal.dot(c) < 0) { i++; continue; } // p在边v0v1的外侧

        // 边 v1v2
        edge = v2 - v1;
        vp = p - v1;
        c = edge.cross(vp);
        if (normal.dot(c) < 0) { i++; continue; } // p在边v1v2的外侧

        // 边 v2v0
        edge = v0 - v2;
        vp = p - v2;
        c = edge.cross(vp);
        if (normal.dot(c) < 0) { i++; continue; } // p在边v2v0的外侧

        // 如果交点在三角形内部，更新最近交点
        if (t < min_t) {
            min_t = t;
            result.t = t;
            result.barycentric_coord = p;
            result.normal = normal;
        }

        i++;
    }

    if (min_t < std::numeric_limits<float>::infinity()) {
        return result;
    } else {
        return std::nullopt;
    }
}


