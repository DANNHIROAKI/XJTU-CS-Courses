void Scene::simulation_update()
{
    // 获取当前时间,这次模拟的总时长是上一帧时长与之前帧剩余时长的总和.
    duration delta_t = (duration)time_step;
    
    // 计算自上次模拟更新以来经过的时间,steady_clock::now()相当于current_time
    duration frame_duration = (auto)steady_clock::now() - last_update;

    // 剩余时间等于帧持续时间
    duration remained_duration = frame_duration;
    
    // 在模拟期间循环
    while (remained_duration >= delta_t)
    {
        // 在固定时间步长内循环更新物体状态
        auto groupIt = groups.begin();
        while (groupIt != groups.end()) 
        {
            auto& group = *groupIt;
            auto objectIt = group->objects.begin();
            while (objectIt != group->objects.end()) 
            {
                auto& object = *objectIt;
                object->update(all_objects);
                ++objectIt;
            }
            ++groupIt;
        }
        remained_duration = remained_duration - delta_t;
        auto simulation_duration_within_this_frame = std::chrono::duration_cast<std::chrono::milliseconds>(delta_t);
        last_update = last_update + simulation_duration_within_this_frame;
    }

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

