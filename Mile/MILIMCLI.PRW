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

	Private lMsErroAuto		:= .F.
	Private lMsHelpAuto		:= .F.
	Private lAutoErrNoFile	:= .T.

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

		MATA030(aDados,If(lIncCli, 3, 4))

		//Verifica se ouve algum erro
		If lMsErroAuto
			cLog:= "Erro ao cadastrar/alterar o cliente " + cCodCli + "-" + cLojCli + ": " + CRLF
			aEval(GetAutoGrLog(), {|x| cDetalhe+= x + CRLF })
			lRet:= .F.
		EndIf


	Else
		cLog:= "CGC Inválido no arquivo (" + cCgcCli + ")"
		cDetalhe:= "Verifique o CGC do cliente no arquivo"
		lRet:= .F.
	EndIf

Return ( lRet )
// FIM da Funcao MILIMCLI
//======================================================================================================================



