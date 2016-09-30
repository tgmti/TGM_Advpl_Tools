#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}fnWhereFil
  ====================================================================================================================
	@description
	Retorna as clausulas Where corretas para filtro de várias filiais

	@author		TSC681 - Thiago Goncalves Mota
	@version	1.0
	@since		05/07/2013
	@return		cWhereFil, Padrão: "" - Cláusula where com a comparacao de todas as tabelas e filiais

	@param		aTabelas, Array, Tabelas cujo campo filial deve ser comparado.
	@param		aFiliais, Array, Array com as filiais que devem ser comparadas.

	@obs
	Áreas utilizadas: "SM0"
	Para o Array aFiliais, utilizar o mesmo formato retornado pela função FWLoadSM0: [ [codEmpresa, CodFilial] ]
	Caso aFiliais for omitido, a função irá percorrer todas as filiais, utilizando FWLoadSM0.

	Exemplo:
	xFilial:= fnWhereFil( { 'SF2','SA1' } )
	Considerando que existam duas filiais no sistema, '0101' e '0102', e que as tabelas sejam exclusivas:
	Retorno: " ( (SF2.F2_FILIAL = '0101' AND SA1.A1_FILIAL = '0101') OR  (SF2.F2_FILIAL = '0102' AND SA1.A1_FILIAL = '0102') ) "

	Uso:
	cQuery:= " SELECT * FROM " + RetSqlTab('SF2,SA1')
	cQuery+= " WHERE " + fnWhereFil( { 'SF2','SA1' } )
	cQuery+= " AND SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA=SA1.A1_LOJA "
	cQuery+= " AND " + RetSqlDel('SF2,SA1')

	Resultado:
	SELECT * FROM SF2010 SF2, SA1010 SA1
	WHERE  ( (SF2.F2_FILIAL = '0101' AND SA1.A1_FILIAL = '0101') OR  (SF2.F2_FILIAL = '0102' AND SA1.A1_FILIAL = '0102') )
	AND SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA=SA1.A1_LOJA
	AND SF2.D_E_L_E_T = ' ' AND SA1.D_E_L_E_T = ' '

/*/
//===================================================================================================================\\
Static Function fnWhereFil(aTabelas, aFiliais)
	Local cFilBkp
	Local aAreaBkp	:= {}
	Local cWhereFil	:= ""
	Local nX, nY

	Default aFiliais:= FWLoadSM0()

	// Backup das áreas atuais
	aEval({"SM0"}, { |area| aAdd(aAreaBkp, (area)->(GetArea()) ) } )
	aAdd(aAreaBkp, GetArea())
	cFilBkp:= cFilAnt

	For nY:= 1 to Len(aFiliais)
		If aFiliais[nY,2]!=cFilAnt
			cFilAnt:= aFiliais[nY,2]
		Endif

		cWhereFil+= if (empty(cWhereFil)," ( "," OR ( ")
		For nX := 1 To Len(aTabelas)
			cWhereFil+= if (nX > 1, " AND ", "")
			cWhereFil+= aTabelas[nX]+"."+ SubStr(aTabelas[nX], 2, 2) + "_FILIAL = '" + xFilial(aTabelas[nX]) + "'"
		Next nX
		cWhereFil+= " ) "

	Next nY

	cWhereFil:= "( " + cWhereFil + " )"

	( if(!Empty(cFilBkp),cFilAnt:= cFilBkp, Nil) ) // Restaura a filial anterior
	aEval(aAreaBkp, {|area| RestArea(area)}) // Restaura as áreas anteriores
Return ( cWhereFil )