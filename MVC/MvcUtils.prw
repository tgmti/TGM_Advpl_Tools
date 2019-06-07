#INCLUDE 'PROTHEUS.CH'
#Include 'FWMVCDef.ch'


//============================================================================\
/*/{Protheus.doc}FwGrdSum
  ==============================================================================
	@description
	Totaliza os dados de uma coluna no FWFormGridModel

	@author Thiago Mota <mota.thiago@totvs.com.br>
    @author mota.thiago@totvs.com.br
    @author https://github.com/tgmti/

	@version 1.0
	@since 28/05/2019

/*/
//============================================================================\
User Function FwGrdSum( cIdGrid, cIdField, lDeleted, bFilter )
Return FwGrdSum( cIdGrid, cIdField, lDeleted, bFilter )

Static Function FwGrdSum( cIdGrid, cIdField, lDeleted, bFilter )
Return ( U_aReduce( U_aMap( FwDatArr(cIdGrid, lDeleted, bFilter), {|x| x[ FwFldPos(cIdGrid, cIdField) ] } ) ) )
// FIM da Funcao FwGrdSum
//==============================================================================



//====================================================================================================================\
/*/{Protheus.doc}FwFldPos
  ====================================================================================================================
	@description
	Retorna a posição de um campo num FWFormGridModel

	@author Thiago Mota <mota.thiago@totvs.com.br>
    @author mota.thiago@totvs.com.br
    @author https://github.com/tgmti/

	@version 1.0
	@since 28/05/2019

/*/
//===================================================================================================================\
User Function FwFldPos( xModelGrid, cIdField )
Return FwFldPos( xModelGrid, cIdField )

Static Function FwFldPos( xModelGrid, cIdField )
	Local oModelGrid:= CheckModel(xModelGrid)

Return ( aScan(oModelGrid:GetStruct():aFields, {|x| x[MODEL_FIELD_IDFIELD] == cIdField} ) )
// FIM da Funcao FwFldPos
//======================================================================================================================



//====================================================================================================================\
/*/{Protheus.doc}FwDatArr
  ====================================================================================================================
	@description
	Retorna o Array com os dados de um FWFormGridModel

	@author Thiago Mota <mota.thiago@totvs.com.br>
    @author mota.thiago@totvs.com.br
    @author https://github.com/tgmti/

	@version 1.0
	@since 28/05/2019

/*/
//===================================================================================================================\
User Function FwDatArr( xModelGrid, lDeleted, bFilter )
Return FwDatArr( xModelGrid, lDeleted, bFilter )

Static Function FwDatArr( xModelGrid, lDeleted, bFilter )
	Local oModelGrid:= CheckModel(xModelGrid)
	Local aData
	Default lDeleted:= .F.

	aData:= iif( lDeleted, oModelGrid:GetData(), U_aFilter(oModelGrid:GetData(), {|x| ! x[MODEL_GRID_DELETE] }) )
	aData:= U_aMap( aData, {|x,y| x[MODEL_GRID_DATA][MODEL_GRIDLINE_VALUE] } )

	If bFilter != Nil
		aData:= U_aFilter( aData, bFilter )
	EndIf

Return ( aData )
// FIM da Funcao FwDatArr
//======================================================================================================================



//============================================================================\
/*/{Protheus.doc}FwSynGrd
  ==============================================================================
	@description
	Axilia a sincronização de dados da grid que não estão na chave em telas Mod2

	@author Thiago Mota <mota.thiago@totvs.com.br>
	@version 1.0
	@since 07/06/2019

	@obs
	Esta função pode ajudar a sincronizar os dados que não estejam no
	relacionamento em telas MVC Modelo 2 (mestre e detalhe na mesma tabela, como
	o pedido de compras ou a SX5)

	Porém, se algum campo sofre alteração no objeto pai, a função ExFormCommit
	só atualiza as linhas da grid que sofreram alguma alteração.

	Adicionando este tratamento no TudoOk do Objeto pai, todas as linhas da grid
	filha passam pelo trecho que Efetua a gravacao do modelo 2.

	Somente os campos que sofreram alteração no Objeto pai serão replicados no
	filho.

/*/
//============================================================================\
Static Function FwSynGrd( xModelGrid, cIdField )
Return FwSynGrd( xModelGrid, cIdField )

Static Function FwSynGrd( xModelGrid, cIdField )
	Local oModelGrid:= CheckModel(xModelGrid)
	Local nPosAtu:= If( ! Empty(cIdField), FwFldPos( ModelGrid, cIdField ), 1 )
	aEval( oModelGrid, {|x| x[MODEL_GRID_DATA][MODEL_GRIDLINE_UPDATE][1]:= .T. } )
Return ( Nil )
// FIM da Funcao FwSynGrd
//==============================================================================



//============================================================================\
//	STATIC FUNCTIONS
//============================================================================\



//============================================================================\
/*/{Protheus.doc}CheckModel
  ==============================================================================
	@description
	Verifica se foi passado o Objeto do Model ou o ID, no segundo caso, busca o
	Model Ativo.

	@author Thiago Mota <mota.thiago@totvs.com.br>
	@version 1.0
	@since 07/06/2019

/*/
//============================================================================\
Static Function CheckModel( xModelId )
	Local oModel, oModelRet

	If ValType(xModelId) == 'O'
		oModelRet:= xModelId
	Else
		oModel:= FWModelActive()
		oModelRet:= oModel:GetModel(xModelId)
	EndIf

Return ( oModelRet )
// FIM da Funcao CheckModel
//==============================================================================



