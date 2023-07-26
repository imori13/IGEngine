@echo off
chcp 65001 > nul

echo Checking git...
git --version >nul 2>&1
if errorlevel 1 (
    echo Git is not installed. Installing...
    curl -L -o git-installer.exe https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/Git-2.41.0.3-64-bit.exe
    start /wait git-installer.exe /VERYSILENT
    del git-installer.exe
)

"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Workload.VCTools -property installationPath >nul 2>&1
if errorlevel 1 (
    echo Visual Studio Build Tools not found. Installing...

    curl -L -o vs_BuildTools.exe https://aka.ms/vs/17/release/vs_BuildTools.exe
    start /wait vs_BuildTools.exe --quiet --add Microsoft.VisualStudio.Workload.VCTools
    del vs_BuildTools.exe

    echo Visual Studio Build Tools installed.
) else (
    echo Visual Studio Build Tools found.
)

echo Installing vcpkg...
if not exist vcpkg (
    git clone https://github.com/microsoft/vcpkg.git
)

echo Initializing vcpkg...
call .\vcpkg\bootstrap-vcpkg.bat

echo Installing all packages from packages.txt...
if exist packages.txt (
    for /F "tokens=1,* delims= " %%i in (packages.txt) do (
        .\vcpkg\vcpkg.exe install %%i
    )
    echo All packages have been installed.
    .\vcpkg\vcpkg.exe integrate install
) else (
    echo packages.txt was not found.
)

pause
