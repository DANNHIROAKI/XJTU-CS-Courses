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









void Object::update(vector<Object*>& all_objects) {
    // 更新动力学状态
    KineticState current_state{ center, velocity, force / mass };
    KineticState next_state = step(prev_state, current_state);

    float elasticity_coefficient = 1.0f; // 弹性系数
    auto switchs = BVH_for_collision;

    // 当不使用BVH进行碰撞检测时
    if (!switchs) {
        auto it = all_objects.begin();
        while (it != all_objects.end()) {
            auto& other = *it;
            if (other == this) {
                ++it;
                continue;
            }

            size_t i = 0;
            
            while (i < mesh.edges.count()) {
                // 获取边缘顶点索引
                array<size_t, 2> v_indices = mesh.edge(i);

                // 转换第一个顶点到全局坐标
                Vector3f v0 = mesh.vertex(v_indices[0]);
                Eigen::Vector4f v0_homogeneous = v0.homogeneous();
                Vector3f v0_global = (model() * v0_homogeneous).hnormalized();

                // 转换第二个顶点到全局坐标
                Vector3f v1 = mesh.vertex(v_indices[1]);
                Eigen::Vector4f v1_homogeneous = v1.homogeneous();
                Vector3f v1_global = (model() * v1_homogeneous).hnormalized();

                // 构建代表边缘的射线
                Vector3f edge_direction = v1_global - v0_global;
                Ray edge_ray{v0_global, edge_direction};

                // 使用射线与其他物体的网格进行碰撞检测
                auto intersection = naive_intersect(edge_ray, other->mesh, other->model());

                if (intersection && intersection->t > 0 && intersection->t < 1) {
                    // 碰撞响应
                    Vector3f other_velocity = other->velocity;
                    Vector3f relative_velocity = velocity - other_velocity;
                    Vector3f normal = intersection->normal.normalized();
                
                    // 计算冲量大小
                    float inverse_mass_sum = 1.0f / mass + 1.0f / other->mass;
                    float velocity_along_normal = relative_velocity.dot(normal);
                    float impulse_magnitude = elasticity_coefficient * 2.0f * velocity_along_normal / inverse_mass_sum;
                
                    // 应用冲量
                    Vector3f impulse = impulse_magnitude * normal;
                    velocity -= impulse / mass;
                    other->velocity += impulse / other->mass;
                
                    // 更新当前状态以避免重复碰撞
                    center = current_state.position;
                    prev_state = current_state;
                    return;
                }

                ++i;
            }
            ++it;
        }
    }
    else { // 使用 BVH 进行碰撞检测
        auto it = all_objects.begin();
        while (it != all_objects.end()) {
            auto object = *it;
    
            if (object != this) {
                size_t i = 0;

                while (i < mesh.edges.count()) {
                    // 获取边缘顶点索引
                    array<size_t, 2> v_indices = mesh.edge(i);

                    // 转换边缘顶点到全局坐标
                    Vector3f v0 = mesh.vertex(v_indices[0]);
                    Eigen::Vector4f v0_homogeneous = v0.homogeneous();
                    Vector3f v0_global = (model() * v0_homogeneous).hnormalized();

                    Vector3f v1 = mesh.vertex(v_indices[1]);
                    Eigen::Vector4f v1_homogeneous = v1.homogeneous();
                    Vector3f v1_global = (model() * v1_homogeneous).hnormalized();

                    // 构建代表边缘的射线
                    Vector3f edge_direction = v1_global - v0_global;
                    Ray edge_ray{v0_global, edge_direction};

                    // 使用射线与其他物体的网格进行碰撞检测
                    auto model_ini = object->model();
                    auto intersection = object->bvh->intersect(edge_ray, object->bvh->mesh, model_ini);

                    bool ex_1 = intersection->t > 0;
                    bool ex_2 = intersection->t < 1;
                    if (intersection && ex_1 && ex_2) 
                    {
                        // 碰撞响应
                        Vector3f other_velocity = object->velocity;
                        Vector3f relative_velocity = velocity - other_velocity;
                        Vector3f normal = intersection->normal;

                        // 计算冲量大小
                        float inverse_mass_sum = 1.0f / mass + 1.0f / object->mass;
                        float velocity_along_normal = relative_velocity.dot(normal);
                        float impulse_magnitude = 2.0f * velocity_along_normal / inverse_mass_sum;

                        // 应用冲量
                        Vector3f impulse = impulse_magnitude * normal;
                        velocity -= impulse / mass;
                        object->velocity += impulse / object->mass;

                        // 更新当前状态以避免重复碰撞
                        center = current_state.position;
                        return;
                    }

                    ++i;
               }
            }

            ++it;
        }
    }


    // 更新物理状态
    center = next_state.position;
    prev_state = current_state;
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
