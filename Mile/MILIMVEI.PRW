#INCLUDE "PROTHEUS.CH"



//====================================================================================================================\
/*/{Protheus.doc}MILIMVEI
  ====================================================================================================================
	@description
	Importação de cadastro de Veículos via Mile

	@author TSC681 Thiago Mota
	@version 1.0
	@since 02/07/2018

	@obs
	Recebe os dados tratado da rotina MileImp e tenta cadastrar na SA1 usando o ExecAuto do MATA030

/*/
//===================================================================================================================\
User Function MILIMVEI( lInterface, aDados )

	Local lRet:= .T.
	Local cPlaca:= U_MILEDADO(aDados, "DA3_COD")
	Local oDadosVei
	Local cCodMarca
	Local cDesModel
	Local cObsLog:= ""
	Local cChassi
	Local cChassiCon
	Local lInclui

	Private lMsErroAuto		:= .F.
	Private lMsHelpAuto		:= .F.
	Private lAutoErrNoFile	:= .T.

	If ! Empty(cPlaca)

		If ( oDadosVei:= ConsPlaca(cPlaca) )
			If "SEM ERROS" $ Upper(oDadosVei:return_message)

				If ! ("SEM RESTRI" $ Upper(oDadosVei:status_message))
					cObsLog+= CRLF + "Retorno Sinesp: " + AllTrim(oDadosVei:status_message)
				EndIf

				U_MILEDADO(@aDados, "DA3_MUNPLA", oDadosVei:City)
				U_MILEDADO(@aDados, "DA3_ESTPLA", oDadosVei:State)

				GetMarcModel(oDadosVei:brand, @cCodMarca, @cDesModel)
				If ! Empty(cCodMarca)
					U_MILEDADO(@aDados, "DA3_MARVEI", cCodMarca)
				Else
					cObsLog+= CRLF + "Marca não encontrada no cadastro (SX5 -> M6): " + AllTrim(oDadosVei:brand)
				EndIf
				If ! Empty(cDesModel)
					U_MILEDADO(@aDados, "DA3_DESC", cDesModel) //TODO: Ajustar para preencher o campo customizado
				Else
					cObsLog+= CRLF + "Modelo não encontrado no Sinesp: " + AllTrim(oDadosVei:brand)
				EndIf

				U_MILEDADO(@aDados, "DA3_ANOMOD", oDadosVei:year)
				U_MILEDADO(@aDados, "DA3_ANOFAB", oDadosVei:model_year)


				// ============================================
				// Valida o Chassi com o retorno do Sinesp
				// ============================================
				cChassi:= U_MILEDADO(@aDados, "DA3_CHASSI")
				cChassiCon:= StrTran(AllTrim(oDadosVei:chassis), "*")

				If ! Empty(cChassi) .And. ! Empty(cChassiCon)
					If Right(AllTrim(cChassi), Len(cChassiCon)) <> cChassiCon
						U_MILEDADO(@aDados, "DA3_CHASSI", "")
						cObsLog+= CRLF + "Chassi do Logix não confere com o retorno do Sinesp: "
						cObsLog+= CRLF + "  - Logix: " + cChassi
						cObsLog+= CRLF + "  - Últimos números no Sinesp: " + cChassiCon
					EndIf
				EndIf
				// ============================================


				// ============================================
				// Alimenta o campo de log
				// ============================================
				If ! Empty(cObsLog)
					cObsLog:= "Erros encontrados na importação do Logix: " + cObsLog
					U_MILEDADO(@aDados, "DA3_ZLGIMP", cObsLog)
				EndIf


			Else
				cLog:= "Erro ao consultar placa no Sinesp: " + oDadosVei:return_message
				cDetalhe:= cLog
				return .F.
			EndIf
		EndIf


		DA3->(DbSetOrder(1)) // DA3_FILIAL+DA3_COD
		lInclui:= ! DA3->(DbSeek(xFilial("DA3") + cCodCli + cLojCli))

		MsExecAuto( {|x,y,z| OMSA060(x, y) }, aDados, If(lInclui, 3, 4) )

		//Verifica se ouve algum erro
		If lMsErroAuto
			cLog:= "Erro ao cadastrar/alterar o veículo " + cPlaca + ": " + CRLF
			aEval(GetAutoGrLog(), {|x| cDetalhe+= x + CRLF })
			lRet:= .F.
		EndIf


	Else
		cLog:= "Placa do veículo inválida"
		cDetalhe:= "Placa do veículo inválida"
		lRet:= .F.
	EndIf

Return ( lRet )
// FIM da Funcao MILIMVEI
//======================================================================================================================



//====================================================================================================================\
/*/{Protheus.doc}ConVeiSine
  ====================================================================================================================
	@description
	Consulta veículo no Sinesp

	@author TSC681 Thiago Mota
	@version 1.0
	@since 03/07/2018

/*/
//===================================================================================================================\
Static Function ConVeiSine( cPlaca )

	Local cComando:= "python C:\Temp\Cootravale\ConsPlaca\consulta.py "
	Local cArqPlaca:= "c:\Temp\placas\" + cPlaca + ".json"
	Local cErro
	Local oJson

	WaitRun(cComando + cPlaca, 1 )

	If File(cArqPlaca)
		cRetorno:= Memoread(cArqPlaca)
		conout(cRetorno)

		If ! Empty(cRetorno) .And. FWJsonDeserialize(cRetorno,@oJSon)
			Return (oJson)
		EndIf

	EndIf

Return ( Nil )
// FIM da Funcao ConVeiSine
//======================================================================================================================



//====================================================================================================================\
/*/{Protheus.doc}GetMarcModel
  ====================================================================================================================
	@description
	Retorna a marca e o modelo a partir do resultado da consulta Sinesp

	@author TSC681 Thiago Mota
	@version 1.0
	@since 04/07/2018

/*/
//===================================================================================================================\
Static Function GetMarcModel( cConsulta, cCodMarca, cDesModel )
	
	Local cMarca

	If ! Empty(cConsulta)
		cConsulta:= AllTrim(cConsulta)
		cMarca:= Left(cConsulta, At("/")-1)
		cDesModel:= Upper(AllTrim(Substr(cConsulta, At("/")+1)))
		SX5->(DbSetOrder(1))
		SX5->(DbSeek(xFilial("SX5")+"M6"))
		While SX5->(!Eof()) .And. SX5->X5_TABELA == "M6"
			If Upper(AllTrim(cMarca)) $ Upper(AllTrim(SX5->X5_DESCRI)) ;
			.Or. Upper(AllTrim(SX5->X5_DESCRI)) $ Upper(AllTrim(cMarca))
				cCodMarca:= SX5->X5_CHAVE
				Exit
			EndIf
			SX5->(DbSkip())
		EndDo
	EndIf

Return ( Nil )
// FIM da Funcao GetMarcModel
//======================================================================================================================



