c:
cd \

forfiles -p "C:\TOTVS11\Microsiga\Protheus_Data\logs" -s -d -60 -m *.* -c "cmd /c del /f /q @path"
forfiles -p "C:\TOTVS11\Microsiga\Protheus_Data\spool" -s -d -1 -m *.* -c "cmd /c del /f /q @path"
forfiles -p "C:\TOTVS11\Microsiga\Protheus_Data\pswbackup" -d -60 -m * -c "cmd /c rmdir /s /q @path"
forfiles -p "C:\TOTVS11\Microsiga\Protheus_Data\system" -m *.idx -c "cmd /c rmdir /s /q @path"

c:
cd \
rmdir /S /Q C:\TOTVS11\Microsiga\Protheus_Data\system\ctreeint
rmdir /S /Q C:\TOTVS11\Microsiga\Protheus_Data\data\ctreeint
rmdir /S /Q C:\TOTVS11\Microsiga\Protheus_Data\profile\ctreeint

cd C:\TOTVS11\Microsiga\Protheus_Data\system
del /F /Q *.lck *.idx *.cdx *.ind sc*.log sc*.dbf sc*.dtc sc*.fpt sc*.mem sc*.txt *.#fp *.#nu *.#le *.#lp *.#ls *.#db

cd C:\TOTVS11\Microsiga\Protheus_Data\data
del /F /Q *.lck *.idx *.cdx *.ind

cd C:\TOTVS11\Microsiga\Protheus_Data\profile
del /F /Q *.lck *.idx *.cdx *.ind
