#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"


user function MAT010()

	local calias  := "SB1"
	local ctitulo := "Cadastro de Produtos - Teste"

	dbSelectArea(calias)
	dbSetOrder(1)
	//AxCadastro(cAlias, cTitulo,,)

	Private oDlgPrinc
	Private aRotina		:= MenuDef()

	oDlgPrinc:= FWMBrowse():New()
	oDlgPrinc:SetAlias(cAlias)
	oDlgPrinc:SetDescription(ctitulo)

	oDlgPrinc:Activate()

	if select(cAlias) > 0
		dbCloseArea(cAlias)
	endif
  
return

Static function MenuDef()
	Local aRotina:= {}
	
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.MAT010" OPERATION 5 ACCESS 0  //"Excluir"
	
return aRotina


static function modeldef()
	
	Local oStruct:= FWFormStruct(1,"SB1",)
	Local oModel:= MPFormModel():New("U_MAT010",/*Pre-Validacao*/,,,/*Cancel*/)
	
	oModel:AddFields("MASTER", /*cOwner*/, oStruct, /*Pre-Validacao*/,/*Pos-Validacao*/,/*Carga*/ )
	
	
Return oModel


static function viewdef()
	local oView:= FWFormView():New()
	Local oStruct:= FWFormStruct(2,"SB1",)

	oModel := FWLoadModel("MAT010")
	oView:SetModel(oModel)	

	oView:AddField( 'MASTER' , oStruct , 'MASTER')
	
	oView:CreateHorizontalBox("ALL",100)
	oView:SetOwnerView('MASTER',"ALL" )

Return oView
