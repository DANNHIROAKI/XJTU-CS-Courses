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