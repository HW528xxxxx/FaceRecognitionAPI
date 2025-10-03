#!/bin/bash
# 啟動虛擬環境
source /home/site/wwwroot/antenv/bin/activate
# 啟動 uvicorn
exec uvicorn app.main:app --host 0.0.0.0 --port 8000
