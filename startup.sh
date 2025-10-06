#!/bin/bash

LOG_FILE=/home/LogFiles/startup.log

# 如果虛擬環境不存在就建立
if [ ! -d /home/site/wwwroot/antenv ]; then
    python3 -m venv /home/site/wwwroot/antenv
fi

# 啟動虛擬環境
source /home/site/wwwroot/antenv/bin/activate

# 更新 pip
/home/site/wwwroot/antenv/bin/python -m pip install --upgrade pip >> $LOG_FILE 2>&1

# 安裝 wheels
/home/site/wwwroot/antenv/bin/python -m pip install /home/site/wwwroot/wheels/*.whl >> $LOG_FILE 2>&1

# 安裝其他套件
/home/site/wwwroot/antenv/bin/python -m pip install -r /home/site/wwwroot/requirements.txt >> $LOG_FILE 2>&1

# 啟動 uvicorn
exec /home/site/wwwroot/antenv/bin/python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 >> $LOG_FILE 2>&1
