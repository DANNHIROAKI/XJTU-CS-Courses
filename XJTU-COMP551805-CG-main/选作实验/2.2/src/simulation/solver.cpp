#include "solver.h"

#include <Eigen/Core>

using Eigen::Vector3f;

// External Force does not changed.

// Function to calculate the derivative of KineticState
KineticState derivative(const KineticState& state)
{
    return KineticState(state.velocity, state.acceleration, Eigen::Vector3f(0, 0, 0));
}


KineticState forward_euler_step([[maybe_unused]] const KineticState& previous,
                                const KineticState& current)
{
    // 计算时间步长
    float delta_time = time_step;

    // 计算下一位置
    Eigen::Vector3f position_increment = current.velocity * delta_time;
    Eigen::Vector3f next_position = current.position + position_increment;

    // 计算下一速度
    Eigen::Vector3f velocity_increment = current.acceleration * delta_time;
    Eigen::Vector3f next_velocity = current.velocity + velocity_increment;

    // 创建下一个运动状态
    Eigen::Vector3f next_acceleration = current.acceleration; // 保持加速度不变
    KineticState next_state(next_position, next_velocity, next_acceleration);

    // 返回下一个状态
    return next_state;
}

//////////////////////////////////////////////////////////////////////
KineticState runge_kutta_step([[maybe_unused]]const KineticState& previous, const KineticState& current) {
    float delta_time = time_step; // 假设time_step已经定义
    KineticState k[4];
    KineticState temp = current;

    for (int i = 0; i < 4; ++i) {
        KineticState deriv = derivative(temp);
        deriv.position = temp.velocity * delta_time;
        deriv.velocity = temp.acceleration * delta_time;

        k[i] = deriv;

        if (i < 3) { // 对于k1, k2, k3需要更新temp
            float factor = (i == 0) ? 0.5f : ((i == 1) ? 0.5f : 1.0f);
            temp.position = current.position + k[i].position * factor;
            temp.velocity = current.velocity + k[i].velocity * factor;
        }
    }

    Eigen::Vector3f next_position = current.position;
    Eigen::Vector3f next_velocity = current.velocity;

    for (int i = 0; i < 4; ++i) {
        float weight = (i == 0 || i == 3) ? 1.0f : 2.0f;
        next_velocity += weight * (k[i].velocity / 6.0f);
    }

    for (int i = 0; i < 4; ++i) {
        float weight = (i == 0 || i == 3) ? 1.0f : 2.0f;
        next_position += weight * (k[i].position / 6.0f);
    }
    
    KineticState stste = KineticState(next_position, next_velocity, current.acceleration);
    return stste;
}


KineticState backward_euler_step([[maybe_unused]]const KineticState& previous, const KineticState& current) 
{
    KineticState next_state;
    float dt;
    dt = time_step;
    auto dv = current.acceleration * dt;
    next_state.velocity = current.velocity + dv;
    auto ds = next_state.velocity * dt;
    next_state.position = current.position + ds;
    next_state.acceleration = current.acceleration;
    return next_state;
}


KineticState symplectic_euler_step([[maybe_unused]]const KineticState& previous, const KineticState& current)
{
    KineticState next_state;
    float dt;
    dt = time_step;
    Eigen::Vector3f dv = current.acceleration * dt;
    next_state.velocity = current.velocity + dv;
    Eigen::Vector3f ds = next_state.velocity * dt;
    next_state.position = current.position + ds;
    next_state.acceleration = current.acceleration;
    return next_state;
}
//////////////////////////////////////////////////////////////////////