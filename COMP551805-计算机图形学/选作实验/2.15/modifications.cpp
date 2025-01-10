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