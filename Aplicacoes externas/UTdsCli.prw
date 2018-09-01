#INCLUDE 'PROTHEUS.CH'

//====================================================================================================================\
/*/{Protheus.doc}UTDSCli
  ====================================================================================================================
	@description
	Classe para executar compilação e aplicação de patches via TDSCli

	@author TSC681 Thiago Mota
	@version 1.0
	@since 31/08/2018

/*/
//===================================================================================================================\
// Dummy
User Function UTDSCli()
Return (.T.)

Class UTDSCli From LongClassName

	Data cIncludes
	Data cPathConf
	Data cPathTmp
	Data cFileConf
	Data cPathTDS
	Data cAuthorization
	Data cBuild
	Data cCommand
	Data cEnvironment
	Data cFilterProgram
	Data cServerType
	Data cPort
	Data cProgram
	Data cProgramList
	Data cPsw
	Data cRecompile
	Data cServer
	Data cServerName
	Data cUser
	Data cWorkspace
	Data cTdsCliBat


	Method New() Constructor
	Method Exec(cCommand)

EndClass
// FIM da definição da Classe UTDSCli
//======================================================================================================================


//====================================================================================================================\
/*/{Protheus.doc}UTDSCli:New
  ====================================================================================================================
	@description
	Método Construtor da Classe

	@author TSC681 Thiago Mota
	@version 1.0
	@since 31/08/2018

/*/
//===================================================================================================================\
Method New() Class UTDSCli
	
	::cTdsCliBat:= "TDSCLI.bat"
	::cServerType:= "Advpl"

Return ( Self )
// FIM da Funcao UTDSCli:New
//======================================================================================================================


//====================================================================================================================\
/*/{Protheus.doc}UTDSCli:Exec
  ====================================================================================================================
	@description
	Método que executa o TDSCli

	@author TSC681 Thiago Mota
	@version 1.0
	@since 31/08/2018

/*/
//===================================================================================================================\
Method Exec(cCommand) Class UTDSCli
	
	Local lRet:= .F.
	Local cCmdExec:= ""
	Local lWaitRun:= .T.

	cCmdExec:= ::cPathTDS + ::cTdsCliBat + " " + cCommand

	If ! Empty(::cFileConf)
		cCmdExec += " @" + ::cFileConf
	EndIf

	If WaitRunSrv( @cCmdExec, @lWaitRun , ::cPathTDS )
		ConOut("Sucess")
		lRet:= .T.
	Else
		ConOut("Error")
	EndIf

Return ( lRet )
// FIM do Método UTDSCli:Exec
//======================================================================================================================




