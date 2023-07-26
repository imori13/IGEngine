@echo off
SETLOCAL

chcp 65001 > nul

echo Checking git...
git --version >nul 2>&1
if errorlevel 1 (
    echo Git is not installed. Installing...
    curl -L -o git-installer.exe https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/Git-2.41.0.3-64-bit.exe
    start /wait git-installer.exe /VERYSILENT
    del git-installer.exe
)

echo Visual Studio Build Tools Installing...

SET VSWHERE="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

curl -L -o vs_BuildTools.exe https://aka.ms/vs/17/release/vs_BuildTools.exe

if not exist %VSWHERE% (
    echo Visual Studio Installer is not found. Installing...
    start /wait vs_BuildTools.exe --quiet --wait || exit /b
)

FOR /F "tokens=* USEBACKQ" %%F IN (`%VSWHERE% -products * -requires Microsoft.VisualStudio.Workload.VCTools -property installationPath`) DO (SET "VCTOOLS=%%F")

FOR /F "tokens=* USEBACKQ" %%F IN (`%VSWHERE% -products * -requires Microsoft.VisualStudio.Component.VC.CMake.Project -property installationPath`) DO (SET "CMAKE=%%F")

call :checkAndInstall "VCTOOLS" "Microsoft.VisualStudio.Workload.VCTools"
call :checkAndInstall "CMAKE" "Microsoft.VisualStudio.Component.VC.CMake.Project"

del vs_BuildTools.exe

echo Installing VulkanSDK...
if not defined VULKAN_SDK (
    curl -L -o VulkanSDK-installer.exe https://sdk.lunarg.com/sdk/download/1.3.250.1/windows/VulkanSDK-1.3.250.1-Installer.exe
    start /wait VulkanSDK-installer.exe /VERYSILENT
    del VulkanSDK-installer.exe
) else (
    echo VulkanSDK is already installed.
)

echo Installing vcpkg...
git clone https://github.com/microsoft/vcpkg.git

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

ENDLOCAL
pause

goto :eof

:checkAndInstall
IF NOT DEFINED %~1 (
    echo %~1 not found. Installing...
    start /wait vs_BuildTools.exe --add %~2 --quiet --wait || exit /b
) ELSE (
    echo %~1 is installed.
)
goto :eof