#Include 'Protheus.ch'


//====================================================================================================================\\
/*/{Protheus.doc}XmlChild
  ====================================================================================================================
	@description
	Leitura de uma Tag XML

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		28/02/2015

/*/
//===================================================================================================================\\
User Function XmlChild( oXml, xTag, cTipRet, cResVal, xConteudo, lValido, nOpcArr, nI )
	Local xResult
	Local xRet
	Local aTag
	Local nLen
	Local lExit		:= .F.
	Local oNivelAt	:= oXml //TODO:Testar se é por referência
	Local lRetPad	:= ValType(cTipRet)=="C" .And. cTipRet $ "A/C/N/D/H/O"

	Default cTipRet	:= "C"	// C = Caractere, A = Array, D = Data, N = Número, H = Hora, O = Objeto
	Default cResVal	:= "R"	// V = Validação, R = Resultado
	Default lValido	:= .F.
	Default nOpcArr	:= 1	// 0 - Primeiro elemento, 1 - Primeiro elemento com valor
	Default nI		:= 1

	If Valtype(xTag)=="C"
		aTag:= StrToKarr( xTag, ":" )
	EndIf
	nLen:= Len(aTag)

	While !lExit .And. nI <= nLen
		If ! Empty( XmlChildEx(oNivelAt, Upper(aTag[nI]) ) )
			oNivelAt:= XmlChildEx(oNivelAt, Upper(aTag[nI]) )
			If ValType( oNivelAt )=="A" .And. nI < nLen

				For nJ:= 1 To Len(oNivelAt)
					xResult:= U_XmlChild(oNivelAt[nJ], xTag, cTipRet, cResVal, xConteudo, lValido, nOpcArr, nI+1)
					If nOpcArr == 0
						lExit:=.T.
					ElseIf nOpcArr == 1 .And. ! Empty(xResult)
						lExit:= .T.
					EndIf
				Next (nJ)

			ElseIf nI == nLen

				xResult:= oNivelAt

				If cTipRet != ValType(xResult)

					If cTipRet != "A" .And. ValType(xResult)=="O" .And. ! Empty( XmlChildEx(xResult, 'TEXT' ) )
						xResult:= XmlChildEx(xResult, 'TEXT' )
					ElseIf cTipRet == "A" .And. ValType(xResult) == "O"
						xResult:= { xResult }
					EndIf

				EndIf

			EndIf

		Else
			lExit:= .T.
		EndIf
		nI++
	EndDo

	If lRetPad
		If cTipRet $ "C/N/D/H"
			lRetPad:= Empty(xResult) .Or. ValType(xResult) != "C"
		Else
			lRetPad:= ValType(xResult) != cTipRet
		EndIf
	EndIf

	If cTipRet == "C" .And. lRetPad
		xResult:= ""
	ElseIf cTipRet == "O" .And. lRetPad
		xResult:= Nil
	ElseIf cTipRet == "A" .And. lRetPad
		If ValType(xResult) == "O"
			xResult:= { xResult }
		Else
			xResult:= {}
		Endif
	ElseIf cTipRet == "N"
		xResult:= If(lRetPad, 0, Val(xResult))
	ElseIf cTipRet == "D"
		xResult:= If(lRetPad, CTod("  /  /    "), Stod(StrTran(xResult,"-","")))
	ElseIf cTipRet == "H"
		If ! lRetPad .And. At("T",xResult) > 0
			xResult:= StrTran(SubStr( xResult, At("T",xResult)+1, 5 ),":","")
		Else
			xResult:= "0000"
		EndIf
	EndIf

	/*If xResult != Nil
		xConteudo:= xResult
	ElseIf xConteudo != Nil
		xResult:= xConteudo
	EndIf*/

	If cResVal == "V"
		xRet:= lValido
	Else
		xRet:= xResult
	EndIf

Return ( xRet )
// FIM da Funcao XmlChild
//======================================================================================================================


