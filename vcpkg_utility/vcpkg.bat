@echo off
setlocal enabledelayedexpansion

:commandLoop
set /p command="コマンドを入力してください: "

if /i "%command:~0,7%"=="install" (
    set package=!command:~8!
    if not "!package!"=="" (
        ..\vcpkg\vcpkg.exe install !package!:x64-windows
        if %errorlevel% neq 0 (
            echo !package!:x64-windows のインストールに失敗しました。
        ) else (
            echo !package!:x64-windows >> .\packages.txt
            echo !package!:x64-windows のインストールが完了しました。
            ..\vcpkg\vcpkg.exe integrate install
        )
    ) else (
        echo パッケージ名が入力されませんでした。
    )
)

if /i "%command%"=="update" (
    echo インストール済みのパッケージをリストします...
    ..\vcpkg\vcpkg.exe list > .\packages.txt
    echo インストール済みのパッケージのリストが packages.txt に保存されました。
)

if /i "%command%"=="list" (
    echo すべてのパッケージをリストします...
    ..\vcpkg\vcpkg.exe list
)

if /i "%command:~0,6%"=="search" (
    set package=!command:~7!
    if not "!package!"=="" (
        echo パッケージ !package! を検索します...
        ..\vcpkg\vcpkg.exe search !package!
    ) else (
        echo すべてのパッケージを検索します...
        ..\vcpkg\vcpkg.exe search
    )
)

if /i "%command%"=="help" (
    echo "install [パッケージ名] - パッケージをインストールします"
    echo "update - インストール済みのパッケージをリストします"
    echo "list - すべてのパッケージをリストします"
    echo "search [パッケージ名] - パッケージを検索します"
    echo "search - すべてのパッケージを検索します"
    echo "help - このヘルプを表示します"
)

if not "%command%"=="install" if not "%command%"=="update" if not "%command%"=="list" if not "%command:~0,6%"=="search" if not "%command%"=="help" (
    echo 該当しないコマンドが入力されました。'help'コマンドを入力して各コマンドの説明と使い方を確認してください。
)

goto commandLoop
