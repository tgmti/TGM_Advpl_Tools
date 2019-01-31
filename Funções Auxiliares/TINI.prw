#Include 'Protheus.ch'


//====================================================================================================================\\
/*/{Protheus.doc}TINI
  ====================================================================================================================
	@description
	Função auxiliar para inicializadores padrão.

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		23 de set de 2016

	@param		cCpoDes, Caracatere,	Campo que será inicializado
	@param		cChave	, Caracatere,	Chave de pesquisa
	@param		cCpoRet, Caracatere,	Campo a retornar
	@param		xPadrao, Caracatere,	Valor padrão no caso de inclusão - Padrão: campo em branco conforme tipo.
	@param		lPadrao, Lógico, 		Retorna o valor padrão. Utilizado em inicializador de Browse e operações de inclusão- Padrão: variável INCLUI, disponível como private nas telas padrão.
	@param		xIndice, Indefinido,	Índice (se numérico) ou Nickname (se caractere ) - Padrão: Índice 1
	@param		lAddFil, Lógico,		Indica se deve adicionar xFilial à cChave - Padrão: .T.
	@param		cTabela, Caracatere,	Alias da tabela (se não for informado, será buscado o Alias do cCpoRet no SX3)

	@obs
	Função criada para poder executar inicializadores padrão passando menos dados.
	O obetivo é ter um inicializador padrão facilmente nos campos virtuais.
retor
	Utiliza a função auxilizar U_TPOS para buscar os dados via posicione.

	@example	U_TINI("C5_ZNOMCLI", SC5->(A1_CLIENTE+M->A1_LOJA), "A1_NOME") // Inicializador padrão
				// Retorna o mesmo que:
				IF( INCLUI, SPACE(30), POSICIONE("SA1", 1, SC5->(A1_CLIENTE+M->A1_LOJA), "A1_NOME") )

	@example	U_TINI("C5_ZNOMCLI", SC5->(A1_CLIENTE+M->A1_LOJA), "A1_NOME", .F.) // Inicializador de Browse

/*/
//===================================================================================================================\\
User Function TINI(cCpoDes, cChave, cCpoRet, xPadrao, lInclui, xIndice, lAddFil, cTabela)

	Local xRet:= Nil
	Local nPos

	Static aPadrao:= {}

	Default lInclui:= INCLUI

	// Se não foi determinado um padrão, busca pelo
	If lInclui .And. xPadrao == Nil

		If ( nPos:= aScan(aPadrao, {|x| x[1] == cCpoDes }) ) > 0
			xPadrao:= aPadrao[nPos][3]
		Else
			aBkpSx3:= SX3->( GetArea() )

			SX3->( DbSetOrder( 2 ) )
			If SX3->( MsSeek( cCpoDes ) )
				Do Case
				Case (SX3->X3_TIPO == "C")
					xPadrao:= Space(SX3->X3_TAMANHO)
				Case (SX3->X3_TIPO == "M")
					xPadrao:= Space(500)
				Case (SX3->X3_TIPO == "N")
					xPadrao:= 0
				Case (SX3->X3_TIPO == "D")
					xPadrao:= cTod("  /  /    ")
				Case (SX3->X3_TIPO == "L")
					xPadrao:= .F.
				EndCase

				aAdd(aPadrao, {cCpoDes, SX3->X3_TIPO, xPadrao})
			EndIf

			SX3->(RestArea(aBkpSx3))
		EndIf
	EndIf

	xRet:= Iif( lInclui, xPadrao, U_TPOS(cChave, cCpoRet, xIndice, lAddFil, cTabela) )

	If xRet == Nil .And. xPadrao != Nil
		xRet:= xPadrao
	EndIf

Return ( xRet )
// FIM da Funcao TINI
//======================================================================================================================



