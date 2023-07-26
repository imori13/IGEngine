@echo off

echo gitをチェックします...
git --version >nul 2>&1
if errorlevel 1 (
    echo gitがインストールされていません。インストールします...
    curl -L -o git-installer.exe https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/Git-2.41.0.3-64-bit.exe
    start /wait git-installer.exe /VERYSILENT
    del git-installer.exe
)

echo vcpkgをインストールします...
if not exist vcpkg (
    git clone https://github.com/microsoft/vcpkg.git
)

echo vcpkgの初期化を行います...
call .\vcpkg\bootstrap-vcpkg.bat

echo packages.txtからすべてのパッケージをインストールします...
if exist packages.txt (
    for /F "tokens=1,* delims= " %%i in (packages.txt) do (
        .\vcpkg\vcpkg.exe install %%i
    )
    echo すべてのパッケージのインストールが完了しました。
    .\vcpkg\vcpkg.exe integrate install
) else (
    echo packages.txtが見つかりませんでした。
)

pause
