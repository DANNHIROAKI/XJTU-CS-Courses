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

    // 更新物理状态
    center = next_state.position;
    prev_state = current_state;
    velocity = next_state.velocity;
    force = next_state.acceleration;
    force = force * mass;
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

