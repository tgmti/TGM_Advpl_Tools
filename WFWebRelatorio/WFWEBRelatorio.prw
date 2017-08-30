#Include 'Rwmake.ch'
#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}WFWEBRelatorio
  ====================================================================================================================
	@description
	Classe que extende TWFProcess com Funções úteis para geração de relatório gráfico utilizando HTML

	@author		TSC681 - Thiago Mota
	@version	1.0
	@since		02/08/2013

/*/
//======================================================================================================================

CLASS WFWEBRelatorio FROM TWFProcess
	DATA cFileRel
	DATA cPatchRel
	DATA oDlgRel
	DATA oTIBrowser

	METHOD New( pcCodigo, pcDescricao, pcReferencia ) CONSTRUCTOR
	METHOD WebRel( cCaption, cFileRel, cPatchRel, lCancelTask, lDelFile, nWidth, nHeight  )
	METHOD EnvMail( lAuto )

ENDCLASS

//-----------------------------------------------------------------
METHOD New( pcCodigo, pcDescricao, pcReferencia ) CLASS WFWEBRelatorio
	_Super:New( pcCodigo, pcDescricao, pcReferencia )
Return ( SELF )


//====================================================================================================================\\
/*/{Protheus.doc}WEBREL
  ====================================================================================================================
	@description
	Exibe o arquivo HTML gerado para o WF em uma página da WEB (Protheus Browser)

	@author		TSC681 - Thiago Mota
	@version	1.0
	@since		02/08/2013
	@return		Nil, Padrão:  -

	@param		cCaption	,Título da janela
	@param		cFileRel	,Nome do arquivo temporário do relatório
	@param		cPatchRel	,Caminho para salvar o arquivo temporário
	@param		lCancelTask	,Indica se deve cancelar a tarefa do WF após fechar a tela
	@param		lDelFile	,Indica se deve apagar o arquivo temporário após fechar a tela
	@param		nWidth		,Largura da tela
	@param		nHeight		,Altura da tela

/*/
//======================================================================================================================
METHOD WebRel( cCaption, cFileRel, cPatchRel, lCancelTask, lDelFile, nWidth, nHeight  ) CLASS WFWEBRelatorio
	Default cCaption	:= ::FDesc // Título padrão da janela é a descrição do processo do WF
	Default cFileRel	:= GetNextAlias()
	Default cPatchRel	:= GetTempPath()
	Default lCancelTask	:= .T.
	Default lDelFile	:= .T.
	If !Empty(nWidth) .Or. !Empty(nHeight)
		Default nWidth		:= 800 //TODO: Determinar largura e altura padrão melhores
		Default nHeight		:= 600
	EndIf

	// WorkArround para tratar caminho temporário quando possui caractere "."
	If At(".",cPatchRel) > 0
		cPatchRel:= "C:\Temp\"
		If !ExistDir(cPatchRel)
			MakeDir(cPatchRel)
		EndIf
	EndIf

	::oHtml:SaveFile( cPatchRel + cFileRel )

	If ::oDlgRel==Nil
		::oDlgRel:= TDialog():New( , , , , , , , , nil, , , , , .T. )
	EndIf
	If ::oTIBrowser==Nil
		::oTIBrowser:= TIBrowser():New( 0, 0, 0, 0, "", ::oDlgRel )
	EndIf


	::oDlgRel:cCaption	:= cCaption
	::oTIBrowser:nLeft	:= 5
	::oTIBrowser:nTop	:= 5

	If !Empty(nWidth) .And. !Empty(nHeight)
		::oDlgRel:nWidth	:= nWidth
		::oDlgRel:nHeight	:= nHeight
		::oTIBrowser:nWidth	:= ::oDlgRel:nWidth - 15
		::oTIBrowser:nHeight:= ::oDlgRel:nHeight - 65
	Else
		::oDlgRel:lMaximized:= .T.
		::oDlgRel:lCentered	:= .T.
		::oTIBrowser:nHeight:= ::oDlgRel:oWnd:nHeight - 65
		::oTIBrowser:nWidth := ::oDlgRel:oWnd:nWidth - 15
	EndIf

	oBt1:= TButton():New( 10, 050, "Imprimir", ::oDlgRel, {|| ::oTIBrowser:Print() }, 80, 10, , , , /*lPixel*/.T. )
	oBt3:= TButton():New( 10, 150, "E-mail", ::oDlgRel, {|| lCancelTask:= .F., ::EnvMail() }, 80, 10, , , , /*lPixel*/.T. )
	oBt2:= TButton():New( 10, 250, "Sair", ::oDlgRel, {|| ::oDlgRel:End() }, 80, 10, , , , /*lPixel*/.T. )

	oBt1:nTop:= ::oTIBrowser:nBottom + 10
	oBt2:nTop:= ::oTIBrowser:nBottom + 10
	oBt3:nTop:= ::oTIBrowser:nBottom + 10

	::oTIBrowser:Navigate( cPatchRel+cFileRel+".htm" )
	::oDlgRel:activate(/*[ uParam1]*/, /*[ uParam2]*/, /*[ uParam3]*/, .T. )

	If lDelFile
		fErase(cPatchRel+cFileRel+".htm")
	EndIf

	If lCancelTask
		::Free() //TODO: Verificar se este é o método certo para liberar/cacelar o WF
	EndIf

Return ( Nil )

// FIM do Método WEBREL
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}EnvMail
  ====================================================================================================================
	@description
	Método para envio do e-mail dentro do relatório

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		17/09/2014

/*/
//===================================================================================================================\\
METHOD EnvMail( lAuto ) CLASS WFWEBRelatorio

	Local cDest	:= Padr( ::cTo, Max(Len(::cTo),255) )
	Local cCopy	:= ::cCC
	Local cMsAl	:= "Informe o endereço de e-mail"
	Local oLblMail, oGetMail

	Default lAuto:= IsBlind()

	Private oDlgMail

	If !lAuto
		@ 100,153 To 229,585 Dialog oDlgMail Title OemToAnsi("Endereço de e-mail")
		@ 19,9 SAY oLblMail PROMPT OemToAnsi("E-mail:") SIZE 99,8 OF oDlgMail PIXEL
		@ 18,29 MSGET oGetMail VAR cDest SIZE 179,10 OF oDlgMail PIXEL

		@ 42,59  BMPBUTTON TYPE 1 ACTION ( If( Empty(cDest), Alert(cMsAl), Close(oDlgMail) ) )
		@ 42,99  BMPBUTTON TYPE 2 ACTION (cDest:="",Close(oDlgMail))

		Activate Dialog oDlgMail Centered
	EndIf

	If !Empty(cDest)
		::cTo	:= cDest
		::cCC	:= cCopy
		::Start()
		If !lAuto
			MsgInfo("E-mail enviado com sucesso para '"+ AllTrim(cDest) +"'","Envio de E-mail")
		EndIf
	EndIf

Return ( Nil )
// FIM do método EnvMail
//======================================================================================================================

// FIM da Classe WFWEBRelatorio
//======================================================================================================================