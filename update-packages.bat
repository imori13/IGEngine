@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo Listing installed packages in package.txt...

if not exist .\vcpkg (
    echo vcpkg directory was not found.
    echo Have you run bootstrap-IGEngine.bat?
    pause
    exit /b
)

echo Listing installed packages...
.\vcpkg\vcpkg.exe list > .\packages.txt
echo The list of installed packages has been saved to packages.txt.

pause
