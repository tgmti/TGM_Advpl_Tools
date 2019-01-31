#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}GerXmlNfe
  ====================================================================================================================
	@description
	Função que cria um arquivo XML para teste da rotina NfeSefaz

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	2.0
	@since		15/02/2013
	@return	Nil

	@sample	U_GerXmlNfe()

/*/
//===================================================================================================================\\
User Function GerXMLNFe()

	Local nTipo:= 0
	Local cDirExp:= ""
	Local lRetExp:= .F.
	Local oStepWiz
	Local oStep1
	Local oStep2

	oStepWiz:= FWWizardControl():New(/*oPanelBkg*/)//Instancia a classe FWWizard
	oStepWiz:ActiveUISteps()

	// Passo 1 - Tipo e Diretório de Exportação
	oStep1:= oStepWiz:AddStep("1", {|Panel|nTipo:= 0, SelTipo(Panel)})
	oStep1:SetStepDescription("Tipo e Diretório de Exportação")

	oStep1:SetNextAction({|| nTipo:= Val(Left(MV_PAR01,1)), cDirExp:= AllTrim(MV_PAR02), ( ! Empty(nTipo) .And. ExistDir(cDirExp) ) })

	// Passo 2 - Dados para Exportação
	oStep2:= oStepWiz:AddStep("2", {|Panel|SelFiltros(Panel, nTipo)})
	oStep2:SetStepDescription("Filtros")

	// Execução - Exportação do XML
	oStep2:SetNextAction( {||	FWMsgRun(	/*oComp*/, {|oSay| lRetExp:= SfExport(nTipo, cDirExp) }, ;
												/*cHeader*/, /*cText*/"Exportando XML..." ) ;
									, lRetExp } )

	oStepWiz:Activate()
	oStepWiz:Destroy()

Return ( Nil )
// FIM da Funcao GerXMLNFe
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}SelTipo
  ====================================================================================================================
	@description
	Seleciona o tipo e o Diretório para Exportação

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		3 de out de 2017

