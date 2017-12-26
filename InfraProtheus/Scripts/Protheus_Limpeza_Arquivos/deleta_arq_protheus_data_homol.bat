@echo OFF
@echo Esse bat fara exclusao dos arquiros temporarios e lixos dentro da pasta protheus_data.
@echo Deve ser executado somente com o sistema PARADO!!!! 
@echo Deseja continuar?
pause
set pasta="C:\TOTVS12\Microsiga\protheus_data_homol\"


echo -------------------------------------------------------------------------------- > log.txt 
date /T >> log.txt
time /T >> log.txt
echo -------------------------------------------------------------------------------- >> log.txt

echo ***** tmp ********** >> log.txt
del /s /q /f %pasta%*.tmp >> log.txt
echo ***** LCK ********** >> log.txt
del /s /q /f %pasta%*.lck >> log.txt
echo ***** CDX ********** >> log.txt
del /s /q /f %pasta%*.cdx >> log.txt
echo ***** IDX ********** >> log.txt
del /s /q /f %pasta%*.idx >> log.txt
echo ***** LOG ********** >> log.txt
del /s /q /f %pasta%*.log >> log.txt
echo ***** BAK ********** >> log.txt
del /s /q /f %pasta%*.bak >> log.txt
echo ***** JOB ********** >> log.txt
del /s /q /f %pasta%*.job >> log.txt
echo ***** MEM********** >> log.txt
del /s /q /f %pasta%*.mem >> log.txt
echo ***** .#db ********** >> log.txt
del /s /q /f %pasta%*.#db >> log.txt
echo ***** .#fp ********** >> log.txt
del /s /q /f %pasta%*.#fp >> log.txt
echo ***** .#xnu ********** >> log.txt
del /s /q /f %pasta%*.#xnu >> log.txt
echo ***** .ind ********** >> log.txt
del /s /q /f %pasta%*.ind >> log.txt
echo ***** .int ********** >> log.txt
del /s /q /f %pasta%*.int >> log.txt
echo ***** .rel ********** >> log.txt
del /s /q /f %pasta%*.rel >> log.txt

echo ### FINALIZADO ### >> log.txt
echo ###################################################
echo ###################################################
echo Finalizado! Aperte qualquer tecla para sair
echo ###################################################
echo ###################################################
pause