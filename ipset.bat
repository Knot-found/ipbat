@echo off

cd %~dp0

:checkMandatoryLevel
REM 管理者として実行されているか確認 START
for /f "tokens=1 delims=," %%i in ('whoami /groups /FO CSV /NH') do (
    if "%%~i"=="BUILTIN\Administrators" set ADMIN=yes
    if "%%~i"=="Mandatory Label\High Mandatory Level" set ELEVATED=yes
)

if "%ELEVATED%" neq "yes" (
   echo このファイルは管理者権限での実行が必要です{プロセスが昇格されていない}
   if "%1" neq "/R" goto runas
   goto exit1
)
REM 管理者として実行されているか確認 END


:admins
    REM 管理者として実行したいコマンド START
    
    netsh interface ip set address "Ethernet" static ip_address subnet_mask default_gateway
    netsh interface ip set dns "Ethernet" static dns_address primary validate=no
    pause

    REM 管理者として実行したいコマンド END
    goto exit1

:runas
    REM 管理者として再実行
    powershell -Command Start-Process -Verb runas "ipset.bat" -ArgumentList "/R" 

:exit1
