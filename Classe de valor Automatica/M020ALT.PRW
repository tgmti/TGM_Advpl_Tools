#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}M020ALT
  ====================================================================================================================
	@description
	Ponto-de-Entrada: M020ALT - Executado na alteração do cadastro de fornecedores

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		23/06/2014

	@obs
	Automatizar o cadastro de classe de valor, baseado na alteração do fornecedor

/*/
//====================================================================================================================\\
User Function M020ALT()
	U_AUTOCLVL( "F", SA2->A2_COD, SA2->A2_LOJA ) // 23/06/2014 : Thiago Mota
Return
// FIM do Ponto de Entrada M020ALT
//====================================================================================================================\\