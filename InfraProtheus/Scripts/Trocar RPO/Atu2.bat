@echo off
cls
color 0A
title Conditional copy apos
 
:start 
echo What would you like to do?
echo.
echo 1. copiar de apo_cmp
echo 2. copiar de apo_hml
echo 3. copiar de apo_prg
echo. 
echo 0. Quit
echo.
 
set /p choice="Enter your choice: "
if %choice%==1 goto cmp
if %choice%==2 goto hml
if %choice%==3 goto prg
if %choice%==0 goto exit
echo Invalid choice: %choice%
echo.
pause
cls
goto start
 
:cmp
cd apo_001
xcopy ..\apo_cmp\*.* /s /c /y /d
cd ..\apo_002
xcopy ..\apo_cmp\*.* /s /c /y /d
cd ..\apo_003
xcopy ..\apo_cmp\*.* /s /c /y /d
cd ..\apo_004
xcopy ..\apo_cmp\*.* /s /c /y /d
cd ..\apo_hml
xcopy ..\apo_cmp\*.* /s /c /y /d
cd ..\apo_prg
xcopy ..\apo_cmp\*.* /s /c /y /d
cd..
goto exit

:hml
cd apo_001
xcopy ..\apo_hml\*.* /s /c /y /d
cd ..\apo_002
xcopy ..\apo_hml\*.* /s /c /y /d
cd ..\apo_003
xcopy ..\apo_hml\*.* /s /c /y /d
cd ..\apo_004
xcopy ..\apo_hml\*.* /s /c /y /d
cd ..\apo_cmp
xcopy ..\apo_hml\*.* /s /c /y /d
cd ..\apo_prg
xcopy ..\apo_hml\*.* /s /c /y /d
cd..
goto exit

:prg
cd apo_001
xcopy ..\apo_prg\*.* /s /c /y /d
cd ..\apo_002
xcopy ..\apo_prg\*.* /s /c /y /d
cd ..\apo_003
xcopy ..\apo_prg\*.* /s /c /y /d
cd ..\apo_004
xcopy ..\apo_prg\*.* /s /c /y /d
cd ..\apo_cmp
xcopy ..\apo_prg\*.* /s /c /y /d
cd ..\apo_hml
xcopy ..\apo_prg\*.* /s /c /y /d
cd..
goto exit

:exit
color 0f
echo.
pause
cls