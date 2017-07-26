::========================================================================================
:: Rotina de Gestão Remota para Parar e Iniciar os serviços da TOTVS
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================

@ECHO OFF
SETLOCAL enabledelayedexpansion

CALL :ConfigVars

CALL :Cabecalho
CALL :SelecionaListaServicos
IF ERRORLEVEL 1 (
	CALL :Cabecalho
	CALL :SelecionaOpcao
)

IF ERRORLEVEL 1 (
	CALL :Cabecalho
	SET /P CONTINUA="Confirma a Operacao [S/N]: "
	
	IF /I "!CONTINUA!" NEQ "S" (
		EXIT /B 2
	) 
)

IF ERRORLEVEL 1 (
 	IF DEFINED OPCSTOP (
		CALL :Cabecalho
 		ECHO Parando servicos selecionados...
		ECHO.
		CALL :ExecSelServ EXECSTOP
		
		IF ERRORLEVEL 1 (
			ECHO.
			ECHO Aguardando parar os servicos...
			Timeout /T %TIMESTOP%
			CALL :Cabecalho
			ECHO Verificando se os servicos pararam
			CALL :ExecSelServ STSTOP
		)
		
 	)

)

IF ERRORLEVEL 1 (
	IF DEFINED OPCSTART (
		CALL :Cabecalho
		ECHO Iniciando servicos selecionados...
		ECHO.
		CALL :ExecSelServ EXECSTART
			
		IF ERRORLEVEL 1 (
			ECHO.
			ECHO Aguardando iniciar os servicos...
			Timeout /T %TIMESTART%
			CALL :Cabecalho
			ECHO Verificando se os servicos iniciaram corretamente
			ECHO.
			CALL :ExecSelServ STSTART
		)
		
	)
)

ECHO.
ECHO.
pause

EXIT /B %ERRORLEVEL%
:: Fim da rotina principal
::========================================================================================



::========================================================================================
:: Configuração das variáveis utilizadas
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================
:ConfigVars

SET FORCESTOP=1
SET TIMESTOP=60
SET TIMESTART=10
SET USRADM=transjoi\administrator
REM SET PSWADM=
SET SRVAPP=192.168.80.10
SET SRVLIC=192.168.80.10
SET SRVTSS=192.168.80.27
SET SRVDBA=192.168.80.12
SET SRVPRT=192.168.80.29
SET LISTJOBS=Totvs_Job_Master Totvs_Job_Slv01 Totvs_Job_Slv02 Totvs_Job_Slv03
SET LISTMASTER=Totvs_Master

:: Adiciona os 20 Slaves à lista do Master
FOR /L %%I IN (1,1,20) DO CALL :AddListMaster %%I

SET LISTLIC=TotvsLicenseServer
SET LISTDBA=DBAUDIT DBAccess64_AUDIT DBAccess64_Totvs11 
SET LISTTSS=DBAccess64 appserver_0101_MDFe appserver_0103_MDFe Totvs11_TSS

:: Adiciona os serviços de TSS e TSSNFSE das 8 filiais
FOR /L %%I IN (1,1,8) DO CALL :AddListTSS %%I


SET LISTPRT=TOTVS11_PRT_Master TOTVS11_PRT_SLV1 TOTVS11_PRT_SLV2 TOTVS11_PRT_SLV3 TOTVS11_PRT_Comp
SET LISTPRTDB=DBAccess64_PRT

EXIT /B 1
:: Fim da ConfigVars
::========================================================================================



::========================================================================================
:: Looping sobre a lista de servidores selecionada
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================
:ExecSelServ

FOR /L %%I IN (1,1,5) DO (
	
	
	
	IF NOT "!SERVER_SEL[%%I,1]!" == "" (
		CALL :ExecFunc %%I %1
	)
	
	IF "%1" EQU "EXECSTART" (
		IF NOT "!SERVER_SEL[%%I,3]!" == "" (
			Timeout /T !SERVER_SEL[%%I,3]!
			ECHO.
		)
	)
	
)

