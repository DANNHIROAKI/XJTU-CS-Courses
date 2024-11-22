# 下载 sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2 模型，并将其缓存到指定目录

import torch
from modelscope import snapshot_download, AutoModel, AutoTokenizer
import os
model_dir = snapshot_download('sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2', cache_dir='/root/autodl-tmp', revision='master')
