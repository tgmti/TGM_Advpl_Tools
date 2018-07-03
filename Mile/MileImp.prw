#Include 'Protheus.ch'
#Include 'fileio.ch'


Static cIdOper

//====================================================================================================================\
/*/{Protheus.doc}MileImp
  ====================================================================================================================
	@description
	Rotina de importação para adicionar ao Mile

	@author TSC681 Thiago Mota
	@version 1.0
	@since 02/07/2018

	@obs
	http://tdn.totvs.com/display/framework/MILE+-+Model+Integrator+Layout+Engine

/*/
//===================================================================================================================\
User Function MileImp(lInterface, aInfAdic, aLayout, aDados)
	
	Local xRet
	Local nLinIni:= aInfAdic[1] // Linha inicial
	Local nLinAtu:= aInfAdic[2] // Linha Atual
	Local cArqPrc:= aInfAdic[3] // Arquivo processado
	Local cFunImp

	Private cLog
	Private cDetalhe


	If Empty(cIdOper) .Or. nLinAtu == 1
		cIdOper:= DToS(MsDate())+"."+AllTrim(Str(Seconds()))
	EndIf

	// Verifico se existe a função passada no código do canal MASTER
	cFunImp:= AllTrim(aLayout[2,1,1])
	If aLayout[2,1,4] == "MASTER" .And. FindFunction(cFunImp)
		
		cLog:= cDetalhe:= ""

		xRet:= &cFunImp.(lInterface, aDados[1,4,1])

		If ! xRet .And. ! Empty(cLog)

			cDetalhe+= CRLF + "Linha: " + CRLF + GravaErro(cArqPrc, nLinAtu)

			RecLock("XXE", .T.)
			XXE->XXE_ID:= XXEProx() // Próximo ID
			XXE->XXE_ADAPT:= aLayout[1,3]
			XXE->XXE_FILE:= cArqPrc
			XXE->XXE_LAYOUT:= aLayout[1,1]
			XXE->XXE_DESC:= aLayout[1,11]
			XXE->XXE_DATE:= MsDate()
			XXE->XXE_TIME:= Time()
			XXE->XXE_TYPE:= "2" // Tipo = Erro
			XXE->XXE_ERROR:= cLog
			XXE->XXE_USRID:= __cUserId
			XXE->XXE_USRNAM:= cUserName
			XXE->XXE_COMPLE:= cDetalhe
			XXE->XXE_ORIGIN:= cValtoChar(nLinIni) + "-" + cValToChar(nLinAtu)
			XXE->XXE_IDOPER:= cIdOper
			XXE->(MsUnlock())

		EndIf
	Else
		xRet:= .F.
	EndIf

Return ( xRet )
// FIM da Funcao MileImp
//======================================================================================================================



//====================================================================================================================\
/*/{Protheus.doc}MILEDADO
  ====================================================================================================================
	@description
	Retorna o conteúdo de um campo a partir do Array de dados

	@author TSC681 Thiago Mota
	@version 1.0
	@since 03/07/2018

/*/
//===================================================================================================================\
User Function MILEDADO( aDados, cCampo, xValue )
	Local nPos

	If ValType( aDados ) == "A" .And. Len(aDados) > 0
		nPos:= aScan(aDados, {|x| AllTrim(x[1]) == AllTrim(cCampo) })
		If nPos > 0 .And. Len(aDados[nPos]) > 1
			If xValue == Nil
				xValue:= aDados[nPos][2]
			Else
				aDados[nPos][2]:= xValue
			EndIf

		ElseIf xValue != Nil
			aAdd(aDados, {cCampo, xValue, Nil})
		EndIf
	EndIf

Return ( xValue )
// FIM da Funcao MILEDADO
//======================================================================================================================



//====================================================================================================================\
/*/{Protheus.doc}XXEProx
  ====================================================================================================================
	@description
	Retorna o próximo número para a tabela XXE

	@author TSC681 Thiago Mota
	@version 1.0
	@since 03/07/2018

/*/
//===================================================================================================================\
Static Function XXEProx()
	
	Local cRet:= StrZero(0, Len(XXE->XXE_ID))
	Local cQry := ''
	Local cAli := GetNextAlias()
	
	cQry+= " SELECT MAX(XXE_ID) XXE_ID "
	cQry+= " FROM " + RetSqlTab('XXE')
	cQry+= " WHERE " + RetSqlCond('XXE')
	
	cQry:= ChangeQuery(cQry)
	
	If Select(cAli) <> 0
		(cAli)->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQry),cAli, .F., .T.)
	
	If (cAli)->(!Eof())
		cRet:= (cAli)->XXE_ID
	EndIf
	
	If Select(cAli) <> 0
		(cAli)->(DbCloseArea())
	EndIf
	
	cRet:= Soma1(cRet)

Return ( cRet )
// FIM da Funcao XXEProx
//======================================================================================================================



//====================================================================================================================\
/*/{Protheus.doc}GravaErro
  ====================================================================================================================
	@description
	Grava as linhas com erro em outro arquivo

	@author TSC681 Thiago Mota
	@version 1.0
	@since 03/07/2018

/*/
//===================================================================================================================\
Static Function GravaErro( cArqPrc, nLinAtu )
	
	Local oFileIn:= FWFileReader():New(cArqPrc)
	Local nLiRead:= 0
	Local cLiRead
	Local cLinRet:= ""
	Local cFileOu:= cArqPrc + ".err"
	Local nHndlOu


	If oFileIn:Open()
		While oFileIn:HasLine() .And. nLiRead < nLinAtu
			nLiRead++
			cLiRead:= oFileIn:GetLine()
			If nLiRead == nLinAtu .And. ! Empty( cLiRead )
				cLinRet:= cLiRead
				If File( cFileOu )
					nHndlOu:= FOpen( cFileOu, FO_READWRITE + FO_SHARED )
				Else
					nHndlOu:= FCreate( cFileOu )
				Endif

				If nHndlOu >= 0
					FSeek( nHndlOu, 0, FS_END )
					FWrite( nHndlOu, cLinRet )
					FClose( nHndlOu )
				EndIf
			EndIf
		EndDo
	EndIf

Return ( cLinRet )
// FIM da Funcao GravaErro
//======================================================================================================================



