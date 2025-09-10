@echo off
if not exist venv (
    python -m venv venv
)
call venv\Scripts\activate.bat
pip install --upgrade pip >nul
pip install httpx python-dotenv >nul
python test_grocy_api.py
