#INCLUDE 'PROTHEUS.CH'

//====================================================================================================================\
/*/{Protheus.doc}UTrocRPO
  ====================================================================================================================
	@description
	Classe para Fazer a troca de RPO a quente

	@author TSC681 Thiago Mota
	@version 1.0
	@since 31/08/2018

/*/
//===================================================================================================================\
// Dummy
User Function UTrocRPO()
Return (.T.)

Class UTrocRPO From LongClassName

	Data cIniFile
	Data cEnvironment
	Data cSrcFrom
	Data cSrcTo

	Method New() Constructor
	Method Exec()

EndClass
// FIM da definição da Classe UTrocRPO
//======================================================================================================================


//====================================================================================================================\
/*/{Protheus.doc}UTrocRPO:New
  ====================================================================================================================
	@description
	Método Construtor da Classe

	@author TSC681 Thiago Mota
	@version 1.0
	@since 31/08/2018

/*/
//===================================================================================================================\
Method New() Class UTrocRPO

Return ( Self )
// FIM da Funcao UTrocRPO:New
//======================================================================================================================


//====================================================================================================================\
/*/{Protheus.doc}UTrocRPO:Exec
  ====================================================================================================================
	@description
	Método que executa a Troca

	@author TSC681 Thiago Mota
	@version 1.0
	@since 31/08/2018

/*/
//===================================================================================================================\
Method Exec(cCommand) Class UTrocRPO
	
	Local lRet:= .F.
	Local cSrcActual:= ""
	Local cSeq

	cSrcActual:= GetPvProfString( ::cEnvironment, "SourcePath", "", ::cIniFile )

	cSeq:= Right(AllTrim(cSrcActual),1) //TODO: Melhorar a definição de sequência
	cSeq:= Soma1(cSeq)

	lRet:= WritePProString( ::cEnvironment, "SourcePath", ::cSrcTo, ::cIniFile )


Return ( lRet )
// FIM do Método UTrocRPO:Exec
//======================================================================================================================




