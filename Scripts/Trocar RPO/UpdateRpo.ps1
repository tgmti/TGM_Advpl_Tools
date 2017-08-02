

function UpdateApo($IniAlt, $Env_Name, $New_ApoFile) {

    $Env_Found=$false
    $Env_OK=$false    
    $New_Lines= @()

    foreach ($line in Get-Content $IniAlt) {
        
        If (! $Env_OK ) {
            if (! $Env_Found ) { 
                $Env_Found = ( $line.ToUpper() -match '\[' + $Env_Name.ToUpper() + '\]' )
            } elseif ($line -match '\[') {    
                # Para loop com erro "Ambiente não encontrado no arquivo"
                return $false
            }
        }

        if ($Env_Found -and $line.ToUpper() -like '*SOURCEPATH=*') {
            $New_Lines+= 'SourcePath=' + $New_ApoFile
            $Env_OK=$true
        } else {
            $New_Lines+= $line
        }

    }

    if ($Env_OK){
        Set-Content $IniAlt $New_Lines
        return $true
    } else {
        return $false
    }

}




#####################################
# CONFIGURAÇÕES
#####################################

cls
$seqAtu=1
$rpoFile='tttp110.rpo'
$incFilter='*.txt'
$ini='appserver.ini'
$ambientes=@('environment', 'env_job')
$origem='\\192.168.80.10\c$\TOTVS\Microsiga\Protheus\apo\comp\'
$caminhoPrd='TOTVS\Microsiga\Protheus\apo\producao\'
$caminhoRPO='C:\' + $caminhoPrd
$destList=@()
$serverList=@()

$SlavesMaster=20
$SlavesJobs=3

$destList+= '\\192.168.80.10\c$\' + $caminhoPrd
$destList+= '\\192.168.80.18\c$\' + $caminhoPrd

#MASTER
$serverList+= '\\192.168.80.10\c$\TOTVS\Microsiga\Protheus\bin\appserver\'

#SLAVES
for($i=1; $i -le $SlavesMaster; $i++){
    $serverList+= '\\192.168.80.10\c$\TOTVS\Microsiga\Protheus\bin\appserver_slv' + $i.ToString('00') + "\"
}


#JOB MASTER
$serverList+= '\\192.168.80.18\c$\TOTVS\Microsiga\Protheus\bin\appserverJobs\'

#JOB SLAVES
for($i=1; $i -le $SlavesJobs; $i++){
    $serverList+= '\\192.168.80.18\c$\TOTVS\Microsiga\Protheus\bin\appserverJobs_slv' + $i.ToString('00') + "\"
}


#####################################
# Verifica todos os destinos e avalia a sequência
#####################################

$data = (Get-Date).ToString('yyyyMMdd')

foreach ($dirDest in $destList){
    
    # Retorna o diretório com maior nome para a data, se encontrar e for maior do que a seq.atual, incrementa a mesma.
    try {
        $seqMax= ( [int]((Get-ChildItem -Path $dirDest -Filter ($data + '_*') | select name | Measure-Object -Property name -Maximum).Maximum).ToString().Substring(9) )

    } catch {
        $seqMax= 0
    }

    if($seqMax -ge $seqAtu) {
        $seqAtu = $seqMax + 1
    }

}

$dirSeq = $data + '_' + $seqAtu + "\"


###############################################
# Crio o novo diretório e copio o arquivo
###############################################
foreach ($dirDest in $destList){
    Robocopy.exe $origem $dirDest$dirSeq $rpoFile /W:1 /R:1
}

#TODO: Testar se o arquivo está no destino e se o tamanho está de acordo

foreach ($srvAtu in $serverList) {
	if(Test-Path ($dirDest + $dirSeq + $rpoFile) ){
		foreach ($envAtu in $ambientes){
			UpdateApo ($srvAtu + $ini) $envAtu ($caminhoRPO + $dirSeq)
		}
	} else {
		echo ('Erro: Não encontrou o diretório ' + ($dirDest + $dirSeq + $rpoFile) )
	}
}
