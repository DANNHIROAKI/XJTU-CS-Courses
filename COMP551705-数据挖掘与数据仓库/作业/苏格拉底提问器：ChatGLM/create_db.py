#主要用于将指定目录下的 Markdown 和文本文件加载、分块、向量化，并存入一个 Chroma 向量数据库

import os
from tqdm import tqdm
from langchain_community.document_loaders import UnstructuredFileLoader, UnstructuredMarkdownLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import Chroma

#获取文件列表
def get_files(dir_path):
    file_list = []
    for filepath, dirnames, filenames in os.walk(dir_path):
        for filename in filenames:
            if filename.endswith(".md"):
                file_list.append(os.path.join(filepath, filename))
            elif filename.endswith(".txt"):
                file_list.append(os.path.join(filepath, filename))
    return file_list

#加载文件内容
def get_text(dir_path):
    file_list = get_files(dir_path)
    docs = []
    for one_file in tqdm(file_list):
        file_type = one_file.split('.')[-1]
        if file_type == 'md':
            loader = UnstructuredMarkdownLoader(one_file)
        elif file_type == 'txt':
            loader = UnstructuredFileLoader(one_file)
        else:
            continue
        docs.extend(loader.load())
    return docs

tar_dir = [
    "/root/autodl-tmp/data_mining"
]

docs = []
for dir_path in tar_dir:
    docs.extend(get_text(dir_path))

#分块处理
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=500, chunk_overlap=150)
split_docs = text_splitter.split_documents(docs)

#生成嵌入向量
embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2")

#构建 Chroma 向量数据库
persist_directory = 'data_base/vector_db/chroma'
vectordb = Chroma.from_documents(
    documents=split_docs,
    embedding=embeddings,
    persist_directory=persist_directory
)

vectordb.persist()

