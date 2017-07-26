@echo off
setlocal enabledelayedexpansion

SET strLinha=

for /F "tokens=* delims=?" %%i in (appserver.ini) do CALL :linha %%i
REM for /F "TOKENS=1 DELIMS= " %%i in ('type t.txt ^| find /I "texto desejado"') do CALL :linha %%i

ECHO %strLinha%

REM echo > appserver.ini
REM for %%i in (%strLinha%) do echo %%i >> appserver.ini

goto :END

::++++++++++++++++++++++
:linha
::++++++++++++++++++++++
SET strLinha=%strLinha% %1

goto :EOF

::++++++++++++++++++++++
:END
::++++++++++++++++++++++
pause