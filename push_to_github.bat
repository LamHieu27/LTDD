@echo off
chcp 65001 >nul
echo ==============================================
echo   DANG DAY DU AN LEN GITHUB (LamHieu27/LTDD)
echo ==============================================

cd /d "f:\Project_Nam3\LTDD\nhom03_ungdungdangkynhomvadoan"

echo 1. Khoi tao Git...
if not exist ".git" (
    git init
)

echo 2. Thiet lap Remote URL...
git remote remove origin 2>nul
git remote add origin https://github.com/LamHieu27/LTDD.git

echo 3. Chuyen nhanh sang main...
git branch -M main

echo 4. Them file vao Git...
git add .

echo 5. Tao commit...
git commit -m "Upload du an nhom03_ungdungdangkynhomvadoan"

echo 6. Day len GitHub...
git push -u origin main

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [THONG BAO] Neu gap loi tren GitHub da co san file, dang thu pull/rebase hoac force push...
    git push -u origin main --force
)

echo.
echo ==============================================
echo   HOAN TAT! Nhan phim bat ky de thoat.
echo ==============================================
pause
