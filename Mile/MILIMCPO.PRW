#INCLUDE "PROTHEUS.CH"



//====================================================================================================================\
/*/{Protheus.doc}MILIMCPO
  ====================================================================================================================
	@description
	Compatibilizador para criar Campos de log utilizados na importação de Clientes, Fornecedores, Motoristas e Veículos

	@author TSC681 Thiago Mota
	@version 1.0
	@since 04/07/2018

	@obs
	Recebe os dados tratado da rotina MileImp e tenta cadastrar na SA1 usando o ExecAuto do MATA030

/*/
//===================================================================================================================\
User Function MILIMCPO()

	Local aModelo:= {}
	Local AlteraBanco:= .T.

	Private oCompat:= UPDCUSTOM():New( "COMPATIBILIZADOR DICIONÁRIOS - CAMPOS DE LOG PARA IMPORTACAO MILE" )
	
	aAdd(aModelo, {"X3_TIPO", "M"} )
	aAdd(aModelo, {"X3_VISUAL", "V"} )
	aAdd(aModelo, {"X3_TITULO", "Log.Imp."} )
	aAdd(aModelo, {"X3_DESCRIC", "Log Importacao Legado"} )

	oCompat:AddSX3( "A1_ZLGIMP", aModelo, .F. )
	oCompat:AddSX3( "A2_ZLGIMP", aModelo, .F. )
	oCompat:AddSX3( "DA3_ZLGIMP", aModelo, .F. )
	oCompat:AddSX3( "DA4_ZLGIMP", aModelo, .F. )

	oCompat:AddSX3( "DA4_NUMCNH", {{ "X3_VLDUSER", "Vazio() .Or. U_CNHValid()" }}, .F. )

	// Executa o compatibilizador
	oCompat:RunUpdate( /*lAuto*/, /*aEmpresas*/, /*lShared*/!AlteraBanco )

	oCompat:Destroy()

Return ( Nil )
// FIM da Funcao MILIMCPO
//======================================================================================================================



