#Include 'Protheus.ch'

User Function TINFRPO()

	Local cFunc:= "CRMXPic*"
	Local aFile:= {}

	Local aRet
	Local nCount
	Local aType // Para retornar a origem da função: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
	Local aFile // Para retornar o nome do arquivo onde foi declarada a função
	Local aLine // Para retornar o número da linha no arquivo onde foi declarada a função
	Local aDate // Para retornar a data da última modificação do código fonte compilado
	Local aTime // Para retornar a hora da última modificação do código fonte compilado

	// Buscar informações de todas as funções contidas no APO
	aRet:= GetFuncArray(cFunc, @aType, @aFile, @aLine, @aDate, @aTime)

	If Len(aRet) > 0
		For nCount:= 1 To Len(aRet)
			Alert( "Funcao: " + aRet[nCount] ;
				+ ", Arquivo: " + aFile[nCount] ;
				+ ", Data: " + DtoC(aDate[nCount]) + " " + aTime[nCount] ;
				+ ", Linha: " + aLine[nCount] )
		Next nCount
	Else
		Alert("Nenhuma função encontrada!")
	EndIf

Return

