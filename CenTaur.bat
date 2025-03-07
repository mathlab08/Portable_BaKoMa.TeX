@echo off
color 3e

setlocal enabledelayedexpansion

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c """"%~s0""""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

:----------------------------------------
REM  --> If running as admin, proceed

rem Using CENTAUR
set PATH=%~dp0BaKoMa.TeX;%PATH%
rem REG DELETE "HKEY_CURRENT_USER\Software\BaKoMa" /f
copy %~dp0BaKoMa.TeX\BaKoMa.TeX-bak\Registry.rw.tvr %~dp0BaKoMa.TeX\BaKoMa.TeX\Registry.rw.tvr
copy %~dp0BaKoMa.TeX\BaKoMa.TeX-bak\Registry.rw.tvr.lck %~dp0BaKoMa.TeX\BaKoMa.TeX\Registry.rw.tvr.lck
copy %~dp0BaKoMa.TeX\BaKoMa.TeX-bak\Registry.rw.tvr.transact %~dp0BaKoMa.TeX\BaKoMa.TeX\Registry.rw.tvr.transact
copy %~dp0BaKoMa.TeX\BaKoMa.TeX-bak\Registry.tlog %~dp0BaKoMa.TeX\BaKoMa.TeX\Registry.tlog
copy %~dp0BaKoMa.TeX\BaKoMa.TeX-bak\Registry.tlog.cache %~dp0BaKoMa.TeX\BaKoMa.TeX\Registry.tlog.cache

:: 1.Stop time synchronization service
net stop w32time >nul 2>&1

:: 2.Record the current time
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set "original_datetime=%%a"
set "original_date=!original_datetime:~0,4!/!original_datetime:~4,2!/!original_datetime:~6,2!"
set "original_time=!original_datetime:~8,2!:!original_datetime:~10,2!:!original_datetime:~12,2!"

:: 3.Set the historical time (the program startup time is set to 2023-07-28)
date 2023-07-28 >nul

:: 4.Start the target program
start /wait centaur.exe
pause

:: 5.Restart time service
net start w32time >nul 2>&1

endlocal