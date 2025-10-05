#!/bin/bash
# 啟動虛擬環境
source /home/site/wwwroot/antenv/bin/activate

# 更新 pip、setuptools、wheel
/home/site/wwwroot/antenv/bin/python -m pip install --upgrade pip setuptools wheel >> /home/LogFiles/startup.log 2>&1

# 安裝 wheels 到虛擬環境
/home/site/wwwroot/antenv/bin/python -m pip install /home/site/wwwroot/wheels/*.whl >> /home/LogFiles/startup.log 2>&1

# 安裝 uvicorn / fastapi
/home/site/wwwroot/antenv/bin/python -m pip install fastapi uvicorn >> /home/LogFiles/startup.log 2>&1

# 啟動 uvicorn
exec /home/site/wwwroot/antenv/bin/python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 >> /home/LogFiles/startup.log 2>&1
