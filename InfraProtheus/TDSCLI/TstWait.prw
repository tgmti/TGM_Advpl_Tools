#INCLUDE 'PROTHEUS.CH'

User Function TstWait()

	Local lRun:= .T.
	Local lWaitRun:= .T.
	Local cPath:= "C:\TOTVS\TotvsDeveloperStudio-11.3\"
	Local cComm:= cPath + "tdscli.bat compile > c:\temp\state.log 2>&1"
	Local lRet


	While lRun
		
		If ( lRet:= WaitRunSrv( @cComm, @lWaitRun , @cPath ) )
			ConOut("Sucess")
		Else
			ConOut("Error")
		EndIf
		lRun:= .F.
	EndDo

Return ( lRet )

User Function TstTdsCli()
	Local oTdsCli:= UTDSCli():New()

	oTdsCli:cFileConf:= "C:\TOTVS\TDS\WorkSpaces\TDS_Workspace_Mars_11.2\TGM_Advpl_Tools\APLICA~1\TDSCLI_Param.txt"
	oTdsCli:cPathTDS:= "c:\TOTVS\TDS\TotvsDeveloperStudio-11.3_ATUAL\"
	oTdsCli:Exec("compile")

Return (nil)