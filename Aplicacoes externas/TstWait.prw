#INCLUDE 'PROTHEUS.CH'

User Function TstWait()

	Local lRun:= .T.
	Local lWaitRun:= .T.
	Local cPath:= "c:\TOTVS\TDS\TotvsDeveloperStudio-11.3_ATUAL\"
	Local cComm:= cPath + "tdscli.bat compile > c:\temp\state.log 2>&1"


	While lRun
		
		If WaitRunSrv( @cComm, @lWaitRun , @cPath )
			ConOut("Sucess")
		Else
			ConOut("Error")
		EndIf
	EndDo

Return (Nil)

User Function TstTdsCli()
	Local oTdsCli:= UTDSCli():New()

	oTdsCli:cFileConf:= "c:\TOTVS\TDS\TDSCLI_Param.txt"
	oTdsCli:cPathTDS:= "c:\TOTVS\TDS\TotvsDeveloperStudio-11.3_ATUAL\"
	oTdsCli:Exec("compile")

Return (nil)