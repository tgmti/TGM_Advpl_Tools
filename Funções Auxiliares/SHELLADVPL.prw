#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}SHELLADVPL
  ====================================================================================================================
	@description
	Tela auxiliar para avaliação de expressões no Protheus

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		2 de mar de 2017
	@return	xRet, Padrão: Nulo

	@sample	U_SHELLADVPL()

/*/
//===================================================================================================================\\
User Function SHELLADVPL(${param}, ${param_type}, ${param_descr})
	Local aAreaBkp:= {}
	Local xRet		:= Nil

	// Backup das áreas atuais
	aEval({Areas}, { |area| aAdd(aAreaBkp, (area)->(GetArea()) ) } )
	aAdd(aAreaBkp, GetArea())



	aEval(aAreaBkp, {|area| RestArea(area)}) // Restaura as áreas anteriores
Return ( xRet )
// FIM da Funcao SHELLADVPL
//======================================================================================================================


