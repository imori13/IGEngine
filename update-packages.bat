@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo インストール済みのパッケージをpackage.txtにリスト化し保存します...

if not exist .\vcpkg (
    echo vcpkgディレクトリが見つかりませんでした。
    echo bootstrap-IGEngine.batを実行しましたか？
    pause
    exit /b
)

echo インストール済みのパッケージをリストします...
.\vcpkg\vcpkg.exe list > .\packages.txt
echo インストール済みのパッケージのリストが packages.txt に保存されました。

pause