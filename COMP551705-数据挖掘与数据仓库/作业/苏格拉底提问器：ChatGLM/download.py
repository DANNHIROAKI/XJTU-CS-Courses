
# 下载 ZhipuAI 提供的 glm-4-9b-chat 模型，并将其缓存到指定目录

import torch
from modelscope import snapshot_download, AutoModel, AutoTokenizer
import os
model_dir = snapshot_download('ZhipuAI/glm-4-9b-chat', cache_dir='/root/autodl-tmp', revision='master')
