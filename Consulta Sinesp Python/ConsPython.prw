#INCLUDE 'PROTHEUS.CH'

// http://tdn.totvs.com/display/tec/WaitRun
User Function ConPython()

	Local cComando:= "python C:\Temp\Cootravale\ConsPlaca\consulta.py "
	Local cPlaca:= "AQB3165"
	Local cArqPlaca:= "c:\Temp\placas\" + cPlaca + ".json"
	Local cErro
	Local oJson

	conout("Executando consulta SINESP")
	WaitRun(cComando + cPlaca, 1 )

	If File(cArqPlaca)
		cRetorno:= Memoread(cArqPlaca)
		conout(cRetorno)

		If ! Empty(cRetorno) .And. FWJsonDeserialize(cRetorno,@oJSon)
			Return (oJson)
		EndIf

	EndIf

	conout("Fim consulta SINESP")

Return (Nil)