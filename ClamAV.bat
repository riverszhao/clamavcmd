@echo off
set tab=	: 
set clamhome=%~dp0
set clampath=%clamhome%\clamav-1.0.1.win.x64
if "%clampath:~-1%" == "\" (set clampath=%clampath:~0,-1%)
sc query clamd | find /i "1060" > NUL && set clamdstatus=UNINSTALL
sc query clamd | find /i "RUNNING" > NUL && set clamdstatus=RUNNING
sc query clamd | find /i "STOPPED" > NUL && set clamdstatus=STOPPED
goto :main

:main
if /i "%~1" == "help" goto help
if /i "%~1" == "status" goto status
if /i "%~1" == "install" goto install
if /i "%~1" == "uninstall" goto uninstall
if /i "%~1" == "update" goto update
if /i "%~1" == "start" goto start
if /i "%~1" == "stop" goto stop
if /i "%~1" == "dir" goto dir
if /i "%~1" == "config" goto config
if /i "%~1" == "log" goto log
if /i "%~1" == "top" goto top
if /i not "%~1" == "" goto scanvirus
goto help

:help
echo.
echo Clam-AntiVirus Command Tool v0.01
echo.
echo Usage:
echo.
echo %~nx0 [ help ^| status ^| install ^| uninstall ^| update ^| start ^| stop ^| dir ^| config ^| log ^| top ^| ^<full path of scan file or dir^> ]
echo.
timeout /t 30
goto end

:status
echo clamd service status %tab%%clamdstatus%
timeout /t 30
goto end

:install
if "%clamdstatus%" == "UNINSTALL" (
	echo starting install service...
	runas /savecred /user:administrator "%clampath%\clamd.exe --install-service"
) else (
	echo service already exist.
)
timeout /t 5
goto end

:uninstall
if not "%clamdstatus%" == "UNINSTALL" (
	call :stop
	echo starting uninstall service...
	runas /savecred /user:administrator "%clampath%\clamd.exe --uninstall-service"
) else (
	echo clamd service not exist, you not need uninstall.
)

timeout /t 5
goto end

:update
pushd %clampath%
echo starting update virus database ... &&  %clampath%\freshclam.exe && echo update done.
popd
pause
goto end

:start
if "%clamdstatus%" == "UNINSTALL" (
	call :install
)
if not "%clamdstatus%" == "RUNNING" (
	echo starting service...
	runas /savecred /user:administrator "net start clamd"
	%clampath%\clamdscan --ping 900
)
goto end

:stop
if "%clamdstatus%" == "RUNNING" (
	echo stopping service...
	runas /savecred /user:administrator "net stop clamd"
) else (
	echo service not running, current status is: %clamdstatus% .
)
goto end

:dir
start %clampath%\..\
goto end

:config
rem set gvim=%clampath%\..\..\busybox\busybox.bat gvim
set gvim=busybox.lnk gvim
pushd %~dp0
%gvim% %0 %clampath%\clamd.conf %clampath%\freshclam.conf
popd
goto end

:log
%clamhome%\..\busybox\bin\tail.exe -50 %clamhome%\log\clamdscan.log
pause
goto end

:top
%clampath%\clamdtop.exe
goto end

:scanvirus
if not "%clamdstatus%" == "RUNNING" (
	call :start
)
echo starting virus scan [%*] ...
echo ---- ----
:: %clampath%\clamdscan.exe --multiscan --fdpass --move=%clamhome%\virus_isolation --log=%clamhome%\log\clamdscan.log %*
%clampath%\clamdscan.exe --multiscan --fdpass --log=%clamhome%\log\clamdscan.log %*
echo ---- ----
echo scan virus done.
echo  
pause
goto end


:end

