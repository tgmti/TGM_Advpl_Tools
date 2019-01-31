#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEditPanel.CH"


//====================================================================================================================\\
/*/{Protheus.doc}EDITASX5
  ====================================================================================================================
	@description
	Função para manipular tabelas Genéricas

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		30 de ago de 2017

/*/
//===================================================================================================================\\
User Function EDITASX5(cTabela, cTitulo)

	Private oDlgPrinc
	Private aRotina:= MenuDef()

	Private cTabSX5
	Private cCadastro

	If ! Empty(cTabela)
		cTabSX5:= cTabela
	Else
		If Empty( cTabSX5:= Pergunta() )
			Return ( Nil )
		EndIf
	EndIf

	If ! Empty(cTitulo)
		cCadastro:= cTitulo
	Else
		cCadastro:= Posicione("SX5",1,xFilial("SX5")+"00" + cTabSX5,"X5_DESCRI",/*cNickName*/)
	EndIf


	oDlgPrinc:= FWMBrowse():New()
	oDlgPrinc:SetAlias('SX5')
	oDlgPrinc:SetDescription(cCadastro)
	oDlgPrinc:cFilterDefault:= "X5_FILIAL='" + xFilial("SX5") + "' .AND. X5_TABELA=='" + cTabSX5 + "'"

	oDlgPrinc:Activate()


Return ( Nil )
// FIM da Funcao EDITASX5
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}ModelDef
  ====================================================================================================================
	@description
	Definição do Modelo de Dados

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		25 de ago de 2016

/*/
//===================================================================================================================\\
Static Function ModelDef()

	Local oModel	:= MPFormModel():New( 'EDITA_SX5', /*bPreValidacao*/,  )
	Local oStruct	:= FWFormStruct( 1, 'SX5', ,/*lViewUsado*/.T. )

	// Campos que não devem ser atualizados
	oStruct:SetProperty("X5_TABELA"	, MODEL_FIELD_NOUPD, .T.)

	// Adiciona a tabela ao Modelo
	oModel:AddFields( 'TABELA', /*cOwner*/, oStruct )

	oModel:GetModel( 'TABELA' ):SetDescription(cCadastro)
	oModel:SetPrimaryKey( {"X5_FILIAL", "X5_TABELA", "X5_CHAVE"} )

Return ( oModel )
// FIM da Funcao ModelDef
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}ViewDef
  ====================================================================================================================
	@description
	Definição do Modelo de Dados

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		28 de jul de 2016

/*/
//===================================================================================================================\\
Static Function ViewDef()

	Local oView	:= FWFormView():New()
	Local oModel	:= ModelDef()
	Local oStruct	:= FWFormStruct( 2, 'SX5', ,/*lViewUsado*/.T. )

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_TAB', oStruct, 'TABELA' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'BOX_TAB', 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_TAB', 'BOX_TAB' )

Return ( oView )
// FIM da Funcao ViewDef
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}Pergunta
  ====================================================================================================================
	@description
	Informa a tabela que deve ser editada

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		30 de ago de 2017

/*/
//===================================================================================================================\\
Static Function Pergunta()

	Local aPergs := {}
	Local cPerg  := FunName()
	Local cTabela

	AADD(aPergs,{1,"Tabela",CRIAVAR("X5_TABELA"),"@!",'.T.',"00",'.T.',30,.F.})//MV_PAR01

	SX5->( DbSetOrder( 1 ) )

	While .T.
		If ParamBox(aPergs,"Parâmetros",{},,,,,,,cPerg,.F.,.T.)
			If SX5->( DbSeek( xFilial("SX5") + MV_PAR01 ) )
				cTabela:= MV_PAR01
				Exit
			Else
				If ! MsgYesNo("Tabela " + MV_PAR01 + " não encontrada. Deseja selecionar outra?","Tabela não encontrada!")
					Exit
				EndIf
			EndIf
		EndIf
	EndDo

Return ( cTabela )
// FIM da Funcao Pergunta
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}MenuDef
  ====================================================================================================================
	@description
	Definição das rotinas do Menu

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		30 de ago de 2017

/*/
//===================================================================================================================\\
Static Function MenuDef()
	Local aRotina:= {}

	ADD OPTION aRotina TITLE 'Pesquisar'	ACTION 'VIEWDEF.EDITASX5_MVC'	OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.EDITASX5_MVC'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'		ACTION 'VIEWDEF.EDITASX5_MVC'	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'		ACTION 'VIEWDEF.EDITASX5_MVC'	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'		ACTION 'VIEWDEF.EDITASX5_MVC'	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'		ACTION 'VIEWDEF.EDITASX5_MVC'	OPERATION 6 ACCESS 0

Return ( aRotina )
// FIM da Funcao MenuDef
//======================================================================================================================



