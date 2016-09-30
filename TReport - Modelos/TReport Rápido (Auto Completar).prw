#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}${name}
  ====================================================================================================================
	@description
	Relatório ${name} - ${title}
	${long_description}

	@author		${author}
	@version	${version}
	@since		${date}
	@return		Nil			, Nil				, Não se aplica

	@obs
	Lista de parâmetros:	${paramlist}
	Grupo de perguntas:	${grupo_perguntas}
	Áreas utilizadas:		${Areas}
	Backup e Restore das áreas: ${lBackupAreas}
	Método de Seleção:	${tipoQuery}  (0 - TReport, 1 = TCQuery(cQuery), 2 = Embedded SQL )

	${obs_description}

	@sample	U_name(${paramlist})
	@example	examples

/*/
//===================================================================================================================\\
User Function ${name}(${paramlist})
	Local lBkpArea		:= ${lBackupAreas}
	Local aAreaBkp		:= {}
	Local oReport

	If lBkpArea // Backup das áreas atuais
		aEval({Areas}, { |area| aAdd(aAreaBkp, (area)->(GetArea()) ) } )
		aAdd(aAreaBkp, GetArea())
	EndIf

	oReport := ReportDef()
	oReport:PrintDialog()

	If lBkpArea // Restaura as áreas anteriores
		aEval(aAreaBkp, {|area| RestArea(area)})
	EndIf
Return ( Nil )
// FIM do Relatório ${name}
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}ReportDef
  ====================================================================================================================
	@description
	Relatório ${name} - ${title}
	A funcao estatica ReportDef devera ser criada para todos os relatorios que poderao ser agendados pelo usuario.

	@author		${author}
	@version	${version}
	@since		${date}
	@return		oReport		, Objeto		, Objeto da Classe TReport com as definições de impressão


	@obs		Parâmetros passados para a ReportPrint: oReport${paramlistPrint}
				${obs_description}

/*/
//===================================================================================================================\\
Static Function ReportDef()
	Local oReport
	Local cNomRel	:= '${name}'	//Nome do relatorio.
	Local cTitRel	:= '${title}' //Titulo do relatorio.
	Local cDesRel	:= '${long_description}' //Descricao do relatorio.
	Local cGruPer	:= '${grupo_perguntas}' // Grupo de perguntas

	oReport := TReport():New(cNomRel,cTitRel,cGruPer, {|oReport| ReportPrint(oReport${paramlistPrint})},cDesRel,;
								/*lLandscape*/,/*uTotalText*/,/*lTotalInLine*/,/*cPageTText*/,/*lPageTInLine*/,/*lTPageBreak*/,/*nColSpace*/)

	${cursor}

	If !Empty(oReport:uParam)
        AjusParam(cGruPer)
        Pergunte(oReport:uParam,.F.)
	EndIf

Return (oReport)
// FIM da Função ReportDef
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}ReportPrint
  ====================================================================================================================
	@description
	Relatório ${name} - ${title}
	Função responsável pela execução do relatório

	@author		${author}
	@version	${version}
	@since		${date}
	@return		Nil			, Nil				, Não se aplica

	@obs		Lista de parâmetros: oReport${paramlistPrint}

/*/
//===================================================================================================================\\
Static Function ReportPrint(oReport${paramlistPrint})

	Local cAliasQry := GetNextAlias()
	Local nTipQuery := ${tipoQuery}

	MakeSqlExpr(oReport:uParam)

	If Empty(nTipQuery) .Or. nTipQuery==0
		oReport:Section(1):Print()
	Else
		oReport:SetMeter(ExecRelQry(nTipQuery, oReport, cAliasQry))

		dbSelectArea(cAliasQry)
		dbGoTop()
		While !oReport:Cancel() .And. !(cAliasQry)->(Eof())
			oReport:Section(1):Section(1):Init()
			oReport:Section(1):Section(1):PrintLine()
			oReport:Section(1):Section(1):Finish()
			dbSelectArea(cAliasQry)
			dbSkip()
			oReport:IncMeter()
		EndDo

		oReport:Section(1):Finish()
		oReport:Section(1):SetPageBreak(.T.)

	EndIf


Return ( Nil )
// FIM da Função ReportPrint
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}ExecRelQry
  ====================================================================================================================
	@description
	Relatório ${name} - ${title}
	Função que ajusta o grupo de perguntas utilizado nos filtros do relatório

	@author		${author}
	@version	${version}
	@since		${date}
	@return		nCount		, Numérico		, Quantidade de registros na Query

	@param		nTipQuery	, Numérico		, Indica o tipo de Query a utilizar (1 = Query TXT, 2 = Embedded SQL)
	@param		oReport		, Objeto		, Objeto da Classe TReport com as definições de impressão
	@param		cAliasQry	, Caractere	, Alias da para a Query

/*/
//===================================================================================================================\\
Static Function ExecRelQry(nTipQuery, oReport, cAliasQry)
	Local nCount	:= 0

	//TODO: Implementar cQuery
	If nTipQuery == 2

		oReport:Section(1):BeginQuery()

		BeginSql Alias cAliasQry
			SELECT
				SA1.*

			FROM
				%table:SA1% SA1

			WHERE
					  SA1.A1_FILIAL = %xFilial:SA1%
				AND SA1.%NotDel%

			ORDER BY
				%Order:SA1%

		EndSql

		oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

	EndIf

	Count to nCount //TODO: Ver se funciona com Embedded


Return ( nCount )
// FIM da Função ExecRelQry
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}AjusParam
  ====================================================================================================================
	@description
	Relatório ${name} - ${title}
	Função que ajusta o grupo de perguntas utilizado nos filtros do relatório

	@author		${author}
	@version	${version}
	@since		${date}
	@return		Nil			, Nil				, Não se aplica

	@param		cGruPer		, Caractere	, Grupo de perguntas do SX1

/*/
//===================================================================================================================\\
Static Function AjusParam(cGruPer)

Return ( Nil )
// FIM da Função AjusParam
//======================================================================================================================
