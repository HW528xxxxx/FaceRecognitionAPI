#!/bin/bash
LOG_FILE="/home/LogFiles/startup.log"

echo "===== [STARTUP] FaceRecognitionModel 啟動 =====" | tee -a $LOG_FILE
cd /home/site/wwwroot

# 如果 antenv 不存在但 antenv.tar.gz 有，先解壓
if [ ! -d "/home/site/wwwroot/antenv/bin" ]; then
  echo "🔹 解壓 antenv.tar.gz ..." | tee -a $LOG_FILE
  if [ -f "/home/site/wwwroot/antenv.tar.gz" ]; then
    tar -xzf /home/site/wwwroot/antenv.tar.gz
    echo "✅ antenv 解壓完成" | tee -a $LOG_FILE
  else
    echo "❌ 找不到 antenv.tar.gz，無法啟動" | tee -a $LOG_FILE
    exit 1
  fi
fi

# 啟動虛擬環境
echo "🔹 啟動 antenv 虛擬環境 ..." | tee -a $LOG_FILE
source /home/site/wwwroot/antenv/bin/activate

# 確保 pip 可用
/home/site/wwwroot/antenv/bin/python -m ensurepip --upgrade >> $LOG_FILE 2>&1

# 執行主程式（修改為你的 app 路徑）
echo "✅ 啟動 Uvicorn 應用 ..." | tee -a $LOG_FILE
exec /home/site/wwwroot/antenv/bin/python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 >> $LOG_FILE 2>&1
