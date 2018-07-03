#INCLUDE "PROTHEUS.CH"



//====================================================================================================================\
/*/{Protheus.doc}MILIMCLI
  ====================================================================================================================
	@description
	Importação de cadastro de clientes via Mile

	@author TSC681 Thiago Mota
	@version 1.0
	@since 02/07/2018

	@obs
	Recebe os dados tratado da rotina MileImp e tenta cadastrar na SA1 usando o ExecAuto do MATA030

/*/
//===================================================================================================================\
User Function MILIMCLI( lInterface, aDados )

	Local lRet:= .T.
	Local cCgcCli:= U_MILEDADO(aDados, "A1_CGC")
	Local cCodCli
	Local cLojCli
	Local lIncCli
	Local cCpoLog
	Local nX

	If ! Empty(cCgcCli) .And. Cgc(AllTrim(cCgcCli))
		cCgcCli:= AllTrim(cCgcCli)
		If Len(cCgcCli) == 11 // CPF
			cCodCli:= Left(cCgcCli, 9)
			cLojCli:= Right(cCgcCli, 2)
		Else // CNPJ
			cCodCli:= "0" + Left(cCgcCli, 8)
			cLojCli:= SubStr(cCgcCli, 9,4)
		EndIf

		SA1->(DbSetOrder(1))
		lIncCli:= ! SA1->(DbSeek(xFilial("SA1") + cCodCli + cLojCli))

		U_MILEDADO(@aDados, "A1_COD", cCodCli)
		U_MILEDADO(@aDados, "A1_LOJCLI", cLojCli)

		RegToMemory("SA1", lIncCli)

		SX3->(DbSetOrder(2))
		For nX:= 1 to Len(aDados)
			If SX3->(DbSeek(AllTrim(aDados[nX][1])))
				//Valida valor
			Else
				cLog:= "Campo não encontrado no SA1: " + AllTrim(aDados[nX][1])
				cDetalhe:= "Verifique o Layout de importação"
				lRet:= .F.
				Exit
			EndIf
		Next

	Else
		cLog:= "CGC Inválido no arquivo (" + cCgcCli + ")"
		cDetalhe:= "Verifique o CGC do cliente no arquivo"
		lRet:= .F.
	EndIf

Return ( lRet )
// FIM da Funcao MILIMCLI
//======================================================================================================================



