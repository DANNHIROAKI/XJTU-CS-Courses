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