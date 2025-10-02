import os
import numpy as np
import face_recognition
import io
import shutil
from typing import List

DATA_DIR = os.path.join(os.path.dirname(__file__), "../data")
KNOWN_DIR = os.path.join(os.path.dirname(__file__), "../known_faces")

# ----------------- 初始化已知人臉 -----------------
if os.path.exists(KNOWN_DIR):
    known_encodings = []
    known_names = []

    for filename in os.listdir(KNOWN_DIR):
        name, ext = os.path.splitext(filename)
        image_path = os.path.join(KNOWN_DIR, filename)
        image = face_recognition.load_image_file(image_path)
        encodings = face_recognition.face_encodings(image)
        if encodings:
            known_encodings.append(encodings[0])
            known_names.append(name)

    os.makedirs(DATA_DIR, exist_ok=True)
    np.save(os.path.join(DATA_DIR, "known_encodings.npy"), known_encodings)
    np.save(os.path.join(DATA_DIR, "known_names.npy"), known_names)

    # 刪除 known_faces 資料夾
    shutil.rmtree(KNOWN_DIR)
    print(f"Processed {len(known_encodings)} faces, known_faces folder removed.")

else:
    # 從向量檔載入
    known_encodings = np.load(os.path.join(DATA_DIR, "known_encodings.npy"), allow_pickle=True)
    known_names = np.load(os.path.join(DATA_DIR, "known_names.npy"), allow_pickle=True)
    print(f"Loaded {len(known_encodings)} faces from data/")

# ----------------- 功能函式 -----------------
def get_face_encodings(image_bytes: bytes) -> List[np.ndarray]:
    """將上傳的圖片轉成臉部向量"""
    image = face_recognition.load_image_file(io.BytesIO(image_bytes))
    encodings = face_recognition.face_encodings(image)
    return encodings  # 保留 numpy array

def identify_face(unknown_encoding: np.ndarray) -> str:
    """比對上傳臉部向量與已知臉部向量，回傳人名"""
    results = face_recognition.compare_faces(known_encodings, unknown_encoding, tolerance=0.6)
    distances = face_recognition.face_distance(known_encodings, unknown_encoding)
    if True in results:
        best_index = np.argmin(distances)
        return known_names[best_index]
    return "Unknown"
