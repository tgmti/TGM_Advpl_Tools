#Requires -Version 5.0
#
# ========================================================================================
#  Rotina de Gestão Remota para Parar e Iniciar os serviços da TOTVS
# ========================================================================================
#
# 	@author Thiago Mota
#	@author <mota.thiago@totvs.com.br>
#	@author <tgmspawn@gmail.com>
#
# 	@version	1.0
# 	@since		03/08/2017
#
# ========================================================================================


# ========================================================================================
#  Bloco de parâmetros (deve ser a primeira instrução dentro do Script)
# ========================================================================================
Param(
    [string]$listSel,
    [string]$optionSel,
    [boolean]$forceStop=$true
)
# Fim do Bloco de parâmetros
# ========================================================================================



# ========================================================================================
#  Exibe o Cabecalho da rotina
# ========================================================================================
#
# 	@author		Thiago Mota
# 	@version	2.0
# 	@since		03/08/2017
#
# ========================================================================================
function printHeader(){

    echo "================================="
    echo "     GESTAO SERVICOS TOTVS       "
    echo "================================="
    if ($listSel){
	    echo "Lista Escolhida: $listSel"
    }
    if ($optionSel){
        echo "Opcao Escolhida: $optionSel"
    }

}
# Fim da Função printHeader
# ========================================================================================



