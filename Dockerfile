# 使用官方 Python 3.11 slim 作為基底
FROM python:3.11-slim

# 安裝系統依賴（C++ 編譯器、CMake、Boost、其他工具）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libboost-all-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libopenblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# 設定工作目錄
WORKDIR /app

# 複製 requirements.txt 並安裝 Python 套件
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# 複製應用程式程式碼
COPY . .

# 對外開放 8000 port
EXPOSE 8000

# 啟動 FastAPI (Azure Web App 會使用這個命令)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
