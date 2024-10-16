@echo off
setlocal enabledelayedexpansion

echo AWS Account ID: >> execution_log.txt
aws sts get-caller-identity --query "Account" --output text >> execution_log.txt
echo ************************************** >> execution_log.txt

REM Get the directory of the batch file
set "scriptDir=%~dp0"

REM Loop through all PowerShell script files in the directory
for %%f in ("%scriptDir%*.ps1") do (
echo Running %%~nxf
    powershell -ExecutionPolicy Bypass -File "%%f"
    
    REM Log the execution status
    if errorlevel 1 (
        echo Error executing %%~nxf. >> execution_log.txt
    ) else (
        echo %%~nxf executed successfully. >> execution_log.txt
    )
)

REM End of batch script
echo All scripts executed successfully.
echo ************************************** >> execution_log.txt
endlocal