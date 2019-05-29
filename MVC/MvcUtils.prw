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
User Function FwGrdSum( cIdGrid, cIdField )
Return FwGrdSum( cIdGrid, cIdField )

Static Function FwGrdSum( cIdGrid, cIdField )
Return ( U_aReduce( U_aMap( FwDatArr(cIdGrid), {|x| x[ FwFldPos(cIdGrid, cIdField) ] } ) ) )
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
	Local oModel, oModelGrid
	Default lDeleted:= .F.

	If ValType(xModelGrid) == 'O'
		oModelGrid:= xModelGrid
	Else
		oModel:= FWModelActive()
		oModelGrid:= oModel:GetModel(xModelGrid)
	EndIf

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
User Function FwDatArr( xModelGrid, lDeleted )
Return FwDatArr( xModelGrid, lDeleted )

Static Function FwDatArr( xModelGrid, lDeleted )
	Local oModel, oModelGrid
	Local aData
	Default lDeleted:= .F.

	If ValType(xModelGrid) == 'O'
		oModelGrid:= xModelGrid
	Else
		oModel:= FWModelActive()
		oModelGrid:= oModel:GetModel(xModelGrid)
	EndIf

	aData:= iif( lDeleted, oModelGrid:GetData(), U_aFilter(oModelGrid:GetData(), {|x| ! x[MODEL_GRID_DELETE] }) )

Return ( U_aMap( aData, {|x,y| x[MODEL_GRID_DATA][MODEL_GRIDLINE_VALUE] } ) )
// FIM da Funcao FwDatArr
//======================================================================================================================


