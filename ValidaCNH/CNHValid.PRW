#INCLUDE "PROTHEUS.CH"



//====================================================================================================================\
/*/{Protheus.doc}CNHValid
  ====================================================================================================================
	@description
	Validação do número da CNH

	@author TSC681 Thiago Mota
	@version 1.0
	@since 27/06/2018

	@obs
	Calcular validade do número da CNH, considerando a regra exposta na "RESOLUÇÃO Nº 192, DE 30 DE MARÇO DE 2006."

	Fonte:  http://www.denatran.gov.br/download/Resolucoes/resolucao_192_06.doc

	Art. 2º. O documento de Habilitação terá 2 (dois) números de identificação nacional e 1 (um) número de 
	identificação estadual, que são:

	I – o primeiro número de identificação nacional – Registro Nacional, será gerado pelo sistema informatizado da Base 
	Índice Nacional de Condutores – BINCO, composto de 9 (nove) caracteres mais 2 (dois) dígitos verificadores de 
	segurança, sendo único para cada condutor e o acompanhará durante toda a sua existência como condutor, não sendo 
	permitida a sua reutilização para outro condutor.

	II – o segundo número de identificação nacional – Número do Espelho da CNH, será formado por 8 (oito) caracteres 
	mais 1 (um) dígito verificador de segurança, autorizado e controlado pelo órgão máximo executivo de trânsito da 
	União, e identificará cada espelho de CNH expedida.

	a) O dígito verificador será calculado pela rotina denominada de “módulo 11” e sempre que o resto da divisão for 
	zero (0) ou um (1), o dígito verificador será zero (0);

	III – o número de identificação estadual será o número do formulário RENACH, documento de coleta de dados do 
	candidato/condutor gerado a cada serviço, composto, obrigatoriamente, por 11 (onze) caracteres, sendo as duas 
	primeiras posições formadas pela sigla da Unidade de Federação expedidora, facultada a utilização da última posição
	como dígito verificador de segurança.

	a) O número do formulário RENACH identificará a Unidade da Federação onde o condutor foi habilitado ou realizou 
	alterações de dados no seu prontuário pela última vez.

	b) O Formulário RENACH que dá origem às informações na BINCO e autorização para a impressão da CNH deverá ficar 
	arquivado em segurança, no órgão ou entidade executivo de trânsito do Estado ou do Distrito Federal.

	=================================================

	Método:
	DV módulo 11 corresponde ao resto da divisão por 11 do somatório da multiplicação de cada algarismo da base 
	respectivamente por 9, 8, 7, 6, 5, 4, 3, 2, 1 e 0, a partir da unidade. O resto 10 é considerado 0. 
	Seguindo a resolução, o resto 1 também deve ser considerado 0, porém existem casos de CNH com dígito 1.

	=================================================

/*/
//===================================================================================================================\
User Function CNHValid( cNumCNH )
	
	Local lRet:= .F.
	Local nX, nY
	Local cChar
	Local nAuxDig
	Local nDig
	Local cNumFim:= ""
	Local cNumValid:= ""
	Local cDig:= ""
	Local nSoma:= 0

	cNumCNH:= &(ReadVar())

	cNumCNH:= AllTrim(cNumCNH)

	If Len(cNumCNH) > 8

		For nY:= 1 To 2

			nAuxDig:= If(nY==1, 1, 0)

			For nX:= 1 To Len(cNumCNH)
				cChar:= Substr(cNumCNH, nX, 1)

				If isAlpha( cChar )
					Help(" ", 1, "ONLYNUM")
					Return lRet
				EndIf

				If nX < (Len(cNumCNH)-2)
					If nY == 1
						cNumValid+= cChar
						cNumFim+= cChar
					EndIf
					nSoma+= nAuxDig * Val(cChar)
					nAuxDig++
				EndIf
			Next nX

			// Calcula o Mod
			nDig:= nSoma % 11
			If nDig <= 1 .Or. nDig > 9
				nDig:= 0
			EndIf
			cNumValid+= cValToChar(nDig)
			cDig:= cValToChar(nDig) + cDig // O dígito verificador da CNH é invertido
			
		Next nY

		cNumFim+= cDig

		If cNumCNH <> cNumCNH
			HELP(' ',1,"CNH Invalido" ,,"Dígito verificador da CNH inválido",2,0,,,,,, "")
		EndIf

	Else
		HELP(' ',1,"CNH Invalido" ,,"Número da CNH deve ter 11 caracteres",2,0,,,,,, "")

	EndIf

Return ( lRet )
// FIM da Funcao CNHValid
//======================================================================================================================