EXIT /B 1
:: Fim da ExecSelServ
::========================================================================================



::========================================================================================
:: Looping sobre os serviços selecionados de cada servidor
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================
:ExecFunc

	SET EXECSRV=!SERVER_SEL[%1,1]!
	SET EXECLST=!SERVER_SEL[%1,2]!
	SET EXECOPC=%2	
	
	FOR %%S IN (%EXECLST%) DO (
				
		IF %EXECOPC% EQU EXECSTOP ( 
			ECHO Parando servico %%S ...
			ECHO sc \\%EXECSRV% stop %%S > NUL	
		) 
		
		IF %EXECOPC% EQU EXECSTART ( 
			ECHO Iniciando servico %%S ...
			ECHO sc \\%EXECSRV% start %%S > NUL
		) 
		
		IF %EXECOPC% EQU STSTOP ( 
			ECHO Verificando servico %%S ...
			CALL :VerStatus %EXECSRV% %%S STOPPED
			IF ERRORLEVEL 2 (			
				ECHO.
				ECHO ============ERRO=================
				ECHO.
				ECHO ERRO ao parar o servico %%S ...
				ECHO.
				ECHO =================================
				ECHO.
			)
			ECHO.
		)
		
		IF %EXECOPC% EQU STSTART ( 
			ECHO Verificando servico %%S ...
			CALL :VerStatus %EXECSRV% %%S RUNNING
			IF ERRORLEVEL 2 (
				ECHO.
				ECHO ============ERRO=================
				ECHO.
				ECHO ERRO ao iniciar o servico %%S ...
				ECHO.
				ECHO =================================
				ECHO.
			)
			ECHO.
		)
		
	)
	
EXIT /B 1
:: Fim da ExecFunc
::========================================================================================


::========================================================================================
:: Adiciona os Slaves à Lista do Master
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================
:AddListMaster
IF %1 LSS 10 (
	SET SERV=Totvs_Slv0
) ELSE (
	SET SERV=Totvs_Slv
)
SET LISTMASTER=%LISTMASTER% %SERV%%1
EXIT /B 1
:: Fim da AddListMaster
::========================================================================================



::========================================================================================
:: Adiciona os Slaves à Lista do TSS
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================
:AddListTSS
IF %1 LSS 10 (
	SET SERV=appserver_010
) ELSE (
	SET SERV=appserver_01
)
SET LISTTSS=%LISTTSS% %SERV%%1
SET LISTTSS=%LISTTSS% %SERV%%1_NFSE
EXIT /B 1
:: Fim da AddListTSS
::========================================================================================



::========================================================================================
:: Exibe o Cabecalho da rotina
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================
:Cabecalho
CLS
ECHO =================================
ECHO      GESTAO SERVICOS TOTVS
ECHO =================================
IF DEFINED LISTA (
	ECHO Lista Escolhida: %LISTADSC%
)
IF DEFINED OPCAO (
	ECHO Opcao Escolhida: %OPCDSC%
)
ECHO.

EXIT /B 1
:: Fim da Cabecalho
::========================================================================================



::========================================================================================
:: Interage com o usuário para selecionar a lista de serviços
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================
:SelecionaListaServicos

ECHO =================================
ECHO LISTA DE SERVICOS:
ECHO =================================
ECHO 1 - Somente Jobs
ECHO 2 - Master, Slaves e Jobs
ECHO 3 - Licence Server e DbAccess
ECHO 4 - TSS
ECHO 5 - Todos (Exceto TSS)
ECHO 6 - Todos (Com TSS)
ECHO 7 - Prototipo
ECHO.
SET /P LISTA="Escolha a Lista de Servicos: "
ECHO.

