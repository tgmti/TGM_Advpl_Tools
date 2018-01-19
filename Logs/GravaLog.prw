#Include 'Protheus.ch'
#Include 'fileio.ch'

#DEFINE LOG_INFO	0
#DEFINE LOG_ERRO	0
#DEFINE LOG_AVISO	1
#DEFINE LOG_INFDET	2
#DEFINE LOG_INFDETA	3
#DEFINE LOG_INFDETB	4
#DEFINE LOG_TUDO	9

#DEFINE FS_SET		0 // Ajusta a partir do início do arquivo. (Padrão)
#DEFINE FS_RELATIVE	1 // Ajuste relativo a posição atual do arquivo.
#DEFINE FS_END		2 // Ajuste a partir do final do arquivo.
#DEFINE STRSEP		"================================================================"

//====================================================================================================================\\
/*/{Protheus.doc}GravaLog
  ====================================================================================================================
	@description
	Função customizada para gravação de logs

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		15/10/2015

/*/
//===================================================================================================================\\
User Function GravaLog(cLog, cProcesso, nNivLog, cArquivo, cDiretorio, lData, lConOut, nStrSep)

	Local cData:= DToS(Date())
	Local cLogF:= ""

	Static nHandle
	Static cPrcLog
	Static cArqLog
	Static cDirLog
	Static nNivPar

	Default nNivLog:= 0
	Default nNivPar:= LOG_TUDO
	Default lConOut:= .F.
	Default nStrSep:= 0 // 0 - Acima, 1 - Abaixo, 2 - Não

	If nNivPar >= nNivLog


		If ! Empty(cArquivo)
			cArqLog:= cArquivo
		ElseIf ! Empty(cArqLog) .And. ! Empty(cPrcLog) .And. ! Empty(cProcesso) .And. cProcesso != cPrcLog
			cArqLog:= Nil
		Endif
		
		If ! Empty(cProcesso)
			cPrcLog:= cProcesso
		Endif

		If ! Empty(cDiretorio)
			cDirLog:= cDiretorio
		Endif

		Default cLog	:= ""
		Default lData	:= .T.
		Default cPrcLog	:= FunName()
		Default cDirLog	:= "\LOGS\"
		Default cArqLog	:= cPrcLog

		If lData .And. ! cData $ cArqLog
			cArqLog+= "-" + cData
		EndIf

		If Upper(Right(cArqLog, 4)) != ".LOG"
			cArqLog+= ".LOG"
		EndIf

		If nStrSep== 0 // Acima
			cLogF+=	STRSEP + CRLF
			If lData
				cLogF+=	"> " + DToC(Date()) + " - " + Time() + " - " + cPrcLog + CRLF
			EndIf
		EndIf

		If nStrSep== 2 .And. lData
			cLogF+=	"> " + DToC(Date()) + " - " + Time() + " - " + cPrcLog + CRLF
		EndIf

		cLogF+= ">> " + AllTrim(cLog) + CRLF

		If nStrSep== 1 // Abaixo
			If lData
				cLogF+=	"> " + DToC(Date()) + " - " + Time() + " - " + cPrcLog + CRLF
			EndIf
			cLogF+=	STRSEP + CRLF
		EndIf

		If ! SfMkDir( cDirLog )
			ConOut( "Erro ao criar o diretório de logs: " + cDirLog )
			Return
		EndIf

		If File( cDirLog + cArqLog )
			nHandle:= FOpen( cDirLog + cArqLog, FO_READWRITE + FO_SHARED )
		Else
			nHandle:= FCreate( cDirLog + cArqLog )
		Endif

		If nHandle >= 0
			FSEEK(nHandle, 0, FS_END)
			FWrite( nHandle, cLogF )
			//FT_FUse()
			fClose( nHandle )
		EndIf

		If lConOut
			ConOut( cLogF )
		EndIf

	EndIf

Return (cLogF)
// FIM da Funcao GravaLog
//======================================================================================================================



//====================================================================================================================\\
/*/{Protheus.doc}SfMkDir
  ====================================================================================================================
	@description
	Cria a estrutura de pastas passada

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		07/06/2016

/*/
//===================================================================================================================\\
Static Function SfMkDir( cDirFull )

	Local lRet		:= .F.
	Local cDirTmp	:= ""
	Local lRemoto
	Local aDir, nX

	Default cDirFull:= "\LOGS\"

	lRemoto:= ! (":" $ cDirFull)
	aDir:= StrToKarr( cDirFull, "\" )

	For nX:= 1 To Len(aDir)

		cDirTmp+= If(nX == 1 .And. ! lRemoto, "", "\") + aDir[nX]

		If ! Empty( aDir[nX] ) .And. ! ExistDir( aDir[nX] )
			If MakeDir( aDir[nX] ) <> 0
				Help(" ",1,"NOMAKEDIR")
				lRet := .F.
				Exit
			EndIf
		EndIf

	Next nX

	lRet:= ExistDir( cDirfull )

Return ( lRet )
// FIM da Funcao SfMkDir
//======================================================================================================================


