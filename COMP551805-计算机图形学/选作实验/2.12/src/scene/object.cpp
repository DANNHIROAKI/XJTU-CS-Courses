#include "object.h"

#include <array>
#include <optional>

#ifdef _WIN32
#include <Windows.h>
#endif
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <fmt/format.h>

#include "../utils/math.hpp"
#include "../utils/ray.h"
#include "../simulation/solver.h"
#include "../utils/logger.h"

using Eigen::Matrix4f;
using Eigen::Quaternionf;
using Eigen::Vector3f;
using std::array;
using std::make_unique;
using std::optional;
using std::string;
using std::vector;

bool Object::BVH_for_collision   = false;
size_t Object::next_available_id = 0;
std::function<KineticState(const KineticState&, const KineticState&)> Object::step =
    forward_euler_step;

Object::Object(const string& object_name)
    : name(object_name), center(0.0f, 0.0f, 0.0f), scaling(1.0f, 1.0f, 1.0f),
      rotation(1.0f, 0.0f, 0.0f, 0.0f), velocity(0.0f, 0.0f, 0.0f), force(0.0f, 0.0f, 0.0f),
      mass(1.0f), BVH_boxes("BVH", GL::Mesh::highlight_wireframe_color)
{
    visible  = true;
    modified = false;
    id       = next_available_id;
    ++next_available_id;
    bvh                      = make_unique<BVH>(mesh);
    const string logger_name = fmt::format("{} (Object ID: {})", name, id);
    logger                   = get_logger(logger_name);
}

Matrix4f Object::model()
{
 // 第一步: 将四元数表示的旋转转换为 ZYX 欧拉角 (角度制)
 const Quaternionf& r = rotation;
 auto [x_angle_deg, y_angle_deg, z_angle_deg] = quaternion_to_ZYX_euler(r.w(), r.x(), r.y(), r.z());
 // 将角度转换为弧度
 auto x_angle_rad = radians(x_angle_deg);
 auto y_angle_rad = radians(y_angle_deg);
 auto z_angle_rad = radians(z_angle_deg);
 // 第二步: 使用欧拉角(弧度制)构建旋转矩阵
 Eigen::Matrix4f rotationMatrix = Eigen::Matrix4f::Identity();
 Eigen::Matrix4f rotationX = Eigen::Matrix4f::Identity();
 Eigen::Matrix4f rotationY = Eigen::Matrix4f::Identity();
 Eigen::Matrix4f rotationZ = Eigen::Matrix4f::Identity();
 // 设置绕x轴的旋转矩阵
 rotationX <<
     1, 0, 0, 0,
     0, cos(x_angle_rad), -sin(x_angle_rad), 0,
     0, sin(x_angle_rad), cos(x_angle_rad), 0,
     0, 0, 0, 1;
 // 设置绕y轴的旋转矩阵
 rotationY <<
     cos(y_angle_rad), 0, sin(y_angle_rad), 0,
     0, 1, 0, 0,
     -sin(y_angle_rad), 0, cos(y_angle_rad), 0,
     0, 0, 0, 1;
 // 设置绕z轴的旋转矩阵
 rotationZ <<
     cos(z_angle_rad), -sin(z_angle_rad), 0, 0,
     sin(z_angle_rad), cos(z_angle_rad), 0, 0,
     0, 0, 1, 0,
     0, 0, 0, 1;
 // 将三个旋转矩阵组合成一个完整的旋转矩阵
 rotationMatrix = rotationX * rotationY * rotationZ;
 // 第三步: 构建缩放矩阵
 Eigen::Matrix4f scalingMatrix = Eigen::Matrix4f::Identity();
 scalingMatrix(0, 0) = scaling.x();
 scalingMatrix(1, 1) = scaling.y();
 scalingMatrix(2, 2) = scaling.z();
 // 第四步: 构建平移矩阵
 Eigen::Matrix4f translationMatrix = Eigen::Matrix4f::Identity();
 translationMatrix(0, 3) = center.x();
 translationMatrix(1, 3) = center.y();
 translationMatrix(2, 3) = center.z();
 // 将缩放、旋转和平移矩阵组合成模型变换矩阵，并返回
 return translationMatrix * rotationMatrix * scalingMatrix;
}






void Object::update(vector<Object*>& all_objects)
{
    // 首先调用 step 函数计下一步该物体的运动学状态。
    KineticState current_state{center, velocity, force / mass};
    KineticState next_state = step(prev_state, current_state);
    

    //目前不用管这块
    for (auto object : all_objects) 
    {
        (void)object;
    }
    
    // 将上一步状态赋值为当前状态，并将物体更新到下一步状态。

	prev_state = current_state;
    center = next_state.position;
	velocity = next_state.velocity;
	force = next_state.acceleration;
    force = force * mass;
}







void Object::render(const Shader& shader, WorkingMode mode, bool selected)
{
    if (modified) {
        mesh.VAO.bind();
        mesh.vertices.to_gpu();
        mesh.normals.to_gpu();
        mesh.edges.to_gpu();
        mesh.edges.release();
        mesh.faces.to_gpu();
        mesh.faces.release();
        mesh.VAO.release();
    }
    modified = false;
    // Render faces anyway.
    unsigned int element_flags = GL::Mesh::faces_flag;
    if (mode == WorkingMode::MODEL) {
        // For *Model* mode, only the selected object is rendered at the center in the world.
        // So the model transform is the identity matrix.
        shader.set_uniform("model", I4f);
        shader.set_uniform("normal_transform", I4f);
        element_flags |= GL::Mesh::vertices_flag;
        element_flags |= GL::Mesh::edges_flag;
    } else {
        Matrix4f model = this->model();
        shader.set_uniform("model", model);
        shader.set_uniform("normal_transform", (Matrix4f)(model.inverse().transpose()));
    }
    // Render edges of the selected object for modes with picking enabled.
    if (check_picking_enabled(mode) && selected) {
        element_flags |= GL::Mesh::edges_flag;
    }
    mesh.render(shader, element_flags);
}

void Object::rebuild_BVH()
{
    bvh->recursively_delete(bvh->root);
    bvh->build();
    BVH_boxes.clear();
    refresh_BVH_boxes(bvh->root);
    BVH_boxes.to_gpu();
}

void Object::refresh_BVH_boxes(BVHNode* node)
{
    if (node == nullptr) {
        return;
    }
    BVH_boxes.add_AABB(node->aabb.p_min, node->aabb.p_max);
    refresh_BVH_boxes(node->left);
    refresh_BVH_boxes(node->right);
}
