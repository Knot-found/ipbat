@echo off

cd %~dp0

:checkMandatoryLevel
REM �Ǘ��҂Ƃ��Ď��s����Ă��邩�m�F START
for /f "tokens=1 delims=," %%i in ('whoami /groups /FO CSV /NH') do (
    if "%%~i"=="BUILTIN\Administrators" set ADMIN=yes
    if "%%~i"=="Mandatory Label\High Mandatory Level" set ELEVATED=yes
)

if "%ELEVATED%" neq "yes" (
   echo ���̃t�@�C���͊Ǘ��Ҍ����ł̎��s���K�v�ł�{�v���Z�X�����i����Ă��Ȃ�}
   if "%1" neq "/R" goto runas
   goto exit1
)
REM �Ǘ��҂Ƃ��Ď��s����Ă��邩�m�F END


:admins
    REM �Ǘ��҂Ƃ��Ď��s�������R�}���h START
    
    netsh interface ip set address "Ethernet" static ip_address subnet_mask default_gateway
    netsh interface ip set dns "Ethernet" static dns_address primary validate=no
    pause

    REM �Ǘ��҂Ƃ��Ď��s�������R�}���h END
    goto exit1

:runas
    REM �Ǘ��҂Ƃ��čĎ��s
    powershell -Command Start-Process -Verb runas "ipset.bat" -ArgumentList "/R" 

:exit1
