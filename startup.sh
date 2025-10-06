#!/bin/bash
set -e  # 發生錯誤就中止

LOG_FILE=/home/LogFiles/startup.log
APP_DIR=/home/site/wwwroot
VENV_DIR=$APP_DIR/antenv

echo "==== 啟動時間：$(date) ====" >> $LOG_FILE

cd $APP_DIR
echo "切換到目錄: $(pwd)" >> $LOG_FILE

# 建立虛擬環境（若不存在）
if [ ! -d "$VENV_DIR" ]; then
    echo "建立虛擬環境..." >> $LOG_FILE
    python3 -m venv $VENV_DIR >> $LOG_FILE 2>&1
fi

# 啟動虛擬環境
source $VENV_DIR/bin/activate
echo "虛擬環境啟動完成" >> $LOG_FILE

# 更新 pip
pip install --upgrade pip >> $LOG_FILE 2>&1

# 確認 wheels 存在
if [ -d "$APP_DIR/wheels" ]; then
    echo "安裝 wheels 中..." >> $LOG_FILE
    pip install --no-index --find-links=$APP_DIR/wheels $APP_DIR/wheels/*.whl >> $LOG_FILE 2>&1
else
    echo "⚠️ 找不到 wheels 資料夾" >> $LOG_FILE
fi

# 安裝 requirements
if [ -f "$APP_DIR/requirements.txt" ]; then
    echo "安裝 requirements.txt..." >> $LOG_FILE
    pip install -r $APP_DIR/requirements.txt >> $LOG_FILE 2>&1
fi

# 啟動 uvicorn
echo "啟動應用程式..." >> $LOG_FILE
exec python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 >> $LOG_FILE 2>&1
