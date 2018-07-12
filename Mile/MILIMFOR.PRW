#INCLUDE "PROTHEUS.CH"



//====================================================================================================================\
/*/{Protheus.doc}MILIMFOR
  ====================================================================================================================
	@description
	Importação de cadastro de Fornecedores via Mile

	@author TSC681 Thiago Mota
	@version 1.0
	@since 02/07/2018

	@obs
	Recebe os dados tratado da rotina MileImp e tenta cadastrar na SA2 usando o ExecAuto do MATA030

/*/
//===================================================================================================================\
User Function MILIMFOR( lInterface, aDados )

	Local lRet:= .F.
	Local cCgcCli:= U_MILEDADO(aDados, "A2_CGC")
	Local cCodCli
	Local cLojCli
	Local lIncCli
	Local cCpoLog
	Local nX

	Private lMsErroAuto		:= .F.
	Private lMsHelpAuto		:= .F.
	Private lAutoErrNoFile	:= .T.

	If ! Empty(cCgcCli) .And. Cgc(AllTrim(cCgcCli),,.F.)
		cCgcCli:= AllTrim(cCgcCli)
		If Len(cCgcCli) == 11 // CPF
			cCodCli:= Left(cCgcCli, 9)
			cLojCli:= Right(cCgcCli, 2)
		Else // CNPJ
			cCodCli:= "0" + Left(cCgcCli, 8)
			cLojCli:= SubStr(cCgcCli, 9,4)
		EndIf

		SA2->(DbSetOrder(1))
		lIncCli:= ! SA2->(DbSeek(xFilial("SA2") + cCodCli + cLojCli))

		U_MILEDADO(@aDados, "A2_COD", cCodCli)
		U_MILEDADO(@aDados, "A2_LOJA", cLojCli)

		aDados:= FWVetByDic( aDados, "SA2", /*lItens*/, /*nCpoPos*/ )
		MsExecAuto( {|x,y| MATA020(x,y) }, aDados, If(lIncCli, 3, 4) )

		//Verifica se ouve algum erro
		If lMsErroAuto
			cLog:= "Erro ao cadastrar/alterar o Fornecedor " + cCodCli + "-" + cLojCli + ": " + CRLF
			aEval(GetAutoGrLog(), {|x| cDetalhe+= x + CRLF })
			lRet:= .F.
		EndIf


	Else
		cLog:= "CGC Inválido no arquivo (" + AllToChar(cCgcCli) + ")"
		cDetalhe:= "Verifique o CGC do Fornecedor no arquivo"
		lRet:= .F.
	EndIf

Return ( lRet )
// FIM da Funcao MILIMFOR
//======================================================================================================================



