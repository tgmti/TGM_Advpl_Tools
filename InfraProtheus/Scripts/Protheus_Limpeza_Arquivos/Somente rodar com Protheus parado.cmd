c:
cd \
set PData=C:\TOTVS\Microsiga\Protheus_Data\

forfiles -p "%PData%logs" -s -d -60 -m *.* -c "cmd /c del /f /q @path"
forfiles -p "%PData%spool" -s -d -1 -m *.* -c "cmd /c del /f /q @path"
forfiles -p "%PData%pswbackup" -d -60 -m * -c "cmd /c rmdir /s /q @path"
forfiles -p "%PData%system" -m *.idx -c "cmd /c rmdir /s /q @path"

c:
cd \
rmdir /S /Q %PData%system\ctreeint
rmdir /S /Q %PData%data\ctreeint
rmdir /S /Q %PData%profile\ctreeint

cd %PData%system
del /F /Q *.lck *.idx *.cdx *.ind sc*.log sc*.dbf sc*.dtc sc*.fpt sc*.mem sc*.txt *.#fp *.#nu *.#le *.#lp *.#ls *.#db

cd %PData%data
del /F /Q *.lck *.idx *.cdx *.ind

cd %PData%profile
del /F /Q *.lck *.idx *.cdx *.ind
