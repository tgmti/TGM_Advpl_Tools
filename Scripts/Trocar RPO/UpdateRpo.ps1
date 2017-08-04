#Requires -Version 5.0
#
# ========================================================================================
#  Rotina para automatizar a troca de RPO´s em ambientes complexos
# ========================================================================================
# 
# 	@author		TSC681 Thiago Mota
# 	@version	1.0
# 	@since		02/08/2017
#
# ========================================================================================



# ========================================================================================
#  Configurações da rotina
# ========================================================================================
# 
# 	@author		TSC681 Thiago Mota
# 	@version	1.0
# 	@since		02/08/2017
# 
# ========================================================================================
function configParam() {

	$Script:rpoFile='tttp110.rpo'
	$Script:iniFile='appserver.ini'
	$Script:origPath='\\192.168.80.10\c$\TOTVS\Microsiga\Protheus\apo\comp\'
	$Script:prdPath='TOTVS\Microsiga\Protheus\apo\producao\'

	###############################################
	# Lista de servidores e arquivos a copiar
	# Formato dos elementos do Array:
	#@{ 	
	#	'Environment'= [Ambiente que será atualizado];
	#	'PathDestin' = [Caminho de destino onde será copiado o arquivo RPO];
	#	'SourcePath' = [SourcePath que será informado no INI;
	#	'Master_Ini' = [Caminho para o Ini do Master];
	#	'Slaves_Ini' = [Base para o Caminho do Ini nos Slaves];
	#	'Slaves_Qtd' = [Quantidade de Slaves]
	#}
	###############################################
	$Private:serverList=@()

	$serverList+= @{ 
		'Environment'= 'environment';
		'PathDestin' = '\\192.168.80.10\c$\' + $prdPath;
		'SourcePath' = 'C:\' + $prdPath;
		'Master_Ini' = '\\192.168.80.10\c$\TOTVS\Microsiga\Protheus\bin\appserver\';
		'Slaves_Ini' = '\\192.168.80.10\c$\TOTVS\Microsiga\Protheus\bin\appserver_slv';
		'Slaves_Qtd' = 20;
        'Slave_Mask' = '00'
	}

	$serverList+= @{ 
		'Environment'= 'env_job';
		'PathDestin' = '\\192.168.80.18\c$\' + $prdPath;
		'SourcePath' = 'C:\' + $prdPath;
		'Master_Ini' = '\\192.168.80.18\c$\TOTVS\Microsiga\Protheus\bin\appserverJobs\';
		'Slaves_Ini' = '\\192.168.80.18\c$\TOTVS\Microsiga\Protheus\bin\appserverJobs_slv';
		'Slaves_Qtd' = 3;
        'Slave_Mask' = '00'
	}
	
	return $serverList
}
# Fim das Configurações
# ========================================================================================



# ========================================================================================
#  Retorna o diretorio destino sequencial esperado para o arquivo
# ========================================================================================
# 
# 	@author		TSC681 Thiago Mota
# 	@version	1.0
# 	@since		02/08/2017
# 
# ========================================================================================
function GetSeqPath($Private:Dest_List) {
	
	$Private:dirSeq=''
	$Private:data = (Get-Date).ToString('yyyyMMdd')
	$Private:seqMax= [int]0
	$Private:seqAtu= [int]1

	foreach ($Private:dirDest in $Dest_List){
        ## ( [int]((Get-ChildItem -Path $dirDest -Filter ($data + '_*') | select name | Measure-Object -Property name -Maximum).Maximum).ToString().Substring(9) )

		# Retorna o diretório com maior nome para a data
        foreach ($Private:dirDat in (Get-ChildItem -Path $dirDest -Filter ($data + '_*') | select name)  ){

		    try {
			    $seqMax= ( [int]$dirDat.Name.ToString().Substring(9) )

		    } catch {
			    $seqMax= [int]0
		    }

		    # Se encontrar a sequência e for maior do que a seq.atual, incrementa a mesma.
		    if($seqMax -ge $seqAtu) {
			    $seqAtu = $seqMax + [int]1
		    }

        }

	}

	$dirSeq = $data + '_' + $seqAtu.ToString() + "\"

    return $dirSeq
}
# Fim da Função GetSeqPath
# ========================================================================================



