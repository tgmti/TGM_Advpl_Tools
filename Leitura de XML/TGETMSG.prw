#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}TGETMSG
  ====================================================================================================================
	@description
	Recebe uma Mensagem e uma lista de parâmetros e retorna os dados encontrados

	@author	TSC681 Thiago Mota <thiago.mota@totvs.com.br>
	@version	1.0
	@since		31 de mar de 2017

/*/
//===================================================================================================================\\
User Function TGETMSG(cMsg, aParamStr, cPermitido, bCorte)

	Local aRet:= {}
	Local nX
	Local cAux
	Local aAux:= {}
	Local cValor
	Local lCorte

	Default cMsg:= ""
	Default aParamStr:= {}
	Default cPermitido:= "0123456789" // Padrão é somente números
	Default bCorte:= {|cValor, cBuffer| ! (cBuffer $ cPermitido) }

	// ==========================================================
	// Busca as Strings  dentro da Mensagem, e separa para buscar os códigos
	// ==========================================================
	cAux	:= Upper( cMsg )

	For nX:= 1 To Len(aParamStr)

		If ! Empty(AllTrim(aParamStr[nX]))
			nDe:= 1
			While nDe > 0
				nDe:= RAt( Upper( aParamStr[nX] ), cAux )
				If nDe > 0
					aAdd( aAux, SubStr( cAux, nDe + Len(aParamStr[nX]) ) )
					If nDe == 1
						nDe:= 0
					Else
						cAux:= SubStr( cAux, 1, --nDe )
					EndIf
				EndIf
			EndDo
		EndIf

	Next (nX)


	// ==========================================================
	// Separa os códigos nas mensagens encontradas
	// ==========================================================
	For nX:= 1 To Len(aAux)

		cAux	:= aAux[nX]
		cValor	:= ""
		nAt:= 0
		lCorte:= .F.

		While ! lCorte .And. ++nAt <= Len(cAux)

			cObsAtu:= Substr(cAux, 1, nAt)
			cBuffer:= Right(cObsAtu, 1)

			If cBuffer $ cPermitido
				cValor+= cBuffer
			EndIf

			If Eval( bCorte, cValor, cBuffer )
				lCorte:= .T.
				If ! Empty(cValor)
					aAdd(aRet, cValor)
				EndIf
			EndIf

		EndDo

	Next nX

Return ( aRet )
// FIM da Funcao TGETMSG
//======================================================================================================================