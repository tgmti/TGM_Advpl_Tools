#Include 'Protheus.ch'
#Include 'fileio.ch'
#INCLUDE 'TRA43EDI.CH'

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
User Function GravaLog(cLog, cProcesso, nNivLog, cArquivo, cDiretorio, lData)

	Local cData:= DToS(Date())

	Static nHandle
	Static cPrcLog
	Static cArqLog
	Static cDirLog
	Static nNivPar

	Default nNivLog:= 0
	Default nNivPar:= SuperGetMv("MV_ZNIVLOG", .F., LOG_TUDO)

	If nNivPar >= nNivLog

		If ! Empty(cProcesso)
			cPrcLog:= cProcesso
		Endif

		If ! Empty(cDiretorio)
			cDirLog:= cDiretorio
		Endif

		If ! Empty(cArquivo)
			cArqLog:= cArquivo
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

		cLog:=	STRSEP + CRLF + ;
				"> " + DToC(Date()) + " - " + Time() + " - " + cPrcLog + CRLF + ;
				">> " + AllTrim(cLog) + CRLF

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
			FWrite( nHandle, cLog )
			FT_FUse()
		EndIf

	EndIf

Return
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