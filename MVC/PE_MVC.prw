#Include 'Protheus.ch'

// Ponto de entrada padrão em todas as rotinas MVC
// Exemplo que pode ser utilizado para testes

User Function PE_MVC()

	Local aParam	:= PARAMIXB
	Local xRet		:= .T.
	Local oObj		:= ''
	Local cIdPonto	:= ''
	Local cIdModel	:= ''
	Local lIsGrid	:= .F.
	Local nLinha	:= 0
	Local nQtdLinhas:= 0
	Local cMsg		:= ''
	Local cClasse	:= ''

	If aParam <> NIL

		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid := ( Len( aParam ) > 3 )

		If lIsGrid
			//nQtdLinhas := oObj:GetQtdLine()
			//nLinha := oObj:nLine
		EndIf

		If cIdPonto == 'MODELPOS'
			cMsg := 'Chamada na validação total do modelo (MODELPOS).' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF

			If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
				Help( ,, 'Help',, 'O MODELPOS retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'FORMPOS'

			cMsg := 'Chamada na validação total do formulário (FORMPOS).' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF

			If cClasse == 'FWFORMGRID'
				cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ;
					' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF

			ElseIf cClasse == 'FWFORMFIELD'
				cMsg += 'É um FORMFIELD' + CRLF
			EndIf
			If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
				Help( ,, 'Help',, 'O FORMPOS retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'FORMLINEPRE'
			If aParam[5] == 'DELETE'
				cMsg := 'Chamada na pré validação da linha do formulário (FORMLINEPRE).' + CRLF
				cMsg += 'Onde esta se tentando deletar uma linha' + CRLF
				cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
				cMsg += 'ID ' + cIdModel + CRLF

				If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
					Help( ,, 'Help',, 'O FORMLINEPRE retornou .F.', 1, 0 )
				EndIf

			EndIf
		ElseIf cIdPonto == 'FORMLINEPOS'
			cMsg := 'Chamada na validação da linha do formulário (FORMLINEPOS).' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF
			cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ;
				' linha(s).' + CRLF
			cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
			If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
				Help( ,, 'Help',, 'O FORMLINEPOS retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'MODELCOMMITTTS'
			ApMsgInfo('Chamada apos a gravação total do modelo e dentro da transação (MODELCOMMITTTS).' + CRLF + 'ID ' + cIdModel )
		ElseIf cIdPonto == 'MODELCOMMITNTTS'
			ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação (MODELCOMMITNTTS).' + CRLF + 'ID ' + cIdModel)
		//ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
		ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
			ApMsgInfo('Chamada apos a gravação da tabela do formulário (FORMCOMMITTTSPOS).' + CRLF + 'ID ' + cIdModel)
		ElseIf cIdPonto == 'MODELCANCEL'
			cMsg := 'Chamada no Botão Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'
			If !( xRet := ApMsgYesNo( cMsg ) )
				Help( ,, 'Help',, 'O MODELCANCEL retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'MODELVLDACTIVE'
			cMsg := 'Chamada na validação da ativação do Model.' + CRLF + ;
				'Continua ?'
			If !( xRet := ApMsgYesNo( cMsg ) )
				Help( ,, 'Help',, 'O MODELVLDACTIVE retornou .F.', 1, 0 )
			EndIf
		ElseIf cIdPonto == 'BUTTONBAR'
			ApMsgInfo('Adicionando Botão na Barra de Botões (BUTTONBAR).' + CRLF + 'ID ' + cIdModel )
			xRet := { {'Salvar', 'SALVAR', { || Alert( 'Salvou' ) }, 'Este botão Salva' } }
		EndIf
	EndIf


Return