/*/
//===================================================================================================================\\
Static function SelTipo(oPanel)

	Local cLoad:= "GERXMLSTIP"
	Local aPerg:= {}
	Local lRet:= .F.
	Local nOpcoes
	Private aRetTipo:= {}

	/*
	 2 - Combo
	  [2] : Descrição
	  [3] : Numérico contendo a opção inicial do combo
	  [4] : Array contendo as opções do Combo
	  [5] : Tamanho do Combo
	  [6] : Validação
	  [7] : Flag .T./.F. Parâmetro Obrigatório ?
	*/

	aAdd( aPerg, { 2, "Tipo", 1, {"1-Saída", "2-Entrada", "3-CT-e", "4-MDF-e", "5-MDF-e 3.0"}, 60, /*cValid*/, .T. } )
	aAdd(aRetTipo, aTail(aPerg)[3])

	/* 6 - File
	  [2] : Descrição
	  [3] : String contendo o inicializador do campo
	  [4] : String contendo a Picture do campo
	  [5] : String contendo a validação
	  [6] : String contendo a validação When
	  [7] : Tamanho do MsGet
	  [8] : Flag .T./.F. Parâmetro Obrigatório ?
	  [9] : Texto contendo os tipos de arquivo Ex.: "Arquivos .CSV |*.CSV"
	  [10]: Diretório inicial do cGetFile
	  [11]: PARAMETROS do cGETFILE
	*/
	nOpcoes:= GETF_LOCALHARD + GETF_NETWORKDRIVE  + GETF_RETDIRECTORY
	aAdd( aPerg, { 6, "Diretório para gravação", "", /*cPicTure*/, 'ExistDir(AllTrim(MV_PAR02))', /*cWhen*/, 60, .T., /*cTipos*/, "C:\", nOpcoes } )
	aAdd(aRetTipo, aTail(aPerg)[3])

	Parambox ( aPerg,  /*cTitle*/, @aRetTipo, /*bOk*/, /*aButtons*/, /*lCentered*/.T., /*nPosX*/, /*nPosy*/, /*oDlgWizard*/oPanel, cLoad, /*lCanSave*/.T., /*lUserSave*/.T. )

Return ( Nil )
// FIM da Funcao SelTipo
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}SelFiltros
  ====================================================================================================================
	@description
	Filtros específicos por tipo de exportação

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		4 de out de 2017

/*/
//===================================================================================================================\\
Static Function SelFiltros(oPanel, nTipo)

	Local cLoad:= "GERXMLSFIL"
	Local aPerg:= {}
	Private aRetFil:= {}


	aAdd( aPerg, { 2, "Ambiente", 1, {"1-Producao", "2-Homologacao"}, 60, /*cValid*/, .T. } )
	aAdd(aRetFil, aTail(aPerg)[3])

	If nTipo == 1 // Nota Saída
		aAdd( aPerg, { /*nTipo*/1, "Série", Space(TamSX3("F2_SERIE")[1]), "@!", /*cValid*/, /*cF3*/"01", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ .T. } )
		aAdd(aRetFil, aTail(aPerg)[3])
		aAdd( aPerg, { /*nTipo*/1, "Nota Saída", Space(TamSX3("F2_DOC")[1]), "@!", /*cValid*/, /*cF3*/"SF2", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ } )
		aAdd(aRetFil, aTail(aPerg)[3])

	ElseIf nTipo == 2 // Nota Entrada
		aAdd( aPerg, { /*nTipo*/1, "Série", Space(TamSX3("F1_SERIE")[1]), "@!", /*cValid*/, /*cF3*/"01", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ .T. } )
		aAdd(aRetFil, aTail(aPerg)[3])
		aAdd( aPerg, { /*nTipo*/1, "Nota Entrada", Space(TamSX3("F1_DOC")[1]), "@!", /*cValid*/, /*cF3*/"SF102", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ } )
		aAdd(aRetFil, aTail(aPerg)[3])
		aAdd( aPerg, { /*nTipo*/1, "Fornecedor", Space(TamSX3("A2_COD")[1]), "@!", /*cValid*/, /*cF3*/"SA2", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ } )
		aAdd(aRetFil, aTail(aPerg)[3])
		aAdd( aPerg, { /*nTipo*/1, "Loja", Space(TamSX3("A2_LOJA")[1]), "@!", /*cValid*/, /*cF3*/"SA22", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ } )
		aAdd(aRetFil, aTail(aPerg)[3])

	ElseIf nTipo == 3 // CT-e
		aAdd( aPerg, { /*nTipo*/1, "Série", Space(TamSX3("F2_SERIE")[1]), "@!", /*cValid*/, /*cF3*/"01", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ .T. } )
		aAdd(aRetFil, aTail(aPerg)[3])
		aAdd( aPerg, { /*nTipo*/1, "Conhecimento", Space(TamSX3("F2_DOC")[1]), "@!", /*cValid*/, /*cF3*/"SF2", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ } )
		aAdd(aRetFil, aTail(aPerg)[3])

	ElseIf nTipo == 4 .Or. nTipo == 5 // MDF-e ou MDF-e 3.0
		aAdd( aPerg, { /*nTipo*/1, "Fil.Manif.", Space(TamSX3("DTX_FILMAN")[1]), "@!", /*cValid*/, /*cF3*/, /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ .T. } )
		aAdd(aRetFil, aTail(aPerg)[3])
		aAdd( aPerg, { /*nTipo*/1, "Serie", Space(TamSX3("DTX_SERMAN")[1]), "@!", /*cValid*/, /*cF3*/"01", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ .T. } )
		aAdd(aRetFil, aTail(aPerg)[3])
		aAdd( aPerg, { /*nTipo*/1, "Manifesto", Space(TamSX3("DTX_MANIFE")[1]), "@!", /*cValid*/, /*cF3*/"DTX", /*cWhen*/, /*nTam*/60, /*lObrigatorio*/ .T. } )
		aAdd(aRetFil, aTail(aPerg)[3])

	EndIf

	Parambox( aPerg,/*cTitle*/, @aRetFil, /*bOk*/, /*aButtons*/, /*lCentered*/, /*nPosX*/, /*nPosy*/, oPanel, cLoad, /*lCanSave*/.T., /*lUserSave*/.T. )

Return ( Nil )
// FIM da Funcao SelFiltros
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}SfExport
  ====================================================================================================================
	@description
	Exportação de XML

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		4 de out de 2017

