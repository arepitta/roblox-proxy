@echo off
cd /d C:\Users\arepita\Documents\roblox-proxy\api

:: Nombre de usuario en GitHub
set GITHUB_USER=arepitta

:: Consulta el correo desde la API pública de GitHub
for /f "tokens=* usebackq" %%F in (`curl -s https://api.github.com/users/%GITHUB_USER% ^| findstr "email"`) do set GITHUB_EMAIL=%%F

:: Limpia el texto (quita "email": y comillas)
set GITHUB_EMAIL=%GITHUB_EMAIL:    "email": =%
set GITHUB_EMAIL=%GITHUB_EMAIL:"=%
set GITHUB_EMAIL=%GITHUB_EMAIL:,=%

echo Usando correo detectado: %GITHUB_EMAIL%

:: Configura identidad en git
git config --global user.name "%GITHUB_USER%"
git config --global user.email "%GITHUB_EMAIL%"

:: Inicializa repo si no existe
if not exist ".git" (
    git init
)

:: Asegura que estamos en main
git branch -M main

:: Agrega el remoto (lo reemplaza si ya existe)
git remote remove origin >nul 2>&1
git remote add origin https://github.com/%GITHUB_USER%/roblox-proxy.git

:: Agrega y hace commit
git add .
git commit -m "commit automático desde script"

:: Sube al repo
git push -u origin main

pause