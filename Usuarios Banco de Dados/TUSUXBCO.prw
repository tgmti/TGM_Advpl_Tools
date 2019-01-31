#include 'protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}TUSUXBCO
  ====================================================================================================================
	@description
	Copia o cadastro de usuário para uma tabela no banco de dados

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		02/05/2016

	@sample	U_TUSUXBCO()

/*/
//===================================================================================================================\\
User Function TUSUXBCO()

	Local nx
	Local aAllusers
	Local lInclui

	If Type("cFilAnt") == "U"
		RPCSetType(3)
		RpcSetEnv( "01","01",,,"FAT","MATA010" )
	EndIf

	aAllusers := FWSFALLUSERS()
	DbSelectArea("ZZD")
	DbSetOrder(1)

	For nx := 1 To Len(aAllusers)

		lInclui:= ! DbSeek( xFilial("ZZD") + aAllusers[nx][2] )

		RecLock("ZZD", lInclui)
		ZZD_FILIAL:= xFilial("ZZD")
		ZZD_CODIGO:= aAllusers[nx][2]
		ZZD_LOGIN := aAllusers[nx][3]
		ZZD_NOME  := aAllusers[nx][4]
		ZZD_EMAIL := aAllusers[nx][5]

		MsUnLock()
	Next

	MsgInfo("Atualização do cadastro de usuários na tabela ZZD Finalizada.","Usuários x Tabela ZZD")

Return ( Nil )
// FIM da Funcao TUSUXBCO
//======================================================================================================================