# ========================================================================================
#  Atualiza o valor de uma chave no arquivo Ini
# ========================================================================================
# 
# 	@author		TSC681 Thiago Mota
# 	@version	1.0
# 	@since		02/08/2017
# 
# ========================================================================================
function UpdateApo($Private:fileChange, $Private:sectionChange, $Private:keyChange, $Private:newValue) {

    $Private:sectionFound=$false
    $Private:valueChanged=$false    
    $Private:newLineList= @()

    foreach ($Private:lineAtu in Get-Content $fileChange) {
        
        If (! $valueChanged ) {
            if (! $sectionFound ) { 
                $sectionFound = ( $lineAtu.ToUpper() -match '\[' + $sectionChange.ToUpper() + '\]' )
            } elseif ($lineAtu -match '\[') {    
                # Para loop com erro "Ambiente não encontrado no arquivo"
                return $false
            }
        }

        if ($sectionFound -and $lineAtu.ToUpper() -like '*' + $keyChange.ToUpper() + '=*') {
            $newLineList+= $keyChange + '=' + $newValue
            $valueChanged=$true
        } else {
            $newLineList+= $lineAtu
        }

    }

    if ($valueChanged){
		## TODO: TESTE
		#$fileChange = 'c:\Temp\appserver_NOVO.ini'
        Set-Content $fileChange $newLineList
		
		##TODO: TESTE
		#pause
        return $true
    } else {
        return $false
    }

}
# Fim da Função UpdateApo
# ========================================================================================



# ========================================================================================
#  Rotina principal
# ========================================================================================
# 
# 	@author		TSC681 Thiago Mota
# 	@version	1.0
# 	@since		02/08/2017
# 
# ========================================================================================
function execRotin($Private:serverList) {

	$Private:datSeq = GetSeqPath ($serverList.'PathDestin')
	$Private:copyOk = $False

	if($datSeq){

		#######################################################
		# Verifica se os arquivos já não existem nos destinos
		#######################################################
		foreach ($Private:desPath in ($serverList.'PathDestin')){

			If (Test-Path ( $desPath + $datSeq + $rpoFile ) ){
				echo ('Já existe o diretório: ' + $desPath + $datSeq)
				echo 'Procedimento abortado'
				return $false
			}

		}

		
		###############################################
		# Copiar os arquivos para os diretórios destino
		###############################################
		foreach ($Private:desPath in ($serverList.'PathDestin')){

			Robocopy.exe $origPath $desPath$datSeq $rpoFile /W:1 /R:1
			
			If ( ( Test-Path ( $desPath + $datSeq + $rpoFile ) ) ){
				$copyOk=$True
			} Else {
				#TODO: Testar Também se o tamanho está correto
				echo ('Não foi possível copiar o arquivo para: ' + $desPath + $datSeq)
				return $false
			}

		}
	} else {
		echo 'Não foi possível Calcular o Path destino'
		return $false
	}

	if (! $copyOk){
		echo 'Nenhum arquivo copiado'
		return $False
	}

	###############################################
	# Executa  a atualização dos arquivos INI
	###############################################
	foreach ($Private:srvAtu in $serverList) {
		
		$Private:sourcePath = $srvAtu.'SourcePath' + $datSeq
		$Private:masterIni = $srvAtu.'Master_Ini' + $iniFile
		
		# Atualiza o Master
		if (! ( UpdateApo $masterIni $srvAtu.'Environment' 'SourcePath' $sourcePath ) ){
			echo ('Erro ao atualizar o arquivo ' + $masterIni)
			return $false
		}
		
		
		# Atualiza os Slaves
		for($Private:slvAtu=1; $slvAtu -le $srvAtu.'Slaves_Qtd'; $slvAtu++){
		
			$Private:slvIni= $srvAtu.'Slaves_Ini' + $slvAtu.ToString( $srvAtu.'Slave_Mask' ) + "\" + $iniFile
			
			if ( ! ( UpdateApo $slvIni $srvAtu.'Environment' 'SourcePath' $sourcePath ) ){
				echo ('Erro ao atualizar o arquivo ' + $slvIni)
				return $false
			}
		}
	}
	###############################################
	# Executa  a atualização dos arquivos INI - FIM
	###############################################

	return $true
}
# Fim da Rotina principal
# ========================================================================================



###############################################
# Execução do Script
###############################################
cls

if ( (Read-Host "Deseja copiar o RPO da COMP para a produção? (S/N)" ).ToUpper() -like "S" ) {
    if ( execRotin (configParam) ){
        if ( (Read-Host "Deseja reiniciar os serviços Jobs? (S/N)").ToUpper() -like "S" ){
            ## Script que gerencia os serviços do Protheus - 1 = Serviços Jobs, 3 - Reiniciar serviços
            \\192.168.80.18\c$\TOTVS\Microsiga\Protheus\ferramentas\ReiniciarServicos.bat 1 3
        }
    }
}

###############################################
###############################################


