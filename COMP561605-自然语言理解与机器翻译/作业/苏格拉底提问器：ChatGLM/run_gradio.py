# 是项目的主程序，整合了之前定义的各个组件
# 通过 Gradio 框架搭建了一个 Web 界面，让用户可以与苏格拉底式提问模型进行交互


from langchain_chroma import Chroma
from langchain_community.embeddings import HuggingFaceEmbeddings
import os
from LLM import ChatGLM4_LLM
from langchain.prompts import PromptTemplate
from langchain.chains import RetrievalQA
import gradio as gr


# 加载问答链
# load_chain 函数加载向量数据库（Chroma）和自定义语言模型（ChatGLM4_LLM），并配置一个 Prompt 模板，确保系统以苏格拉底式提问的方式回应
# 该函数使用 RetrievalQA.from_chain_type 创建检索问答链，并返回 qa_chain 对象
def load_chain():
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2")

    persist_directory = 'data_base/vector_db/chroma'

    vectordb = Chroma(
        persist_directory=persist_directory,
        embedding_function=embeddings
    )

    llm = ChatGLM4_LLM(model_name_or_path = "/root/autodl-tmp/ZhipuAI/glm-4-9b-chat")
    # llm.predict("你是谁")

    template = """你是一个使用苏格拉底式方法教学的导师。你的目标是通过提问引导学生思考，而不是直接给出答案，最终目的是帮助他们找到问题的答案。
    请严格遵循以下规则：
    1. 如果输入是一个新问题（不包含"我认为"、"我的想法"等表述），应该：
    - 绝对不要直接给出答案
    - 提供1-2个与问题核心相关的引导性问题，帮助学生从不同角度思考这个问题
    - 提出的每个问题都应该聚焦于原始问题的一个具体方面

    2. 如果输入是对之前问题的回答（通常包含详细解释或观点），应该：
    - 如果回答不完整或有误：提出1个更有针对性的问题，引导学生思考问题的其他方面
    - 如果回答基本正确但不够深入：提出1个深化问题，帮助学生更好地理解
    - 如果回答完整且正确：给予肯定，简要总结关键点，结束当前话题
    - 避免重复已经讨论过的内容

    3. 始终保持对话焦点：
    - 确保每个问题都直接服务于解答原始问题
    - 避免过度发散
    - 当获得充分答案时，及时结束讨论

    请注意：如果学生的提问和我们的主题：数据挖掘，机器学习与自然语言处理无关，你必须拒绝回答。

    基于以下内容进行回应：
    {context}
    学生的输入：{question}

    你的回应："""

    QA_CHAIN_PROMPT = PromptTemplate(input_variables=["context", "question"], template=template)

    qa_chain = RetrievalQA.from_chain_type(llm, retriever=vectordb.as_retriever(), return_source_documents=True, chain_type_kwargs={"prompt": QA_CHAIN_PROMPT})
    
    return qa_chain

'''
question = "什么是 Self LLM？"
qa_chain = load_chain()
result = qa_chain.invoke({"query": question})
print("检索问答链回答 question 的结果：")
print(result["result"])

llm = ChatGLM4_LLM(model_name_or_path = "/root/autodl-tmp/ZhipuAI/glm-4-9b-chat")
result_2 = llm(question)
print("大模型回答 question 的结果：")
print(result_2)
'''


# 定义模型中心类
# Model_center 类初始化 qa_chain 对象，并提供了 qa_chain_self_answer 方法，用于处理用户的问题并返回相应的对话历史
class Model_center():
    def __init__(self):
        self.chain = load_chain()
        
    def qa_chain_self_answer(self, question: str, chat_history: list = []):
        if question == None or len(question) < 1:
            return "", chat_history
        try:
            
            response = self.chain({"query": question})
            print(response)
            result = response.get("result", "未找到结果")
            
            chat_history.append((question, result))
            '''
            chat_history.append(
                (question, self.chain({"query": question})["result"]))
            '''
            return "", chat_history
        except Exception as e:
            return e, chat_history


css = """
.container {
    max-width: 1600px;
    margin: auto;
    padding: 10px;
}

.title {
    text-align: center;
    color: #2c3e50;
    font-family: 'Arial', sans-serif;
    margin-bottom: 10px;
}

.title h1 {
    font-size: 2.2em;
    margin-bottom: 10px;
}

.title h2 {
    font-size: 1.5em;
    color: #7f8c8d;
}

.main-content {
    display: flex;
    justify-content: center;
    width: 100%;
    gap: 15px;
    padding: 0 20px;
}

.chatbot {
    border-radius: 12px;
    border: 1px solid #e0e0e0;
    background-color: #f9f9f9;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    min-width: 1000px;
}

.input-area {
    margin-top: 20px;
    width: 100%;
}

.input-box {
    border-radius: 8px;
    border: 1px solid #ddd;
    padding: 8px;
    font-size: 15px;
}

.button-row {
    display: flex;
    gap: 10px;
    justify-content: flex-start;
    margin-top: 10px;
}

.custom-button {
    background-color: #3498db;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s ease;
    min-width: 120px;
    font-size: 16px;
}

.custom-button:hover {
    background-color: #2980b9;
    transform: translateY(-2px);
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.tips {
    margin-top: 20px;
    padding: 10px;
    background-color: #f8f9fa;
    border-left: 6px solid #3498db;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    font-size: 16px;
    line-height: 1.6;
}

.tips h3 {
    color: #2c3e50;
    margin-bottom: 15px;
}

.tips ul {
    margin-left: 20px;
}
"""


# 使用 gr.Blocks 构建整个页面，gr.Markdown 用于显示标题和提示信息
# gr.Chatbot 显示对话内容，gr.Textbox 接收用户输入，gr.Button 和 gr.ClearButton 用于发送问题和清空对话
# 在点击“发送”按钮时调用 qa_chain_self_answer 方法处理输入问题
# 使用 CSS 对界面布局
# demo.launch() 启动 Gradio Web 界面，提供交互式问答功能
model_center = Model_center()
block = gr.Blocks(css=css)
with block as demo:
    with gr.Column(elem_classes="container"):
        gr.Markdown(
            """
            # 🤖 苏格拉底提问器
            ## 数据仓库与数据挖掘-XJTU
            """,
            elem_classes="title"
        )
        
        with gr.Row():
            with gr.Column(scale=8):
                chatbot = gr.Chatbot(
                    height=500,
                    show_copy_button=True,
                    container=True,
                    elem_classes="chatbot"
                )
                
                with gr.Row():
                    msg = gr.Textbox(
                        label="请输入您的问题",
                        placeholder="在这里输入您的问题...",
                        scale=8,
                        container=False,
                        elem_classes="input-box"
                    )
                    
                with gr.Row(elem_classes="button-row"):
                    db_wo_his_btn = gr.Button(
                        "发送 💬",
                        variant="primary",
                        elem_classes="custom-button"
                    )
                    clear = gr.ClearButton(
                        components=[chatbot],
                        value="清空对话 🗑️",
                        variant="secondary",
                        elem_classes="custom-button"
                    )

        gr.Markdown(
            """
            ### 💡 温馨提示
            - 这是一个面向数据挖掘专业课的智能提问系统，支持数据挖掘、机器学习与自然语言处理相关问题。
            - 通过苏格拉底式提问方法，引导您深入思考问题。目标是帮助您发现问题本质，而不是直接给出答案。
            """,
            elem_classes="tips"
        )

    db_wo_his_btn.click(
        model_center.qa_chain_self_answer,
        inputs=[msg, chatbot],
        outputs=[msg, chatbot]
    )

demo.launch()
