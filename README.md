# Face Recognition API

這是一個使用 **FastAPI** + **dlib / face_recognition** 建立的人臉辨識 API 專案。

專案結構：

FaceRecognitionAPI/
├─ app/
│ ├─ main.py # FastAPI 主程式，負責 API 路由
│ ├─ face_rec.py # 人臉辨識核心程式，負責產生人臉向量
│ ├─ known_faces.py    # 已知人臉初始化程式
│ └─ init.py # 空檔案，用來讓 Python 將 app 當成套件(package)
├─ requirements.txt # 套件清單
├─ .gitignore
└─ README.md

## **安裝**

1. 進入專案資料夾：
cd C:\Users\User\Desktop\FaceRecognition\FaceRecognitionAPI

2. 啟用虛擬環境（建立 venv311）：
C:\Users\User\Desktop\FaceRecognition\venv311\Scripts\activate

3. 安裝套件：
pip install -r requirements.txt

## **檔案功能說明**
app/main.py
FastAPI API 主程式，定義路由 /recognize-face，上傳圖片後回傳人臉向量。

app/face_rec.py
核心人臉辨識功能，使用 face_recognition 讀取圖片並計算人臉向量。
【　自動初始化已知人臉ㄏ
程式啟動時會先檢查 known_faces 資料夾。
如果資料夾存在，會將每張圖片：讀取並計算臉部向量（128 維）
-- 儲存到 data/known_encodings.npy 與 data/known_names.npy
-- 轉換完成後，自動刪除 known_faces 資料夾，避免專案內圖檔越來越大

【　辨識功能　】
-- get_face_encodings(image_bytes)：將上傳圖片轉成臉部向量
-- identify_face(unknown_encoding)：比對上傳臉部向量與已知臉部向量，回傳人名或 "Unknown"

app/init.py
空檔案，告訴 Python 這個資料夾是一個套件（package），可以被 import 使用。

requirements.txt
記錄專案需要安裝的 Python 套件。

.gitignore
忽略版本控制不必要的檔案，例如虛擬環境、快取檔案等。

啟動 API（本地測試）
uvicorn app.main:app --reload
app.main:app → 指的是 app/main.py 裡面的 app 物件
--reload → 讓程式碼修改後自動重啟

打開瀏覽器訪問 http://127.0.0.1:8000/docs
可以使用 Swagger UI 測試上傳圖片的人臉辨識功能。


## **使用說明**
上傳圖片（JPEG / PNG），API 會回傳：

face_count：偵測到的人臉數量
encodings：每個人臉的 128 維向量
identities：辨識出的人名

範例回傳
{
  "face_count": 1,
  "encodings": [
    [
      -0.10292210429906845,
      0.046881817281246185,
      0.04360498487949371,
      ...
      -0.015095598995685577
    ]
  ],
  "identities": [
    "SamAltman"
  ]
}