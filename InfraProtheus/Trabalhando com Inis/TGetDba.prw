#Include 'Protheus.ch'


//====================================================================================================================\\
/*/{Protheus.doc}TGetDba
  ====================================================================================================================
	@description
	Função auxiliar que retorna os dados de conexão com o DbAccess a partir do AppServer.ini

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		2 de ago de 2017

/*/
//===================================================================================================================\\
User Function TGetDba()

	Local cApxSrvIni:= GetADV97()
	Local cEnvAtu	:= GetEnvServer()
	Local cDataBase	:= GetPvProf({"TOPDATABASE", "DBDATABASE"}, cEnvAtu, cApxSrvIni)
	Local cServer	:= GetPvProf({"TOPSERVER", "DBSERVER"}, cEnvAtu, cApxSrvIni)
	Local nPort		:= Val( GetPvProf({"TOPPORT", "DBPORT"}, cEnvAtu, cApxSrvIni) )
	Local cAliasDb	:= GetPvProf({"TOPALIAS", "DBALIAS"}, cEnvAtu, cApxSrvIni)
	Local aDadosDba

	If Empty(cDataBase)
		cDataBase:= GetPvProf({"DataBase"}, "DBAccess", cApxSrvIni)
	EndIf

	If Empty(cServer)
		cServer:= GetPvProf({"Server"}, "DBAccess", cApxSrvIni)
	EndIf

	If Empty(cAliasDb)
		cAliasDb:= GetPvProf({"ALIAS"}, "DBAccess", cApxSrvIni)
	EndIf

	If Empty(nPort)
		nPort:= Val( GetPvProf({"Port"}, "DBAccess", cApxSrvIni) )
		If Empty(nPort)
			nPort:= 7890
		EndIf
	EndIf

	aDadosDba	:= { cDataBase, cServer, nPort, cAliasDb }

Return ( aDadosDba )
// FIM da Funcao TGetDba
//======================================================================================================================


//====================================================================================================================\
/*/{Protheus.doc}GetPvProf
  ====================================================================================================================
	@description
	Retorna a chave do aruqivo .ini, testando várias opções

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version 1.0
	@since 28/02/2018

/*/
//===================================================================================================================\
Static Function GetPvProf(aKey, cEnvAtu, cApxSrvIni)

	Local cKeyRet:= ""
	Local nX:= 1

	While Empty(cKeyRet) .And. nX <= Len(aKey)
		cKeyRet:= GetPVProfString(cEnvAtu,aKey[nX],"",cApxSrvIni)
		nX++
	EndDo

Return( cKeyRet )
// FIM da Funcao GetPvProf
//======================================================================================================================


