#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEditPanel.CH"


//====================================================================================================================\\
/*/{Protheus.doc}ACTCNSEA
  ====================================================================================================================
	@description
	Consulta dos borderôs na SEA

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		1 de nov de 2016

/*/
//===================================================================================================================\\
User Function ACTCNSEA()

	Private oDlgPrinc
	Private aRotina		:= MenuDef()

	oDlgPrinc:= FWMBrowse():New()
	oDlgPrinc:SetAlias('SEA')
	oDlgPrinc:SetDescription('Consulta Borderos')
	oDlgPrinc:cFilterDefault:= "UniqueKey( {'EA_FILIAL','EA_CART', 'EA_PORTADO', 'EA_AGEDEP', 'EA_NUMCON', 'EA_SUBCTA', 'EA_NUMBOR'} , 'SEA', , )"

	// Legenda
	oDlgPrinc:AddLegend( "EA_TRANSF=='S'", "GREEN"	, "Enviado"	)
	oDlgPrinc:AddLegend( "EA_TRANSF!='S'", "RED"		, "Não Enviado"	)

	oDlgPrinc:Activate()

Return ( Nil )
// FIM da Funcao ACTCNSEA
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}ModelDef
  ====================================================================================================================
	@description
	Definição do modelo de dados

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		1 de nov de 2016

/*/
//===================================================================================================================\\
Static Function ModelDef()

	Local oModel
	Local oStrMaster:= FWFormStruct( 1, 'SEA' , { |x| SfStruct(x, .T.) }, /*lViewUsado*/.T. )
	Local oStrDetail:= FWFormStruct( 1, 'SEA' , { |x| SfStruct(x, .F.) }, /*lViewUsado*/.T. )

	oModel := MPFormModel():New('ACTSEA_MVC', /*bPreValidacao*/, /*bPosValid*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona Enchoice e Grid
	oModel:AddFields( 'SEAMASTER', /*cOwner*/, oStrMaster )
	oModel:AddGrid( 'SEADETAIL', 'SEAMASTER', oStrDetail, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	// Faz relaciomaneto entre os compomentes do model
	aRelation:= {}
	aAdd(aRelation, { 'EA_FILIAL', 'EA_FILIAL' })
	aAdd(aRelation, { 'EA_CART'		, 'EA_CART' })
	aAdd(aRelation, { 'EA_PORTADO', 'EA_PORTADO' })
	aAdd(aRelation, { 'EA_AGEDEP', 'EA_AGEDEP' })
	aAdd(aRelation, { 'EA_NUMCON', 'EA_NUMCON' })
	aAdd(aRelation, { 'EA_SUBCTA', 'EA_SUBCTA' })
	aAdd(aRelation, { 'EA_NUMBOR', 'EA_NUMBOR' })

	oModel:SetRelation( 'SEADETAIL', aRelation , SEA->( IndexKey( 1 ) ) )

	// Liga o controle de nao repeticao de linha
	//oModel:GetModel( 'SEADETAIL' ):SetUniqueLine( { 'EA_FILIAL', 'EA_NUMBOR', 'EA_PREFIXO', 'EA_NUM', 'EA_PARCELA', 'EA_TIPO', 'EA_FORNECE', 'EA_LOJA' } )

	// Não gravar dados no banco
	//oModel:GetModel( 'SEAMASTER' ):SetOnlyQuery( .T. )
	//oModel:GetModel( 'SEADETAIL' ):SetOnlyQuery( .T. )

	oModel:SetPrimaryKey( {'EA_FILIAL','EA_CART', 'EA_PORTADO', 'EA_AGEDEP', 'EA_NUMCON', 'EA_SUBCTA', 'EA_NUMBOR'} )
	oModel:bVldActivate:= {|| .T.}

Return ( oModel )
// FIM da Funcao ModelDef
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}ViewDef
  ====================================================================================================================
	@description
	Definição da view

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		1 de nov de 2016

