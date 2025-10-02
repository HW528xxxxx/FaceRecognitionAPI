import os
import numpy as np
import face_recognition
import io
from typing import List

# ----------------- 載入已知人臉 -----------------
known_encodings = []
known_names = []

known_faces_dir = os.path.join(os.path.dirname(__file__), "../known_faces")

for filename in os.listdir(known_faces_dir):
    name, ext = os.path.splitext(filename)
    image_path = os.path.join(known_faces_dir, filename)
    image = face_recognition.load_image_file(image_path)
    encodings = face_recognition.face_encodings(image)
    if encodings:  # 確認圖片有臉
        known_encodings.append(encodings[0])
        known_names.append(name)

print(f"Loaded {len(known_encodings)} known faces: {known_names}")

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
