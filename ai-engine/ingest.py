import os
import mysql.connector
import chromadb
from dotenv import load_dotenv

# Load biến môi trường từ .env
load_dotenv()

def connect_db():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", ""),
        database=os.getenv("DB_NAME", "kaipy_ecommerce")
    )

def sync_products_to_chroma():
    print("🔄 Đang kết nối CSDL MySQL...")
    db = connect_db()
    cursor = db.cursor(dictionary=True)
    
    # Lấy danh sách sản phẩm từ MySQL
    query = """
        SELECT p.id, p.name, p.price, p.discount_price, p.description, p.specs, c.name as category_name
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
    """
    cursor.execute(query)
    products = cursor.fetchall()
    
    if not products:
        print("⚠️ Không có sản phẩm nào trong MySQL để đồng bộ!")
        return

    print(f"📦 Tìm thấy {len(products)} sản phẩm. Đang khởi tạo ChromaDB...")
    
    # Khởi tạo Vector Database ChromaDB lưu trữ cục bộ
    chroma_client = chromadb.PersistentClient(path="./chroma_db")
    
    # Xóa collection cũ nếu có và tạo mới
    try:
        chroma_client.delete_collection("products")
    except Exception:
        pass
        
    collection = chroma_client.create_collection(name="products")

    documents = []
    metadatas = []
    ids = []

    for product in products:
        # Chuẩn hóa văn bản để tạo Vector Embedding (gồm tên, danh mục, mô tả, thông số)
        text_content = f"Tên sản phẩm: {product['name']}. Danh mục: {product['category_name'] or 'N/A'}. " \
                       f"Giá: {product['discount_price'] or product['price']} VNĐ. " \
                       f"Mô tả: {product['description'] or ''}. Thông số: {product['specs'] or ''}"
        
        documents.append(text_content)
        metadatas.append({
            "product_id": product['id'],
            "name": product['name'],
            "price": float(product['discount_price'] or product['price']),
            "category": product['category_name'] or 'N/A'
        })
        ids.append(str(product['id']))

    # Thêm dữ liệu vào Vector Database
    collection.add(
        documents=documents,
        metadatas=metadatas,
        ids=ids
    )

    print("✅ Đồng bộ dữ liệu vào ChromaDB thành công!")
    cursor.close()
    db.close()

if __name__ == "__main__":
    sync_products_to_chroma()