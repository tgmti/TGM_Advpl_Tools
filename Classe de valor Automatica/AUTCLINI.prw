#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}AUTCLINI
  ====================================================================================================================
	@description
	Sincroniza cadastro de clientes e fornecedores com cadastro de classes de valor

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		23/06/2014

	@sample	U_AUTCLINI()

/*/
//====================================================================================================================\\

User Function AUTCLINI()

	MsAguarde({|lEnd| AtuCad() },"Incluindo classes de Valor","Aguarde, incluindo classes de valor para todos os clientes e fornecedores",.F.)

Return

// FIM da Funcao AUTCLINI
//====================================================================================================================\\



//====================================================================================================================\\
/*/{Protheus.doc}AtuCad
  ====================================================================================================================
	@description
	Inclui nos cadastros de cliente e fornecedor

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		18 de jan de 2017

/*/
//===================================================================================================================\\
Static Function AtuCad()
	Local nQtCli:= 0
	Local nQtFor:= 0

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbGoTop()
	while ( SA1->(!Eof()) )
		U_AUTOCLVL( "C", SA1->A1_COD, SA1->A1_LOJA )
		nQtCli++
		SA1->(dbSkip())
	End

	DbSelectArea("SA2")
	DbSetOrder(1)
	DbGoTop()
	while ( SA2->(!Eof()) )
		U_AUTOCLVL( "F", SA2->A2_COD, SA2->A2_LOJA )
		nQtFor++
		SA2->(dbSkip())
	End

	MsgInfo("Sincronização terminada" + CRLF + ;
			cValToChar(nQtCli) + " clientes sincronizados" + CRLF + ;
			cValToChar(nQtFor) + " fornecedores sincronizados" )

Return ( Nil )
// FIM da Funcao AtuCad
//======================================================================================================================