IF "%LISTA%" == "1" ( 

	SET LISTADSC=1 - Somente Jobs
	SET SERVER_SEL[1,1]=%SRVAPP%
	SET SERVER_SEL[1,2]=%LISTJOBS%
	
) ELSE IF %LISTA% EQU 2 (

	SET LISTADSC=2 - Master, Slaves e Jobs
	SET SERVER_SEL[1,1]=%SRVAPP%
	SET SERVER_SEL[1,2]=%LISTJOBS% %LISTMASTER%
	
) ELSE IF %LISTA% EQU 3 (

	SET LISTADSC=3 - Licence Server e DbAccess
	SET SERVER_SEL[1,1]=%SRVLIC%
	SET SERVER_SEL[1,2]=%LISTLIC%
	SET SERVER_SEL[1,3]=5
	SET SERVER_SEL[2,1]=%SRVDBA%
	SET SERVER_SEL[2,2]=%LISTDBA%
	
) ELSE IF %LISTA% EQU 4 (

	SET LISTADSC=4 - TSS
	SET SERVER_SEL[1,1]=%SRVTSS%
	SET SERVER_SEL[1,2]=%LISTTSS%
	
) ELSE IF %LISTA% EQU 5 (

	SET LISTADSC=5 - Todos - Exceto TSS
	SET SERVER_SEL[1,1]=%SRVLIC%
	SET SERVER_SEL[1,2]=%LISTLIC%
	SET SERVER_SEL[1,3]=5	
	SET SERVER_SEL[2,1]=%SRVDBA%
	SET SERVER_SEL[2,2]=%LISTDBA%
	SET SERVER_SEL[3,1]=%SRVAPP%
	SET SERVER_SEL[3,2]=%LISTJOBS% %LISTMASTER%
	
) ELSE IF %LISTA% EQU 6 (

	SET LISTADSC=6 - Todos - Com TSS
	SET SERVER_SEL[1,1]=%SRVLIC%
	SET SERVER_SEL[1,2]=%LISTLIC%
	SET SERVER_SEL[1,3]=5
	SET SERVER_SEL[2,1]=%SRVDBA%
	SET SERVER_SEL[2,2]=%LISTDBA%
	SET SERVER_SEL[3,1]=%SRVAPP%
	SET SERVER_SEL[3,2]=%LISTJOBS% %LISTMASTER%
	SET SERVER_SEL[4,1]=%SRVTSS%
	SET SERVER_SEL[4,2]=%LISTTSS%
	
) ELSE IF %LISTA% EQU 7 (

	SET LISTADSC=7 - Prototipo
	SET SERVER_SEL[1,1]=%SRVDBA%
	SET SERVER_SEL[1,2]=%LISTPRTDB%
	SET SERVER_SEL[2,1]=%SRVPRT%
	SET SERVER_SEL[2,2]=%LISTPRT%
	
) ELSE (
	ECHO Lista selecionada invalida %LISTA%
	pause
	EXIT /B 0
)

EXIT /B 1
:: Fim da SelecionaListaServicos
::========================================================================================



::========================================================================================
:: Interage com usuário para selecionar a Função
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================
:SelecionaOpcao
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

EXIT /B 1
:: Fim da SelecionaOpcao
::========================================================================================



::========================================================================================
:: Função que analisa o status do serviço e derruba se o mesmo ainda estiver executando.
::========================================================================================
::
::	@author		TSC681 Thiago Mota
::	@version	1.0
::	@since		25/07/2017
::
::========================================================================================
:VerStatus
	SET RETURN=0
	
	sc \\%1 query %2 > %temp%\state.tmp
	
	FINDSTR /I "%3" %temp%\state.tmp || (
		IF /I "%3" EQU "STOPPED" (
			IF %FORCESTOP% EQU 1 (
				ECHO Forcando parada do servico %2
				ECHO taskkill /S %1 /U %USRADM% /P /T /F /FI "SERVICES eq %2"
			) ELSE SET RETURN=2
		) ELSE SET RETURN=2
		
	)
	
	DEL %temp%\state.tmp
	
EXIT /B %RETURN%
:: Fim da VerStatus
::========================================================================================



