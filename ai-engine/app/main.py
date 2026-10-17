from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
from dotenv import load_dotenv

load_dotenv(dotenv_path="../../.env")

app = FastAPI(title="KAIPY AI Engine - RAG & Search Service")

class QueryRequest(BaseModel):
    prompt: str
    top_k: int = 4

@app.get("/")
def read_root():
    return {"status": "Active", "module": "KAIPY AI RAG Engine"}

@app.post("/api/ai/search")
async def semantic_search(req: QueryRequest):
    """
    API tiếp nhận câu hỏi tự nhiên -> Truy vấn ChromaDB -> Đóng gói Prompt gọi Gemini API
    """
    try:
        # Code kết nối ChromaDB & Gemini API sẽ triển khai tại bước này
        return {
            "query": req.prompt,
            "ai_advice": f"Dựa trên nhu cầu '{req.prompt}', AI đề xuất các sản phẩm phù hợp nhất dưới đây.",
            "products": []
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)