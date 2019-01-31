#Include 'Protheus.ch'
/*/{Protheus.doc} SX5Cadastro

Observacoes:   Função para manutenção da SX5.

Caso não informar a tabela na chamada da FUNÇÃO vai aparecer a opção de escolher...

@author	 	 :	Lucas Farias
@since		 :	13/06/2016
@version	 :  13/06/2016 - Lucas Farias

@return NULL

/*/
User Function SX5Cadastro(cTabela)
	Local   cPerg   := "SX5Cadastro"
	Default cTabela := ""

	If Pergunta(cPerg) .AND. Empty(cTabela)
		ShowTela(MV_PAR01)
	Else
		ShowTela(cTabela)
	EndIf
Return

Static Function ShowTela(cTabela)
	Local aCores      := {}
	Local cFiltra     := "X5_FILIAL == '" + xFilial("SX5") + "'" + Iif(Empty(cTabela),""," .AND. X5_TABELA == '" + cTabela + "' ")
	Local cAlias      := "SX5"
	Private aIndexSX5 := {}
	Private cCadastro := "Tabela Genérica - SX5"
	Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSX5,@cFiltra) }
	Private aRotina   := {}

	AADD(aRotina, { "Pesquisar"  , "AxPesqui" , 0, 1 })
	AADD(aRotina, { "Visualizar" , "AxVisual" , 0, 2 })
	AADD(aRotina, { "Incluir"    , "AxInclui" , 0, 3 })
	AADD(aRotina, { "Alterar"    , "AxAltera" , 0, 4 })
	AADD(aRotina, { "Excluir"    , "AxDeleta" , 0, 5 })

	Eval(bFiltraBrw)
	dbSelectArea(cAlias)
	dbGoTop()
	mBrowse(6,1,22,75,cAlias)
	EndFilBrw(cAlias,aIndexSX5)
Return

Static Function Pergunta(cPerg)
	Local   aPergs := {}
	Default cPerg  := FunName()

	AADD(aPergs,{1,"Tabela",CRIAVAR("X5_TABELA"),"@!",'.T.',,'.T.',30,.F.})//MV_PAR01

Return ParamBox(aPergs,"Parâmetros",{},,,,,,,cPerg,.T.,.T.)
