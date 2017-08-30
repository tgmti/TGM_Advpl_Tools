#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}MALTCLI
  ====================================================================================================================
	@description
	Ponto-de-Entrada: MALTCLI - Executado na alteração do cadastro de clientes

	@author	TSC681 - Thiago Mota
	@version	1.0
	@since		23/06/2014

	@obs
	Automatizar o cadastro de classe de valor, baseado na alteração do cliente

/*/
//====================================================================================================================\\
User Function MALTCLI()

	U_AUTOCLVL( "C", SA1->A1_COD, SA1->A1_LOJA )

Return

// FIM do Ponto de Entrada MALTCLI
//====================================================================================================================\\
