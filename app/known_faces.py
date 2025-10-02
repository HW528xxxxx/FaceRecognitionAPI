import face_recognition
import os

known_encodings = []
known_names = []

# 讀取 known_faces 資料夾
for filename in os.listdir(os.path.join(os.path.dirname(__file__), "../known_faces")):
    name, ext = os.path.splitext(filename)
    image_path = os.path.join(os.path.dirname(__file__), "../known_faces", filename)
    image = face_recognition.load_image_file(image_path)
    encodings = face_recognition.face_encodings(image)
    if encodings:  # 確認圖片有臉
        encoding = encodings[0]
        known_encodings.append(encoding)
        known_names.append(name)

print(f"Loaded {len(known_encodings)} known faces: {known_names}")
