import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import chromadb
import google.generativeai as genai
from dotenv import load_dotenv

# Load biến môi trường
load_dotenv()

# Cấu hình Gemini API
GEMINI_KEY = os.getenv("GEMINI_API_KEY")
if GEMINI_KEY:
    genai.configure(api_key=GEMINI_KEY)

app = FastAPI(title="KAIPY AI Engine")

# Cấu hình CORS cho phép Node.js Backend và Frontend truy cập
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Kết nối ChromaDB Persistent Client
chroma_client = chromadb.PersistentClient(path="./chroma_db")

class ChatRequest(BaseModel):
    message: str

class SearchRequest(BaseModel):
    query: str

@app.get("/")
def home():
    return {"status": "OK", "message": "KAIPY AI Engine is running!"}

# API 1: AI Search - Tìm kiếm sản phẩm theo ngữ nghĩa
@app.post("/api/ai/search")
def ai_search(req: SearchRequest):
    try:
        collection = chroma_client.get_collection("products")
        # Tìm 4 sản phẩm có độ tương đồng ngữ nghĩa cao nhất
        results = collection.query(
            query_texts=[req.query],
            n_results=4
        )
        
        matched_products = []
        if results and results['metadatas'] and len(results['metadatas']) > 0:
            for meta in results['metadatas'][0]:
                matched_products.append(meta)
                
        return {"success": True, "data": matched_products}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# API 2: AI Advisor Chatbot - RAG Tư vấn sản phẩm với Gemini
@app.post("/api/ai/chat")
def ai_chat(req: ChatRequest):
    try:
        collection = chroma_client.get_collection("products")
        # 1. Truy vấn sản phẩm liên quan từ Vector DB
        results = collection.query(
            query_texts=[req.message],
            n_results=3
        )
        
        context_docs = ""
        if results and results['documents'] and len(results['documents']) > 0:
            context_docs = "\n".join(results['documents'][0])
            
        # 2. Xây dựng Prompt cho Gemini với ngữ cảnh sản phẩm (RAG)
        prompt = f"""
Bạn là Trợ lý bán hàng thông minh của sàn thương mại điện tử KAIPY.
Hãy trả lời câu hỏi của khách hàng một cách lịch sự, thân thiện, ngắn gọn và thuyết phục.

Dưới đây là thông tin danh sách sản phẩm liên quan có trong cửa hàng:
{context_docs if context_docs else 'Không tìm thấy sản phẩm phù hợp trong kho.'}

Câu hỏi của khách hàng: "{req.message}"

Hướng dẫn trả lời:
- Dựa trên thông tin sản phẩm ở trên để gợi ý chính xác (tên sản phẩm, giá bán, đặc điểm nổi bật).
- Nếu không tìm thấy sản phẩm phù hợp trong kho, hãy trả lời lịch sự và gợi ý khách tìm sản phẩm khác.
- Giữ câu trả lời cô đọng dưới 150 từ, trình bày rõ ràng.
"""

        # 3. Gọi mô hình Gemini
        model = genai.GenerativeModel('gemini-3.8-flash')
        response = model.generate_content(prompt)
        
        return {
            "success": True, 
            "reply": response.text,
            "relevant_products": results['metadatas'][0] if results and results['metadatas'] else []
        }
    except Exception as e:
        # Fallback trong trường hợp lỗi Gemini API hoặc mô hình bận
        return {
            "success": False, 
            "message": f"Lỗi xử lý AI: {str(e)}"
        }