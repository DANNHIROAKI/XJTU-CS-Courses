#include "solver.h"

#include <Eigen/Core>

using Eigen::Vector3f;

// External Force does not changed.

// Function to calculate the derivative of KineticState
KineticState derivative(const KineticState& state)
{
    return KineticState(state.velocity, state.acceleration, Eigen::Vector3f(0, 0, 0));
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










// Function to perform a single Runge-Kutta step
KineticState runge_kutta_step([[maybe_unused]] const KineticState& previous,
                              const KineticState& current)
{
    return current;
}

// Function to perform a single Backward Euler step
KineticState backward_euler_step([[maybe_unused]] const KineticState& previous,
                                 const KineticState& current)
{
    return current;
}

// Function to perform a single Symplectic Euler step
KineticState symplectic_euler_step(const KineticState& previous, const KineticState& current)
{
    (void)previous;
    return current;
}
