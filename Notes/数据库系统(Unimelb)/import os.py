import os
import shutil

# 源目录和目标目录
source_dir = r"H:\OneDrive\%%相册\%杂项"
destination_dir = r"H:\OneDrive\%%相册\%杂项\QQ"

# 创建目标目录（如果不存在）
os.makedirs(destination_dir, exist_ok=True)

# 遍历源目录下的所有文件和子目录
for root, dirs, files in os.walk(source_dir):
    for file in files:
        # 构造源文件路径
        source_file_path = os.path.join(root, file)
        # 构造目标文件路径
        destination_file_path = os.path.join(destination_dir, file)
        
        # 复制文件到目标目录
        shutil.copy2(source_file_path, destination_file_path)

print("文件已展平复制到目标目录。")
