@echo off

:: Launch Steam with parameters
:: This one has a weird directory because of issues on the pc it was written for
start "" "C:\Program Files (x86)\Steam2\Steam.exe" -no-browser +open steam://open/minigameslist

:: Wait for Steamwebhelper to launch
timeout /t 25 >nul

:: Change the priority of steamwebhelper.exe and steam.exe
wmic process where name="steamwebhelper.exe" CALL setpriority "64"
wmic process where name="steam.exe" CALL setpriority "64"
