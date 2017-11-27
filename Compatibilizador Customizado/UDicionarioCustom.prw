#INCLUDE 'TOTVS.ch'
#INCLUDE "Protheus.ch"

//====================================================================================================================\\
/*/{Protheus.doc}UDiconarioCustom
  ====================================================================================================================
	@description
	Classe utilizada para efetuar atualizações de dicionário customizadas
	Definição da classe

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016

	@obs
	.

/*/
//===================================================================================================================\\
CLASS UDiconarioCustom

	DATA aSX2
	DATA aSX3
	DATA aSIX
	DATA aSX6
	DATA aSX7
	DATA aSX1

	METHOD RunUpdate()
	METHOD AddSX2()
	METHOD AddSX3()
	METHOD AddSIX()
	METHOD AddSX6()
	METHOD AddSX7()
	METHOD AddSX1()

ENDCLASS
// FIM da Definição da Classe UDiconarioCustom
//====================================================================================================================\\



//====================================================================================================================\\
/*/{Protheus.doc}New
  ====================================================================================================================
	@description
	Método que criador da classe

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016
	@return		Objeto, Instância em da classe UDiconarioCustom

/*/
//====================================================================================================================\\
METHOD New() CLASS UDiconarioCustom

Return (SELF)
// FIM do método New
//====================================================================================================================\\



//====================================================================================================================\\
/*/{Protheus.doc}RunUpdate
  ====================================================================================================================
	@description
	Executa o compatibilizador

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016
	@return		Objeto, Instância em da classe UDiconarioCustom

/*/
//====================================================================================================================\\
METHOD RunUpdate() CLASS UDiconarioCustom
	Local lOk:= .F.
	Local aMsg:= {}
	Local aButton:= {}
	Local aMarcadas:= {}

	Private oMainWnd  := NIL
	Private oProcess  := NIL
	Private cDirComp  := NIL
	Private cFunAux   := cFuncUpd


	#IFDEF TOP
	    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
	#ENDIF

	__cInterNet := NIL
	__lPYME     := .F.

	Set Dele On

	// Mensagens de Tela Inicial
	aAdd( aMsg, "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )" )
	aAdd( aMsg, "Este processo deve ser executado em modo EXCLUSIVO." )

	// Botoes Tela Inicial
	aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
	aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

	FormBatch( cTitulo,  aMsg,  aButton )

	If lOk
		aMarcadas := EscEmpresa()

		If !Empty( aMarcadas )

			If MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
				oProcess := MsNewProcess():New( { | lEnd | lOk := ::FSTProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
				oProcess:Activate()

				If lOk
					Final( "Atualização Concluída." )
				Else
					Final( "Atualização não Realizada." )
				EndIf

			Else
				MsgStop( "Atualização não Realizada.", "COMPDIC" )

			EndIf

		Else
			MsgStop( "Atualização não Realizada.", "COMPDIC" )

		EndIf

	EndIf

Return
// FIM do método RunUpdate
//====================================================================================================================\\



//====================================================================================================================\\
/*/{Protheus.doc}AddTable
  ====================================================================================================================
	@description
	Adiciona uma Tabela (SX2) para atualizar

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016
	@return		Objeto, Instância em da classe UDiconarioCustom

/*/
//====================================================================================================================\\
METHOD AddTable(cAlias, cNome, cModo, cModoEmp, cModoUni, aPropAdic) CLASS UDiconarioCustom

	Local nX

	Default cModo:= "C"
	Default cModoEmp:= " "
	Default cModoUni:= " "
	Default aPropAdic:= {}

	/* aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
				"X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
				"X2_POSLGT" , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" } */

	aAdd( ::aSX2, {} )

	aAdd( aTail(::aSX2, {"X2_CHAVE", cAlias} )
	aAdd( aTail(::aSX2, {"X2_NOME", cNome} )
	aAdd( aTail(::aSX2, {"X2_MODO", cModo} )
	aAdd( aTail(::aSX2, {"X2_MODOEMP", cModoEmp} )
	aAdd( aTail(::aSX2, {"X2_MODOUN", cModoUni} )

	For nX:= 1 To Len(aPropAdic)
		aAdd( aTail(::aSX2, {aPropAdic[nX,1], aPropAdic[nX,2]} )
	Next nX

Return (Nil)
// FIM do método AddTable
//====================================================================================================================\\



//====================================================================================================================\\
/*/{Protheus.doc}AddIndex
  ====================================================================================================================
	@description
	Adiciona um índice (SIX) para atualizar

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016
	@return		Objeto, Instância em da classe UDiconarioCustom

/*/
//====================================================================================================================\\
METHOD AddIndex(cAlias, cOrdem, cChave, cDescricao cNickName, aPropAdic) CLASS UDiconarioCustom

	Local nX

	Default cOrdem:= " "
	Default cNickName:= " "
	Default aPropAdic:= {}

	/* aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
				"DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" } */

	aAdd( ::aSIX, {} )

	aAdd( aTail(::aSIX, {"INDICE", cAlias} )
	aAdd( aTail(::aSIX, {"ORDEM", cOrdem} )
	aAdd( aTail(::aSIX, {"CHAVE", cChave} )
	aAdd( aTail(::aSIX, {"DESCRICAO", cDescricao} )
	aAdd( aTail(::aSIX, {"NICKNAME", cNickName} )

	For nX:= 1 To Len(aPropAdic)
		aAdd( aTail(::aSIX, {aPropAdic[nX,1], aPropAdic[nX,2]} )
	Next nX

Return (Nil)
// FIM do método AddIndex
//====================================================================================================================\\



//====================================================================================================================\\
/*/{Protheus.doc}AddField
  ====================================================================================================================
	@description
	Adiciona um campo (SX3) para atualizar

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016
	@return		Objeto, Instância em da classe UDiconarioCustom

/*/
//====================================================================================================================\\
METHOD AddField(cAlias, cOrdem, cChave, cDescricao cNickName, aPropAdic) CLASS UDiconarioCustom

	Local nX

	Default cOrdem:= " "
	Default cNickName:= " "
	Default aPropAdic:= {}

	/* aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
				"DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" } */

	aAdd( ::aSIX, {} )

	aAdd( aTail(::aSIX, {"INDICE", cAlias} )
	aAdd( aTail(::aSIX, {"ORDEM", cOrdem} )
	aAdd( aTail(::aSIX, {"CHAVE", cChave} )
	aAdd( aTail(::aSIX, {"DESCRICAO", cDescricao} )
	aAdd( aTail(::aSIX, {"NICKNAME", cNickName} )

	For nX:= 1 To Len(aPropAdic)
		aAdd( aTail(::aSIX, {aPropAdic[nX,1], aPropAdic[nX,2]} )
	Next nX

Return (Nil)
// FIM do método AddField
//====================================================================================================================\\