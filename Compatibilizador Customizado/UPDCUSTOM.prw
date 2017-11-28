#INCLUDE 'TOTVS.ch'
#INCLUDE "Protheus.ch"
#INCLUDE "UPDCUSTOM.CH"

//====================================================================================================================\\
/*/{Protheus.doc}UPDCUSTOM
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
CLASS UPDCUSTOM

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
// FIM da Definição da Classe UPDCUSTOM
//====================================================================================================================\\



//====================================================================================================================\\
/*/{Protheus.doc}New
  ====================================================================================================================
	@description
	Método que criador da classe

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016
	@return		Objeto, Instância em da classe UPDCUSTOM

/*/
//====================================================================================================================\\
METHOD New() CLASS UPDCUSTOM

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
	@return		Objeto, Instância em da classe UPDCUSTOM

/*/
//====================================================================================================================\\
METHOD RunUpdate() CLASS UPDCUSTOM
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
/*/{Protheus.doc}FSTProc
  ====================================================================================================================
	@description
	Função de processamento da gravação dos arquivos

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016
	@return		Objeto, Instância em da classe UPDCUSTOM

/*/
//====================================================================================================================\\
METHOD FSTProc( lEnd, aMarcadas, lAuto ) CLASS UPDCUSTOM

	Local aInfo     := {}
	Local aRecnoSM0 := {}
	Local cAux      := ""
	Local cFile     := ""
	Local cFileLog  := ""
	Local cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
	Local cTCBuild  := "TCGetBuild"
	Local cTexto    := ""
	Local cTopBuild := ""
	Local lOpen     := .F.
	Local lRet      := .T.
	Local nI        := 0
	Local nPos      := 0
	Local nRecno    := 0
	Local nX        := 0
	Local oDlg      := NIL
	Local oFont     := NIL
	Local oMemo     := NIL
	Local nQtdAtu    := 0

	Default lAuto:= .F.

	Private aArqUpd   := {}

	If ( lOpen := MyOpenSm0(.T.) )

		dbSelectArea( "SM0" )
		dbGoTop()

		While !SM0->( EOF() )
			// Só adiciona no aRecnoSM0 se a empresa for diferente
			If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
			.AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
				aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
			EndIf
			SM0->( dbSkip() )
		End

		SM0->( dbCloseArea() )

		If lOpen

			For nI := 1 To Len( aRecnoSM0 )

				If !( lOpen := MyOpenSm0(.F.) )
					MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
					Exit
				EndIf

				SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

				RpcSetType( 3 )
				RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

				lMsFinalAuto := .F.
				lMsHelpAuto  := .F.

				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( Replicate( " ", 128 ) )
				AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
				AutoGrLog( Replicate( " ", 128 ) )
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( " " )
				AutoGrLog( " Dados Ambiente" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
				AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
				AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
				AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
				AutoGrLog( " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time() )
				AutoGrLog( " Environment........: " + GetEnvServer()  )
				AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
				AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
				AutoGrLog( " Versão.............: " + GetVersao(.T.) )
				AutoGrLog( " Usuário TOTVS .....: " + __cUserId + " " +  cUserName )
				AutoGrLog( " Computer Name......: " + GetComputerName() )

				aInfo   := GetUserInfo()
				If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
					AutoGrLog( " " )
					AutoGrLog( " Dados Thread" )
					AutoGrLog( " --------------------" )
					AutoGrLog( " Usuário da Rede....: " + aInfo[nPos][1] )
					AutoGrLog( " Estação............: " + aInfo[nPos][2] )
					AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
					AutoGrLog( " Environment........: " + aInfo[nPos][6] )
					AutoGrLog( " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
				EndIf
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( " " )

				If !lAuto
					AutoGrLog( Replicate( "-", 128 ) )
					AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
				EndIf

				If Len(::aSX1) > 0
					nQtdAtu++
				EndIf

				If Len(::aSX2) > 0
					nQtdAtu++
				EndIf

				If Len(::aSIX) > 0
					nQtdAtu++
				EndIf

				If Len(::aSX3) > 0
					nQtdAtu++
				EndIf

				If Len(::aSX6) > 0
					nQtdAtu++
				EndIf

				If Len(::aSX7) > 0
					nQtdAtu++
				EndIf

				oProcess:SetRegua1( nQtdAtu )

				If Len(::aSX2) > 0
					//------------------------------------
					// Atualiza o dicionário SX2
					//------------------------------------
					oProcess:IncRegua1( "Dicionário de arquivos (SX2)" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
					FSAtuSX2(::aSX2)
				EndIf

				If Len(::aSX3) > 0
					//------------------------------------
					// Atualiza o dicionário SX3
					//------------------------------------
					oProcess:IncRegua1( "Dicionário de campos (SX3)" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
					FSAtuSX3(::aSX3)
				EndIf

				If Len(::aSIX) > 0
					//------------------------------------
					// Atualiza o dicionário SIX
					//------------------------------------
					oProcess:IncRegua1( "Dicionário de índices (SIX)" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
					FSAtuSIX(::aSIX)
				EndIf

				oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
				oProcess:SetRegua2( "Atualizando campos/índices" )

				// Alteração física dos arquivos
				__SetX31Mode( .F. )

				If FindFunction(cTCBuild)
					cTopBuild := &cTCBuild.()
				EndIf

				For nX := 1 To Len( aArqUpd )

					oProcess:IncRegua2( "Sincronizando Arquivo " + aArqUpd[nX] + " com o banco de dados..." )

					If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
						If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
							!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
							TcInternal( 25, "CLOB" )
						EndIf
					EndIf

					If Select( aArqUpd[nX] ) > 0
						dbSelectArea( aArqUpd[nX] )
						dbCloseArea()
					EndIf

					X31UpdTable( aArqUpd[nX] )

					If __GetX31Error()
						Alert( __GetX31Trace() )
						AutoGrLog( "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] )
						MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					EndIf

					If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
						TcInternal( 25, "OFF" )
					EndIf

				Next nX

				If Len(::aSX1) > 0
					//------------------------------------
					// Atualiza os helps
					//------------------------------------
					oProcess:IncRegua1( "Grupos de Pergunta (SX1)" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
					FSAtuSX1(::aSX1)
				EndIf

				If Len(::aSX6) > 0
					//------------------------------------
					// Atualiza os helps
					//------------------------------------
					oProcess:IncRegua1( "Parâmetros (SX6)" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
					FSAtuSX6(::aSX6)
				EndIf

				If Len(::aSX7) > 0
					//------------------------------------
					// Atualiza os helps
					//------------------------------------
					oProcess:IncRegua1( "Gatilhos (SX7)" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
					FSAtuSX7(::aSX7)
				EndIf

				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
				AutoGrLog( Replicate( "-", 128 ) )

				RpcClearEnv()

			Next nI

			If !lAuto

				cTexto := LeLog()

				Define Font oFont Name "Mono AS" Size 5, 12

				Define MsDialog oDlg Title "Atualização concluida." From 3, 0 to 340, 417 Pixel

				@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
				oMemo:bRClicked := { || AllwaysTrue() }
				oMemo:oFont     := oFont

				Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
				Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
				MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

				Activate MsDialog oDlg Center

			EndIf

		EndIf

	Else

		lRet := .F.

	EndIf

Return (lRet)
// FIM do método FSTProc
//====================================================================================================================\\



//====================================================================================================================\\
/*/{Protheus.doc}AddTable
  ====================================================================================================================
	@description
	Adiciona uma Tabela (SX2) para atualizar

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016
	@return		Objeto, Instância em da classe UPDCUSTOM

/*/
//====================================================================================================================\\
METHOD AddTable(cAlias, cNome, cModo, cModoEmp, cModoUni, aPropAdic) CLASS UPDCUSTOM

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
	@return		Objeto, Instância em da classe UPDCUSTOM

/*/
//====================================================================================================================\\
METHOD AddIndex(cAlias, cOrdem, cChave, cDescricao cNickName, aPropAdic) CLASS UPDCUSTOM

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
	@return		Objeto, Instância em da classe UPDCUSTOM

/*/
//====================================================================================================================\\
METHOD AddField(cAlias, cCampo, cOrdem, cTipo, cTitulo, cDescricao, nTamanho, nDecimal, aPropAdic) CLASS UPDCUSTOM

	Local nX

	Default cOrdem:= "  "
	Default cTipo:= "C"
	Default nDecimal:= 0
	Default aPropAdic:= {}

	aAdd( ::aSX3, {} )

	aAdd( aTail(::aSX3, {"X3_ARQUIVO", cAlias} )
	aAdd( aTail(::aSX3, {"X3_CAMPO", cCampo} )
	aAdd( aTail(::aSX3, {"X3_ORDEM", cOrdem} )
	aAdd( aTail(::aSX3, {"X3_TIPO", cTipo} )
	aAdd( aTail(::aSX3, {"X3_TITULO", cTitulo} )
	aAdd( aTail(::aSX3, {"X3_DESCRIC", cDescricao} )
	aAdd( aTail(::aSX3, {"X3_TAMANHO", nTamanho} )
	aAdd( aTail(::aSX3, {"X3_DECIMAL", nDecimal} )

	For nX:= 1 To Len(aPropAdic)
		aAdd( aTail(::aSX3, {aPropAdic[nX,1], aPropAdic[nX,2]} )
	Next nX

Return (Nil)
// FIM do método AddField
//====================================================================================================================\\