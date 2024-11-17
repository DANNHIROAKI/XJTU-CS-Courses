# 使用 FastAPI 框架搭建了一个带有对话上下文管理功能的 API 服务，能解析用户输入并生成上下文响应

from fastapi import FastAPI, Request
from transformers import AutoTokenizer, AutoModelForCausalLM
import uvicorn
import json
import datetime
import torch

DEVICE = "cuda"
DEVICE_ID = "0"
CUDA_DEVICE = f"{DEVICE}:{DEVICE_ID}" if DEVICE_ID else DEVICE

def torch_gc():
    if torch.cuda.is_available():
        with torch.cuda.device(CUDA_DEVICE):
            torch.cuda.empty_cache()
            torch.cuda.ipc_collect()

app = FastAPI()

@app.post("/")
async def create_item(request: Request):
    try:
        global model, tokenizer
        json_post = await request.json()
        prompt = json_post.get('prompt')
        history = json_post.get('history', [])

        # 构建输入格式
        messages = []
        if history:
            for conversation in history:
                messages.append({"role": "user", "content": conversation[0]})
                messages.append({"role": "assistant", "content": conversation[1]})
        messages.append({"role": "user", "content": prompt})

        # 将消息格式化为模型能理解的格式
        input_text = ""
        for msg in messages:
            if msg["role"] == "user":
                input_text += f"用户：{msg['content']}\n"
            else:
                input_text += f"助手：{msg['content']}\n"
        input_text += "助手："

        # 生成回复
        inputs = tokenizer(input_text, return_tensors="pt").to(model.device)
        outputs = model.generate(
            **inputs,
            max_length=2048,
            num_return_sequences=1,
            temperature=0.7,
            top_p=0.95,
            do_sample=True,
            pad_token_id=tokenizer.eos_token_id
        )
        
        response = tokenizer.decode(outputs[0], skip_special_tokens=True)
        # 只返回助手的回复部分
        response = response.split("助手：")[-1].strip()

        now = datetime.datetime.now()
        time = now.strftime("%Y-%m-%d %H:%M:%S")

        answer = {
            "response": response,
            "history": history + [[prompt, response]],
            "status": 200,
            "time": time
        }

        print(f"[{time}] prompt: {prompt}, response: {response}")
        torch_gc()
        return answer
    except Exception as e:
        print(f"Error: {str(e)}")
        return {"status": 500, "error": str(e)}

if __name__ == '__main__':
    try:
        print("正在加载模型...")
        tokenizer = AutoTokenizer.from_pretrained(
            "/root/autodl-tmp/ZhipuAI/glm-4-9b-chat", 
            trust_remote_code=True
        )
        model = AutoModelForCausalLM.from_pretrained(
            "/root/autodl-tmp/ZhipuAI/glm-4-9b-chat",
            torch_dtype=torch.bfloat16,
            trust_remote_code=True,
            device_map="auto"
        )
        model.eval()
        print("模型加载完成！")
        uvicorn.run(app, host='0.0.0.0', port=6006, workers=1)
    except Exception as e:
        print(f"启动服务器时发生错误: {str(e)}")
