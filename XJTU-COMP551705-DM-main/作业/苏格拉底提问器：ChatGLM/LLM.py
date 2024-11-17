from langchain.llms.base import LLM
from typing import Any, List, Optional, Dict
from langchain.callbacks.manager import CallbackManagerForLLMRun
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch


# 文件定义了一个自定义的语言模型类 ChatGLM4_LLM，基于 LangChain 和 Transformers 库
# 此类封装了 glm-4-9b-chat 模型的加载和调用方法，使其适用于 LangChain 框架

class ChatGLM4_LLM(LLM):
    tokenizer: AutoTokenizer = None
    model: AutoModelForCausalLM = None
    gen_kwargs: dict = None

    # ChatGLM4_LLM 继承自 LLM 基类，包含 tokenizer 和 model 两个属性，用于加载和初始化语言模型
    # __init__ 方法中，使用 AutoTokenizer 和 AutoModelForCausalLM 加载指定路径下的模型和分词器
    # torch_dtype=torch.bfloat16 和 device_map="auto" 确保模型在适配设备（如 GPU）上运行，并减少内存使用
    # gen_kwargs 是生成参数字典，默认包括 max_length、do_sample 和 top_k，可以通过实例化时传入不同参数自定义
    def __init__(self, model_name_or_path: str, gen_kwargs: dict = None):
        super().__init__()
        print("loading the model...")
        self.tokenizer = AutoTokenizer.from_pretrained(
            model_name_or_path,
            trust_remote_code=True
        )
        self.model = AutoModelForCausalLM.from_pretrained(
            model_name_or_path,
            torch_dtype=torch.bfloat16,
            trust_remote_code=True,
            device_map="auto"
        ).eval()
        print("Finish loading the model!")

        if gen_kwargs is None:
            gen_kwargs = {"max_length": 2500, "do_sample": True, "top_k": 1}
        self.gen_kwargs = gen_kwargs

    # _call 方法用于接受用户的输入 prompt，将其转为模型输入格式，通过 self.model.generate 方法生成响应，并将生成的 ID 解码为文本输出
    # 使用 apply_chat_template 方法将 prompt 转换为对话格式，确保模型能理解上下文并生成合适的回答
    def _call(self, prompt: str, stop: Optional[List[str]] = None,
                run_manager: Optional[CallbackManagerForLLMRun] = None,
                **kwargs: Any) -> str:
        messages = [{"role": "user", "content": prompt}]
        model_inputs = self.tokenizer.apply_chat_template(
            messages, tokenize=True, return_tensors="pt", return_dict=True, add_generation_prompt=True
        )
        model_inputs = {k: v.to(self.model.device) for k, v in model_inputs.items()}
        '''        
        with torch.no_grad():
            outputs = self.model.generate(
                **model_inputs,
                **self.gen_kwargs,
                return_dict_in_generate=True,
                output_scores=False
        )
        '''
        generated_ids = self.model.generate(**model_inputs, **self.gen_kwargs)
        # generated_ids = outputs.sequences
        generated_ids = [
            output_ids[len(input_ids):] for input_ids, output_ids in zip(model_inputs['input_ids'], generated_ids)
        ]
        response = self.tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0]
        return response

    @property
    # _identifying_params 返回模型的配置参数，帮助 LangChain 管理模型信息
    def _identifying_params(self) -> Dict[str, Any]:
        return {
            "model_name": "glm-4-9b-chat",
            "max_length": self.gen_kwargs.get("max_length"),
            "do_sample": self.gen_kwargs.get("do_sample"),
            "top_k": self.gen_kwargs.get("top_k")
        }

    @property
    # _llm_type 返回模型类型名称（此处为 "glm-4-9b-chat"
    def _llm_type(self) -> str:
        return "glm-4-9b-chat"

