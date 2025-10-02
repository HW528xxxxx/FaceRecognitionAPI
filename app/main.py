from fastapi import FastAPI, UploadFile, File
from typing import List
from pydantic import BaseModel
from .face_rec import get_face_encodings, identify_face
from fastapi.middleware.cors import CORSMiddleware
import io

# ----------------- Pydantic 回傳模型 -----------------
class FaceRecognitionResponse(BaseModel):
    face_count: int
    encodings: List[List[float]]
    identities: List[str]

# ----------------- FastAPI App -----------------
app = FastAPI(title="Face Recognition API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 允許所有來源 (建議先這樣，確定沒問題後再收斂)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/recognize-face", response_model=FaceRecognitionResponse)
async def recognize_face(file: UploadFile = File(...)):
    # 讀取上傳檔案
    contents = await file.read()

    # 轉成臉部向量 (numpy array)
    encodings = get_face_encodings(contents)
    identities = [identify_face(e) for e in encodings]

    # 回傳前將 numpy array 轉成 list
    encodings_list = [e.tolist() for e in encodings]

    return {
        "face_count": len(encodings),
        "encodings": encodings_list,
        "identities": identities
    }
