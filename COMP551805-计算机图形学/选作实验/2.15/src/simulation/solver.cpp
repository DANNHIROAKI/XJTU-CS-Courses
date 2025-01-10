#include "solver.h"

#include <Eigen/Core>

using Eigen::Vector3f;

// External Force does not changed.

// Function to calculate the derivative of KineticState
KineticState derivative(const KineticState& state)
{
    return KineticState(state.velocity, state.acceleration, Eigen::Vector3f(0, 0, 0));
}








KineticState symplectic_euler_step(const KineticState& previous, const KineticState& current)
{
    (void)previous;

    KineticState future;
    auto delta_t = time_step;
    auto delta_v = current.acceleration * delta_t;
    auto delta_x = future.velocity * delta_t;
    
    future.acceleration = current.acceleration;
    future.velocity = current.velocity + delta_v;
    future.position = current.position + delta_x;
    return future;
}


KineticState backward_euler_step([[maybe_unused]] const KineticState& previous,const KineticState& current)
{
    KineticState future;
    auto delta_t = time_step;
    auto delta_v = future.acceleration * delta_t;
    auto delta_x = future.velocity * delta_t;

    future.acceleration = current.acceleration;
    future.velocity = current.velocity + delta_v;
    future.position = current.position + delta_x;
    return future;
}

KineticState runge_kutta_step([[maybe_unused]] const KineticState& previous, const KineticState& current) {
    KineticState future;
    auto delta_t = time_step;

    // 计算速度的斜率
    auto a_n = delta_t * current.acceleration;
    Eigen::Vector3f k1_v = a_n;
    auto delta_a1 = delta_t * 0.5f * k1_v;
    Eigen::Vector3f k2_v = a_n + delta_a1;
    auto delta_a2 = delta_t * 0.5f * k2_v;
    Eigen::Vector3f k3_v = a_n + delta_a2;
    auto delta_a3 = delta_t * 1.0f * k3_v;
    Eigen::Vector3f k4_v = a_n + delta_a3;
    


    // 计算位置的斜率
    auto v_n = delta_t * current.velocity;
    Eigen::Vector3f k1_x = v_n;
    auto delta_v1 = delta_t * 0.5f * k1_v;
    Eigen::Vector3f k2_x = v_n + delta_v1;
    auto delta_v2 = delta_t * 0.5f * k2_v;
    Eigen::Vector3f k3_x = v_n + delta_v2;
    auto delta_v3 = delta_t * 1.0f * k3_v;
    Eigen::Vector3f k4_x = v_n + delta_v3;

    // 更新加速度、速度和位置
    auto delta_v = k1_v + 2.0f * k2_v + 2.0f * k3_v + k4_v;
    auto delta_x = k1_x + 2.0f * k2_x + 2.0f * k3_x + k4_x;

    future.acceleration = current.acceleration; // 加速度通常由外部力确定
    future.velocity = current.velocity + (1.0f / 6.0f) * delta_v;
    future.position = current.position + (1.0f / 6.0f) * delta_x;

    return future;
}

KineticState forward_euler_step([[maybe_unused]]const KineticState& previous, const KineticState& current)
{
    KineticState future;
    auto delta_t = time_step;
    auto delta_v = current.acceleration * delta_t;
    auto delta_x = current.velocity * delta_t;

    future.velocity = current.velocity + delta_v;
    future.position = current.position + delta_x;
    future.acceleration = current.acceleration;
    return future;
    //return current;
} 