/*/
//===================================================================================================================\\
Static Function SfExport(nTipo, cDirExp)

	Local lRet:= .F.
	Local aXmlNfe
	Local cArqXml:= ""
	Local nCreArq

	Private PARAMIXB

	If nTipo == 1 // Nota Saída

		DbSelectArea("SF2")
		DbSetOrder(1) // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO

		If MsSeek(xFilial("SF2") + MV_PAR03 + MV_PAR02)

			PARAMIXB:= { {/*cTipo*/"1", , /*cSerie*/MV_PAR02, /*cNota*/MV_PAR03, /*cClieFor*/ SF2->F2_CLIENTE , /*cLoja*/SF2->F2_LOJA, /*aMotivoCont*/{}}, ;
							/*cVerAmb*/"3.10", /*cAmbiente*/ MV_PAR01, {/*cNotaOri*/"", /*cSerieOri*/""} }

			aXmlNfe:= ExecBlock("XmlNfeSef",.F.,.F.,PARAMIXB)
			cArqXml:= "NFE_"
			lRet:= .T.
		Else
			Help('',1,'',,"Nota fiscal de saída não encontrada!",03,00)
		EndIf

	ElseIf nTipo == 2 // Nota Entrada

		DbSelectArea("SF1")
		DbSetOrder(1) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO

		If MsSeek( xFilial("SF1") + MV_PAR03 + MV_PAR02 + MV_PAR04 + MV_PAR05 )

			PARAMIXB:= { {/*cTipo*/"2", , /*cSerie*/MV_PAR02, /*cNota*/MV_PAR03, /*cClieFor*/ MV_PAR04 , /*cLoja*/MV_PAR05, /*aMotivoCont*/{}}, ;
							/*cVerAmb*/"3.10", /*cAmbiente*/ MV_PAR01, {/*cNotaOri*/"", /*cSerieOri*/""} }

			aXmlNfe:= ExecBlock("XmlNfeSef",.F.,.F.,PARAMIXB)
			cArqXml:= "NFE_"
			lRet:= .T.
		Else
			Help('',1,'',,"Nota fiscal de entrada não encontrada!",03,00)
		EndIf

	ElseIf nTipo == 3 // CT-e

		dbSelectArea("SF2")
		dbSetOrder(1) // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
		If MsSeek(xFilial("SF2") + MV_PAR03 + MV_PAR02)

			PARAMIXB:= {{/*cTipo*/"1", , /*cSerie*/MV_PAR02, /*cNota*/MV_PAR03, /*cClieFor*/ SF2->F2_CLIENTE , /*cLoja*/SF2->F2_LOJA, /*aMotivoCont*/{}}, ;
							/*cVerAmb*/"3.10", /*cAmbiente*/ MV_PAR01, /*cModalidade*/"1" }

			aXmlNfe:= ExecBlock("XmlCteSef",.F.,.F.,PARAMIXB)

		Else
			Help('',1,'',,"CT-e Não encontrado!",03,00)
		EndIf

	ElseIf nTipo == 4 .Or. nTipo == 5 // MDF-e ou MDF-e 3.0

		Private lUsaColab:= .F.
		cIdEnt:= RetIdEnti(lUsaColab)
		cTimeZone:= StaticCall(TMSAE73, TZoneUTC, cIdEnt)
		Default cTimeZone:= "-03:00"
		cVerAmb:= If( nTipo == 4, "1.00", "3.00" )

		PARAMIXB:= {	/*cFilMan*/MV_PAR02, /*cNumMan*/ MV_PAR04, /*cAmbiente*/MV_PAR01, cVerAmb, ;
						/*cModalidade*/"1", /*cEvento*/"I", /*cSerMan*/ MV_PAR03, cTimeZone }

		If nTipo == 4
			aXmlNfe := ExecBlock("XmlMdfSef",.F.,.F.,PARAMIXB)
			lRet:= .T.
			cArqXml:= ""
		ElseIf nTipo == 5
			aXmlNfe := ExecBlock("MdfeSf30",.F.,.F.,PARAMIXB)
			cArqXml:= ""
			lRet:= .T.
		EndIf

	EndIf

	If lRet

		If valtype(aXmlNfe)=="A" ;
			.And. Len(aXmlNfe)>=2 ;
			.And. valtype(aXmlNfe[1])=="C" ;
			.And. valtype(aXmlNfe[2])=="C" ;
			.And. ! Empty(aXmlNfe[2]) ;

			cArqXml+= AllTrim(aXmlNfe[1]) + ".XML"

			nCreArq := fCreate(cDirExp+cArqXml)
			If nCreArq != -1
				// Grava Arquivo TXT
				If fwrite(nCreArq, aXmlNfe[2], Len(aXmlNfe[2])) == Len(aXmlNfe[2])
					lRet:=.T.
				EndIf
			EndIf

			// Fecha arquivo TXT
			fclose(nCreArq)

			// Se a exportação não funcionou, deleta o arquivo criado
			If lRet
				MsgInfo("Arquivo "+cDirExp+cArqXml+" criado com sucesso!","Sucesso")
				ShellExecute("open", cDirExp+cArqXml, "", "", 1 )
			Else
				Help('',1,'',,"Erro ao gravar o arquivo "+cDirExp+cArqXml+"!",03,00)
				ferase(cDirExp+cArqXml)
			EndIf

		Else
			Help('',1,'',,"Problema na Geração do XML!",03,00)

		EndIf

	EndIf

Return ( lRet )
// FIM da Funcao SfExport
//======================================================================================================================



