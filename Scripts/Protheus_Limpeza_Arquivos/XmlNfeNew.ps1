c:

#$retroagir=1
#$date = Get-Date
#$date=$date.AddDays(-$retroagir)
#$dia = $date.ToString('dd')
#$mes = $date.ToString('MM')
#$ano = $date.ToString('yyyy')
#echo $dia$mes$ano 
#
#mkdir C:\TOTVS\Microsiga\Protheus_Data\XMLNFE\OLD\$ano
#mkdir C:\TOTVS\Microsiga\Protheus_Data\XMLNFE\OLD\$ano\$mes
#mkdir C:\TOTVS\Microsiga\Protheus_Data\XMLNFE\OLD\$ano\$mes\$dia
#
#forfiles -p "C:\TOTVS\Microsiga\Protheus_Data\XMLNFE\OLD" -d -$retroagir -m *.* -c "cmd /c move @path C:\TOTVS\Microsiga\Protheus_Data\XMLNFE\OLD\$ano\$mes\$dia"

cd C:\TOTVS\Microsiga\Protheus_Data\XMLNFE\OLD\

ForEach ($file in Get-ChildItem -Filter *.xml){
	$date=$file.CreationTime   
	$dia = $date.ToString('dd')
	$mes = $date.ToString('MM')
	$ano = $date.ToString('yyyy')
	
	if (! (Test-Path .\$ano) ) {
		mkdir $ano
	}
	if (! (Test-Path .\$ano\$mes) ) {
		mkdir $ano\$mes
	}
	if (! (Test-Path .\$ano\$mes\$dia) ) {
		mkdir $ano\$mes\$dia
	}
	
	Move-Item .\$file .\$ano\$mes\$dia\$file
}