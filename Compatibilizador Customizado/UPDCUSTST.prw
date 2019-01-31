#INCLUDE 'TOTVS.ch'
#INCLUDE "Protheus.ch"

//====================================================================================================================\\
/*/{Protheus.doc}UPDCUSTST
  ====================================================================================================================
	@description
	Rotina para teste do compatibilizador customizado

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		01/12/2016

/*/
//====================================================================================================================\\
User Function UPDCUSTST

	Local oCompat:= UPDCUSTOM():New("Teste de Compatibilizador")
	Local aCpo1:= {}
	Local aCpo2:= {}
	Local aPar1:= {}
	Local aTabGen:= {}

	// TESTE DE CAMPOS
	aAdd(aCpo1, {"X3_CAMPO", "C5_ZTST001"} )
	aAdd(aCpo1, {"X3_ORDEM", "13"} )
	aAdd(aCpo1, {"X3_TAMANHO", 2} )

	aAdd(aCpo2, {"X3_CAMPO", "C5_ZTST002"} )
	aAdd(aCpo2, {"X3_ORDEM", "128"} )
	aAdd(aCpo2, {"X3_TIPO", "C"} )
	aAdd(aCpo2, {"X3_TAMANHO", 2} )
	aAdd(aCpo2, {"X3_TITULO", "Tst.Comp.2"} )
	aAdd(aCpo2, {"X3_DESCRIC", "Teste compatibilizador 2"} )

	// Adiciona propriedades
	oCompat:AddProperty("SX3", aCpo1)
	oCompat:AddProperty("SX3", aCpo2)

	// TESTE DE CAMPOS - FIM

	// TESTE DE PARAMETROS
	aAdd(aPar1, {"X6_VAR", "MV_ZTSTCMP"})
	aAdd(aPar1, {"X6_DESCRIC", "Teste de Parametro inserido por compatibilizador customizado. " + Repl("-",50) + Repl("#",50)})
	aAdd(aPar1, {"X6_CONTEUD", "ABC"})

	oCompat:AddProperty("SX6", aPar1)
	// TESTE DE PARAMETROS - FIM

	// TESTE DE TABELA GENERICA
	aAdd(aTabGen, {})
	aAdd(aTail(aTabGen), {"X5_TABELA", "00"} )
	aAdd(aTail(aTabGen), {"X5_CHAVE", "ZA"} )
	aAdd(aTail(aTabGen), {"X5_DESCRI", "TABELA GENERICA - TESTE COMPATIBILIZADOR"} )

	aAdd(aTabGen, {})
	aAdd(aTail(aTabGen), {"X5_TABELA", "ZA"} )
	aAdd(aTail(aTabGen), {"X5_CHAVE", "001"} )
	aAdd(aTail(aTabGen), {"X5_DESCRI", "Teste Tabela generica 1"} )

	aAdd(aTabGen, {})
	aAdd(aTail(aTabGen), {"X5_TABELA", "ZA"} )
	aAdd(aTail(aTabGen), {"X5_CHAVE", "002"} )
	aAdd(aTail(aTabGen), {"X5_DESCRI", "Teste Tabela generica 2"} )


	// Adiciona Tabelas Genéricas no compatibilizador
	For nX:= 1 To Len(aTabGen)
		oCompat:AddProperty("SX5", aTabGen[nX])
	Next nX

	// TESTE DE TABELA GENERICA - FIM


	// Execução do compatibilizador
	oCompat:RunUpdate(.T.)


	// Validação dos dados adicionados
	//TODO: Implementar
/* 	RpcSetEnv( "99", "01" )
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
	EndIf */

Return