@echo off
echo packages.txtからすべてのパッケージをインストールします...
for /F "tokens=1,* delims= " %%i in (packages.txt) do (
    ..\vcpkg\vcpkg.exe install %%i
)
echo すべてのパッケージのインストールが完了しました。
..\vcpkg\vcpkg.exe integrate install
pause
