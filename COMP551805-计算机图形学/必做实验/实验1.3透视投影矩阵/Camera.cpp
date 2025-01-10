#include "camera.h"

#include <cmath>
#include <Eigen/Geometry>
#include "../utils/formatter.hpp"
#include <spdlog/spdlog.h>

#include "../utils/math.hpp"

#ifdef _WIN32
#undef near
#undef far
#endif

using Eigen::Affine3f;
using Eigen::Matrix3f;
using Eigen::Matrix4f;
using Eigen::Vector3f;
using Eigen::Vector4f;

Camera::Camera(const Eigen::Vector3f& position, const Eigen::Vector3f& target, float near_plane,
               float far_plane, float fov_y_degrees, float aspect_ratio)
    : position(position), target(target), near(near_plane), far(far_plane),
      fov_y_degrees(fov_y_degrees), aspect_ratio(aspect_ratio)
{
    world_up.x() = 0.0f;
    world_up.y() = 1.0f;
    world_up.z() = 0.0f;
}

Matrix4f Camera::view()
{
    // Compute the inverted view direction, up and right vectors related to
    // the camera itself.
    Vector3f inv_direction = (position - target).normalized();
    Vector3f right         = (world_up).cross(inv_direction).normalized();
    Vector3f up            = inv_direction.cross(right);
    // The view matrix is multiplication of a rotation and a translation
    // matrices: rotation represented by [right, up, inv_direction]^T and
    // translation represented by -position.
    Matrix4f view_matrix          = Matrix4f::Identity();
    view_matrix.block<1, 3>(0, 0) = right;
    view_matrix.block<1, 3>(1, 0) = up;
    view_matrix.block<1, 3>(2, 0) = inv_direction;
    view_matrix(0, 3)             = -right.dot(position);
    view_matrix(1, 3)             = -up.dot(position);
    view_matrix(2, 3)             = -inv_direction.dot(position);
    return view_matrix;
}

Matrix4f Camera::projection()
{
    // 将视角从度转换为弧度，因为tan函数需要弧度为参数
    const float fov_y = radians(fov_y_degrees);  
    
    // 计算近裁剪面上的顶部和右侧边界
    const float top   = near * std::tan(fov_y / 2.0f);  
    const float right = top * aspect_ratio;  
    
    // 根据对称性，计算近裁剪面上的左侧和底部边界
    const float left = -right;  
    const float bottom = -top;  

    Matrix4f projection = Matrix4f::Zero();  // 初始化投影矩阵为零矩阵

    // 根据透视投影矩阵的公式，填写矩阵的元素
    projection(0, 0) = 2.0f * near / (right - left);  // 元素(0,0)
    projection(1, 1) = 2.0f * near / (top - bottom);  // 元素(1,1)
    projection(0, 2) = (right + left) / (right - left);  // 元素(0,2)
    projection(1, 2) = (top + bottom) / (top - bottom);  // 元素(1,2)
    projection(2, 2) = -(far + near) / (far - near);  // 元素(2,2)
    projection(2, 3) = -2.0f * far * near / (far - near);  // 元素(2,3)
    projection(3, 2) = -1.0f;  // 元素(3,2)
    projection(3, 3) = 0.0f;  // 元素(3,3)

    return projection;  // 返回填写好的透视投影矩阵
}