# ========================================================================================
#  Configuração das variáveis utilizadas
# ========================================================================================
#
# 	@author		Thiago Mota
# 	@version	2.0
# 	@since		03/08/2017
#
# ========================================================================================
function configParams(){

SET TIMESTOP=60
SET TIMESTART=10
SET USRADM=administrator
REM SET PSWADM=
SET SRVAPP=192.168.80.10
SET SRVJOB=192.168.80.18
SET SRVADT=192.168.80.12
SET SRVLIC=192.168.80.10
SET SRVTSS=192.168.80.27
SET SRVDBA=192.168.80.10
SET SRVPRT=192.168.80.29
SET LISTJOBS=Totvs_Job_Master Totvs_Job_Slv01 Totvs_Job_Slv02 Totvs_Job_Slv03
SET LISTMASTER=Totvs_Master

:: Adiciona os 20 Slaves à lista do Master
FOR /L %%I IN (1,1,20) DO CALL :AddListMaster %%I

SET LISTLIC=TotvsLicenseServer
SET LISTADT=DBAUDIT DBAccess64_AUDIT
SET LISTDBA=DBAccess64_Totvs11
SET LISTTSS=DBAccess64 appserver_0101_MDFe appserver_0103_MDFe Totvs11_TSS

:: Adiciona os serviços de TSS e TSSNFSE das 8 filiais
FOR /L %%I IN (1,1,8) DO CALL :AddListTSS %%I


SET LISTPRT=TOTVS11_PRT_Master TOTVS11_PRT_SLV1 TOTVS11_PRT_SLV2 TOTVS11_PRT_SLV3 TOTVS11_PRT_Comp
SET LISTPRTDB=DBAccess64_PRT


SET LISTA=0

IF "%1" NEQ "" SET LISTA=%1

IF %LISTA% EQU 0 (
	ECHO =================================
	ECHO LISTA DE SERVICOS:
	ECHO =================================
	ECHO.
	ECHO 1 - Somente Jobs
	ECHO 2 - Master e Slaves
	ECHO 3 - Licence Server e DbAccess
	ECHO 4 - TSS
	ECHO 5 - Todos [Exceto TSS]
	ECHO 6 - Todos [Com TSS]
	ECHO 7 - Prototipo
	ECHO.
	SET /P LISTA="Escolha a Lista de Servicos: "
	ECHO.
)

IF %LISTA% EQU 1 (

	SET LISTADSC=1 - Somente Jobs
	SET SERVER_SEL[1,1]=%SRVJOB%
	SET SERVER_SEL[1,2]=%LISTJOBS%

) ELSE IF %LISTA% EQU 2 (

	SET LISTADSC=2 - Master e Slaves
	SET SERVER_SEL[1,1]=%SRVAPP%
	SET SERVER_SEL[1,2]=%LISTMASTER%

) ELSE IF %LISTA% EQU 3 (

	SET LISTADSC=3 - Licence Server e DbAccess
	SET SERVER_SEL[1,1]=%SRVLIC%
	SET SERVER_SEL[1,2]=%LISTLIC%
	SET SERVER_SEL[1,3]=5
	SET SERVER_SEL[2,1]=%SRVADT%
	SET SERVER_SEL[2,2]=%LISTADT%
	SET SERVER_SEL[3,1]=%SRVDBA%
	SET SERVER_SEL[3,2]=%LISTDBA%

) ELSE IF %LISTA% EQU 4 (

	SET LISTADSC=4 - TSS
	SET SERVER_SEL[1,1]=%SRVTSS%
	SET SERVER_SEL[1,2]=%LISTTSS%

) ELSE IF %LISTA% EQU 5 (

	SET LISTADSC=5 - Todos - Exceto TSS
	SET SERVER_SEL[1,1]=%SRVLIC%
	SET SERVER_SEL[1,2]=%LISTLIC%
	SET SERVER_SEL[1,3]=5
	SET SERVER_SEL[2,1]=%SRVADT%
	SET SERVER_SEL[2,2]=%LISTADT%
	SET SERVER_SEL[3,1]=%SRVDBA%
	SET SERVER_SEL[3,2]=%LISTDBA%
	SET SERVER_SEL[4,1]=%SRVAPP%
	SET SERVER_SEL[4,2]=%LISTMASTER%
	SET SERVER_SEL[5,1]=%SRVJOB%
	SET SERVER_SEL[5,2]=%LISTJOBS%

) ELSE IF %LISTA% EQU 6 (

	SET LISTADSC=6 - Todos - Com TSS
	SET SERVER_SEL[1,1]=%SRVLIC%
	SET SERVER_SEL[1,2]=%LISTLIC%
	SET SERVER_SEL[1,3]=5
	SET SERVER_SEL[2,1]=%SRVADT%
	SET SERVER_SEL[2,2]=%LISTADT%
	SET SERVER_SEL[3,1]=%SRVDBA%
	SET SERVER_SEL[3,2]=%LISTDBA%
	SET SERVER_SEL[4,1]=%SRVAPP%
	SET SERVER_SEL[4,2]=%LISTMASTER%
	SET SERVER_SEL[5,1]=%SRVTSS%
	SET SERVER_SEL[5,2]=%LISTTSS%
	SET SERVER_SEL[6,1]=%SRVJOB%
	SET SERVER_SEL[6,2]=%LISTJOBS%

) ELSE IF %LISTA% EQU 7 (

	SET LISTADSC=7 - Prototipo
	SET SERVER_SEL[1,1]=%SRVPRT%
	SET SERVER_SEL[1,2]=%LISTPRTDB%
	SET SERVER_SEL[2,1]=%SRVPRT%
	SET SERVER_SEL[2,2]=%LISTPRT%

) ELSE (
	ECHO Lista selecionada invalida %LISTA%
	pause
	EXIT /B 0
)


SET OPCAO=0

IF "%1" NEQ "" SET OPCAO=%1

IF %OPCAO% EQU 0 (
	ECHO.
	ECHO =================================
	ECHO OPCAO DE EXECUCAO:
	ECHO =================================
	ECHO 1 - Parar Servicos
	ECHO 2 - Iniciar Servicos Parados
	ECHO 3 - Parar e Reiniciar Servicos
	ECHO.
	SET /P OPCAO="Escolha a Opcao: "
	ECHO.
)

IF %OPCAO%==1 (
	SET OPCDSC=1 - Parar Servicos
	SET OPCSTOP=1
) ELSE IF %OPCAO%==2 (
	SET OPCDSC=2 - Iniciar Servicos Parados
	SET OPCSTART=1
) ELSE IF %OPCAO%==3 (
	SET OPCDSC=3 - Parar e Reiniciar Servicos
	SET OPCSTOP=1
	SET OPCSTART=1
) ELSE (
	ECHO Opcao selecionada invalida
	pause
	EXIT /B 0
)


}
# Fim da configParams
# ========================================================================================



clear
configParams
printHeader

if($forceStop) { echo 'ok' } else { 'nok' }