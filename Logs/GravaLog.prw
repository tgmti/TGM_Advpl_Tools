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
