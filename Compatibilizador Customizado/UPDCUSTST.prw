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

	Local oCompat:= UPDCUSTOM():New()
	Local aCpo1:= {}
	
	
	aAdd(aCpo1, {"X3_ARQUIVO", "SC5"} )
	aAdd(aCpo1, {"X3_CAMPO", "C5_ZTST001"} )
	aAdd(aCpo1, {"X3_TIPO", "C"} )
	aAdd(aCpo1, {"X3_TAMANHO", 1} )
	aAdd(aCpo1, {"X3_TITULO", "Tst compat"} )
	aAdd(aCpo1, {"X3_DESCRIC", "Teste compatibilizador"} )
	aAdd(aCpo1, {"X3_PROPRI", "U"} )
	aAdd(aCpo1, {"X3_VISUAL", "A"} )
	aAdd(aCpo1, {"X3_CONTEXT", "R"} )
	aAdd(aCpo1, {"X3_PYME", "S"} )

	// Teste de adição de campo
	oCompat:AddProperty("SX2", aCpo1)
	oCompat:RunUpdate()

Return