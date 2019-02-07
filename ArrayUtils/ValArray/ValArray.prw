#Include 'Protheus.ch'

User Function TSTValAr()

	aArrTeste:= { "Posição 1", {"Posição 2,1", {"Posição 2,2,1", {"Posição 2,2,2,1" } } } }

	U_ValArray(aArrTeste, {2,2,2,1}, "Retorna a última posição", .F.)

	U_ValArray(aArrTeste, {1,1}, "Posição não  existe")

	U_ValArray(aArrTeste, {2,2}, "Retorna um Array", .T.)

Return

/**********************************************************************************************************
 {Protheus.doc} ValArray

	Descrição: Recuperar informação dentro de um Array, validando se existem as posições passadas

	@author Thiago Mota
	@author <mota.thiago@totvs.com.br>
	@author <tgmspawn@gmail.com>

	@version	1.0
	@since		14/02/2013
	@return		xRet	:=	cPadrao

	@param		aArray		Obrigatório		Array onde buscar o valor
	@param		aNPos		Obrigatório		Array com as posições onde o valor se encontra
											Ou um número para identificação da posição em um vetor unidimensional
	@param		cPadrao		Padrão = Nil	Valor padrão caso não for possível encontrar o dado no array
	@param		lMudaTipo	Padrão = .F.	Define se muda o tipo de dados, caso seja diferente do tipo em cPadrao

	@sample		U_ValArray(aArray, {4,5}, "TESTE")
				Este exemplo irá buscar o valor contido em aArray[4,5],
				caso o array não possua esta dimensão, ou o tipo de dados seja diferente do padrão
				será retornado o valor "TESTE"

	@obs		15/03/2013 - Thiago Mota:
				Facilitar a utiização da função em vetores com apenas uma dimensão,
				informando valores numéricos no parâmetro aNPos
				Validação do parâmetro aNPos modificada para aceitar também valores numéricos.

*********************************************************************************************************/

User Function ValArray(aArray, aNPos, cPadrao, lMudaTipo)

	Local xRet	:= cPadrao
	Local nI	:= 1
	Local nTam	:= 0
	Local xAux
	Default lMudaTipo:= .F.

	if ValType(aNPos)=="A"
		nTam:= Len(aNPos)
	Elseif ValType(aNPos)=="N"
		nTam:= 1
		aNPos:= { aNPos }
	Elseif ValType(aNPos)=="C"
		//Converte o caracter enviado "1,1,1" para array {"1","1","1"}
		aNPos := StrTokArr2( aNPos, ",", .F. )
		//Converte as posições caracteres em numericas-> {1,1,1}
		For nCvt := 1 To Len( aNPos )
			aNPos[ nCvt ] := Val( aNPos[ nCvt ] )
		Next nCvt
		nTam  := Len( aNPos )
	Else
		Return xRet
	EndIf

	While nI <= nTam

		If ValType(aArray)=="A";
		 .And. ValType( aNPos[nI] )=="N" ;
		 .And. Len(aArray) >= aNPos[nI]
			xAux:= aArray[ aNPos[nI] ]
		Else
			Exit
		EndIf

		If nI == nTam
			If lMudaTipo .Or. ValType(xAux) == ValType(cPadrao)
				xRet:= xAux
			EndIf
			Exit
		Else
			aArray:= xAux
			nI++
		EndIf

	EndDo

Return xRet
/* FIM da Função ValArray
//*******************************************************************************************************/

