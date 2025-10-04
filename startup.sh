#!/bin/bash
# 啟動虛擬環境
source /home/site/wwwroot/antenv/bin/activate
# 用虛擬環境裡的 python 執行 uvicorn
exec /home/site/wwwroot/antenv/bin/python -m uvicorn app.main:app --host 0.0.0.0 --port 8000