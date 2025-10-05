#!/bin/bash
# 啟動虛擬環境
source /home/site/wwwroot/antenv/bin/activate

# 更新 pip
/home/site/wwwroot/antenv/bin/python -m pip install --upgrade pip >> /home/LogFiles/startup.log 2>&1

# 安裝 wheels 到虛擬環境
/home/site/wwwroot/antenv/bin/python -m pip install /home/site/wwwroot/wheels/*.whl >> /home/LogFiles/startup.log 2>&1

# 啟動 uvicorn，stdout/stderr 都導出
exec /home/site/wwwroot/antenv/bin/python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 >> /home/LogFiles/startup.log 2>&1
