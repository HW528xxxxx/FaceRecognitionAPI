#!/bin/bash
# 啟動虛擬環境
source /home/site/wwwroot/antenv/bin/activate

# 安裝 wheel，並導出 log
pip install --upgrade pip >> /home/LogFiles/startup.log 2>&1
pip install /home/site/wwwroot/extracted/wheels/*.whl >> /home/LogFiles/startup.log 2>&1

# 啟動 uvicorn，stdout/stderr 都導出
exec /home/site/wwwroot/antenv/bin/python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 >> /home/LogFiles/startup.log 2>&1
