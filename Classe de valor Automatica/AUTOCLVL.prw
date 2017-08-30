#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}AUTOCLVL
  ====================================================================================================================
	@description
	Cadastrar/Atualizar Classes de valor conforme cadastro de cliente ou fornecedor

	@author	TSC681 - Thiago Mota
	@version	1.0
	@since		23/06/2014

	@param		cPrefixo, caractere, C Para cliente, F Para Fornecedor
	@param		cCodigo, caractere, Código do cliente ou fornecedor
	@param		cLoja	, caractere, Loja do cliente ou fornecedor

	@obs
	Utilizada em conjunto com os pontos de entrada M020ALT, M020INC, M030INC, MALTCLI

	@sample	U_AUTOCLVL(cPrefixo, cCodigo, cLoja)

/*/
//====================================================================================================================\\

User Function AUTOCLVL(cPrefixo, cCodigo, cLoja)

	Local aAreaBkp	:= {}
	Local cAliasCad
	Local cMsgRet
	Local cPref
	Local cCodClasse
	Local dIniExist

	Default cPrefixo := "C"

	//TODO: Ajustar  estas configurações de acordo com o cliente
	cCodClasse	:= cPrefixo + cCodigo + cLoja  // [C ou F] + [Código + Loja] do cliente ou fornecedor
	dIniExist	:= cToD("01/01/1990") // Data Inicio Existencia

	// Backup das áreas atuais
	aEval({"SA1","SA2", "CTH"}, { |area| aAdd(aAreaBkp, (area)->(GetArea()) ) } )
	aAdd(aAreaBkp, GetArea())

	If cPrefixo == "C"
		cAliasCad:= "SA1"
		cPref	 := "A1_"
	Else
		cAliasCad:= "SA2"
		cPref	 := "A2_"
	EndIf

	DbSelectArea( cAliasCad )
	DbSetOrder(1)
	If DbSeek( xFilial( cAliasCad ) + cCodigo + cLoja )
		DbSelectArea("CTH")
		DbSetOrder(1)
		If DbSeek( xFilial("CTH") + cCodClasse )
			// Classe de valor já cadastrada
			RecLock("CTH",.F.)
			CTH->CTH_DESC01:= (cAliasCad)->&( cPref + "NOME" )
			CTH->( MsUnLock() )
		Else
			// Cadastra nova classe de valor
			RecLock("CTH",.T.)
			CTH->CTH_FILIAL		:= xFilial("CTH")
			CTH->CTH_CLASSE		:= "2" // Analítico
			CTH->CTH_NORMAL		:= "0" //
			CTH->CTH_CLVL			:= cCodClasse
			CTH->CTH_DESC01		:= (cAliasCad)->&( cPref + "NOME" )
			CTH->CTH_BLOQ			:= "2" //
			CTH->CTH_DTEXIS		:= dIniExist
			CTH->CTH_CLVLLP		:= CTH->CTH_CLVL // Classe de lucro/perda

			CTH->( MsUnLock() )
		EndIf
	Else
		cMsgRet:= "Cliente/Fornecedor não encontrado."
	EndIf

	aEval(aAreaBkp, {|area| RestArea(area)}) // Restaura as áreas anteriores

Return

// FIM da Funcao AUTOCLVL
//====================================================================================================================\\