/*/
//===================================================================================================================\\
Static Function ViewDef()

	Local oView
	Local oModel
	Local oStrMaster:= FWFormStruct( 2, 'SEA' , { |x| SfStruct(x, .T.) }, /*lViewUsado*/.T. )
	Local oStrDetail:= FWFormStruct( 2, 'SEA' , { |x| SfStruct(x, .F.) }, /*lViewUsado*/.T. )

	oView := FWFormView():New()
	oModel	:= ModelDef()
	oView:SetModel( oModel )

	// Adiciona os componentes da View
	oView:AddField( 'VIEW_MASTER', oStrMaster, 'SEAMASTER' )
	oView:AddGrid( 'VIEW_DETAIL', oStrDetail, 'SEADETAIL' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'BOX_MASTER', 25 )
	oView:CreateHorizontalBox( 'BOX_DETAIL', 75 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_MASTER', 'BOX_MASTER' )
	oView:SetOwnerView( 'VIEW_DETAIL', 'BOX_DETAIL' )

	//nAltLinGrid:= 15
	//oView:SetViewProperty("*", "GRIDROWHEIGHT", {nAltLinGrid})

Return ( oView )
// FIM da Funcao ViewDef
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}SfStruct
  ====================================================================================================================
	@description
	Filtra os campos da estrurura

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		1 de nov de 2016

/*/
//===================================================================================================================\\
Static aCposMaster
Static Function SfStruct(cCampo, lMaster)

	If Empty(aCposMaster)
		aCposMaster:= {}

		aAdd(aCposMaster, "EA_FILIAL")
		aAdd(aCposMaster, "EA_PORTADO")
		aAdd(aCposMaster, "EA_AGEDEP")
		aAdd(aCposMaster, "EA_NUMCON")
		aAdd(aCposMaster, "EA_SUBCTA")

		aAdd(aCposMaster, "EA_CART")
		aAdd(aCposMaster, "EA_NUMBOR")
		aAdd(aCposMaster, "EA_DATABOR")
		aAdd(aCposMaster, "EA_MODELO")
		aAdd(aCposMaster, "EA_TIPOPAG")
		aAdd(aCposMaster, "EA_TRANSF")
		aAdd(aCposMaster, "EA_SITUACA")

	EndIf

	lCampo:= aScan( aCposMaster, {|x| x == AllTrim(cCampo) }) > 0
	lCampo:= If(lMaster, lCampo, !lCampo)

Return ( lCampo )
// FIM da Funcao SfStruct
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
	@since		1 de nov de 2016

/*/
//===================================================================================================================\\
Static Function MenuDef()
	Local aRotina:= {}

	ADD OPTION aRotina TITLE 'Visualizar'	ACTION 'VIEWDEF.ACTCNSEA_MVC'	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda'		ACTION 'U_ACTLGSEA(oSelf)'	OPERATION 1 ACCESS 0 DISABLE MENU

Return ( aRotina )
// FIM da Funcao MenuDef
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}ACTLGSEA
  ====================================================================================================================
	@description
	Exibir a Legenda da Tela

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		29 de jul de 2016

/*/
//===================================================================================================================\\
User Function ACTLGSEA(oBrowse)
	oBrowse:aLegends[1][2]:View()
Return(Nil)
// FIM da Funcao ACTLGSEA
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}ACTUPSEA
  ====================================================================================================================
	@description
	Update para utilizar a tela de consulta do Borderô

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		1 de nov de 2016

/*/
//===================================================================================================================\\
User Function ACTUPSEA()

	Local cBrowse
	Local cOrdBrw:= "01"
	Local cOrdTit
	Local cOrdem

	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek( "SEA" )

	SfStruct("", .T.) // Só para criar o aCposMaster
	cOrdTit:= StrZero(Len(aCposMaster) + 2, 2)

	While ! Eof() .And. X3_ARQUIVO == "SEA"

		If X3_CAMPO != "EA_FILIAL"

			If SfStruct(X3_CAMPO, .T.)
				cBrowse:= "S"
				cOrdBrw:= Soma1(cOrdBrw)
				cOrdem:= cOrdBrw
			Else
				cBrowse:= "N"
				cOrdTit:= Soma1(cOrdTit)
				cOrdem:= cOrdTit
			EndIf

			RecLock("SX3", .F.)
			X3_ORDEM := cOrdem
			X3_BROWSE:= cBrowse
			MsUnlock()

		EndIf

		dbSkip()
	End

	MsgInfo("Update dos campos concluída","Update de campos na SEA")
	ViewDef()
Return ( Nil )
// FIM da Funcao ACTUPSEA
//======================================================================================================================