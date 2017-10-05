#Include 'Protheus.ch'


//====================================================================================================================\\
/*/{Protheus.doc}TGetDba
  ====================================================================================================================
	@description
	Função auxiliar que retorna os dados de conexão com o DbAccess a partir do AppServer.ini

	@author	TSC681 Thiago Mota <thiago.mota@totvs.com.br>
	@version	1.0
	@since		2 de ago de 2017

/*/
//===================================================================================================================\\
User Function TGetDba()

	Local cApxSrvIni	:= GetADV97()
	Local cEnvAtu		:= GetEnvServer()
	Local cDataBase	:= GetPvProf({"TOPDATABASE", "DBDATABASE"}, cEnvAtu, cApxSrvIni)
	Local cServer		:= GetPvProf({"TOPSERVER", "DBSERVER"}, cEnvAtu, cApxSrvIni)
	Local nPort		:= Val( GetPvProf({"TOPPORT", "DBPORT"}, cEnvAtu, cApxSrvIni) )
	Local cAliasDb	:= GetPvProf({"TOPALIAS", "DBALIAS"}, cEnvAtu, cApxSrvIni)
	Local aDadosDba

	//TODO: Se não encontrou, bucar da chave DbAccess

	aDadosDba	:= { cDataBase, cServer, nPort, cAliasDb }

Return ( aDadosDba )
// FIM da Funcao TGetDba
//======================================================================================================================


Static Function GetPvProf(aKey, cEnvAtu, cApxSrvIni)

	Local cKeyRet:= ""
	Local nX:= 1

	While Empty(cKeyRet) .And. nX <= Len(aKey)
		cKeyRet:= GetPVProfString(cEnvAtu,aKey[nX],"",cApxSrvIni)
		nX++
	EndDo

Return( cKeyRet )



