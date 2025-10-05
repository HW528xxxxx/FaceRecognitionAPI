#!/bin/bash
LOG_FILE="/home/LogFiles/startup.log"

echo "===== [STARTUP] 啟動 FaceRecognitionModel =====" | tee -a $LOG_FILE

# 檢查虛擬環境是否存在
if [ ! -d "/home/site/wwwroot/antenv/bin" ]; then
  echo "❌ 找不到 antenv 環境，啟動失敗！" | tee -a $LOG_FILE
  exit 1
fi

# 啟動虛擬環境
echo "🔹 啟動 antenv 虛擬環境 ..." | tee -a $LOG_FILE
source /home/site/wwwroot/antenv/bin/activate

# 確保 pip 可用
/home/site/wwwroot/antenv/bin/python -m ensurepip --upgrade >> $LOG_FILE 2>&1

# 執行主程式（修改為你的 app 路徑）
echo "✅ 啟動 Uvicorn 應用 ..." | tee -a $LOG_FILE
exec /home/site/wwwroot/antenv/bin/python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 >> $LOG_FILE 2>&1
