#INCLUDE 'TOTVS.ch'
#INCLUDE "Protheus.ch"

//====================================================================================================================\\
/*/{Protheus.doc}UPDCUSTST
  ====================================================================================================================
	@description
	Rotina para teste do compatibilizador customizado

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		01/12/2016

/*/
//====================================================================================================================\\
User Function UPDCUSTST

	Local oCompat:= UPDCUSTOM():New("Teste de Compatibilizador")
	Local aCpo1:= {}
	
	aAdd(aCpo1, {"X3_CAMPO", "C5_ZTST001"} )
	aAdd(aCpo1, {"X3_ORDEM", "5"} )
	aAdd(aCpo1, {"X3_TIPO", "C"} )
	aAdd(aCpo1, {"X3_TAMANHO", 3} )
	aAdd(aCpo1, {"X3_TITULO", "Tst compat"} )
	aAdd(aCpo1, {"X3_DESCRIC", "Teste compatibilizador"} )

	// Teste de adição de campo
	oCompat:AddProperty("SX3", aCpo1)
	oCompat:RunUpdate(.T.)

	RpcSetEnv( "99", "01" )
	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("C5_ZTST001")
		ConOut("Campo C5_ZTST001 criado no SX3.")

		DbSelectArea("SC5")
		If FieldPos("C5_ZTST001") > 0
			ConOut("Campo C5_ZTST001 criado no banco de dados.")
		Else
			ConOut("Campo C5_ZTST001 NÃO criado no banco de dados!!!")
		EndIf

	Else
		ConOut("Campo C5_ZTST001 NÃO criado no SX3!!!!")
	EndIf



Return