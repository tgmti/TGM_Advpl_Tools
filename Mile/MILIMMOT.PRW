#INCLUDE "PROTHEUS.CH"



//====================================================================================================================\
/*/{Protheus.doc}MILIMMOT
  ====================================================================================================================
	@description
	Importação de cadastro de Motoristas via Mile

	@author TSC681 Thiago Mota
	@version 1.0
	@since 04/07/2018

	@obs
	Recebe os dados tratado da rotina MileImp e tenta cadastrar na DA4 usando o ExecAuto do OMSA040

/*/
//===================================================================================================================\
User Function MILIMMOT( lInterface, aDados )

	Local lRet:= .F.
	Local cCodMot //TODO: Definir como será gerado
	Local lIncCli
	Local cCpoLog
	Local nX

	Private lMsErroAuto		:= .F.
	Private lMsHelpAuto		:= .F.
	Private lAutoErrNoFile	:= .T.
	Private cObsLog			:= ""


	If .T.

		// ============================================
		// Validação de CNH
		// ============================================
		//TODO: Avaliar se vai precisar aqui, pois já tem na validação do campo
		cNumCNH:= U_MILEDADO(@aDados, "DA4_NUMCNH")

		If ! U_CNHValid( cNumCNH )
			U_MILEDADO(@aDados, "DA4_NUMCNH","")
			cObsLog+= "CNH Invalido - Dígito verificador da CNH inválido"
		EndIf


		// ============================================
		// Alimenta o campo de log
		// ============================================
		If ! Empty(cObsLog)
			cObsLog:= "Erros encontrados na importação do Logix: " + cObsLog
			U_MILEDADO(@aDados, "DA4_ZLGIMP", cObsLog)
		EndIf

		aDados:= FWVetByDic( aDados, "DA4", /*lItens*/, /*nCpoPos*/ )
		MsExecAuto( {|x,y| OMSA040(x,y) }, aDados, If(lIncCli, 3, 4) )

		//Verifica se ouve algum erro
		If lMsErroAuto
			cLog:= "Erro ao cadastrar/alterar o Motorista " + cCodMot + ": " + CRLF
			aEval(GetAutoGrLog(), {|x| cDetalhe+= x + CRLF })
			lRet:= .F.
		EndIf


	Else
		cLog:= "CGC Inválido no arquivo (" + AllToChar(cCgcCli) + ")"
		cDetalhe:= "Verifique o CGC do Fornecedor no arquivo"
		lRet:= .F.
	EndIf

Return ( lRet )
// FIM da Funcao MILIMMOT
//======================================================================================================================



