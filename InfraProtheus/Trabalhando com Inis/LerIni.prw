#Include 'Protheus.ch'

User Function LerIni()

	Local aEnvs
	Local aTops
	Local cEnvAtu
	Local cApxSrvIni:= GetADV97()

	//WizCfgRead()
	//aEnvs:= WizGetAEnv()
	//aTops:= WizGetATOP()

	cEnvAtu:= GetEnvServer()
	cDataBase:= GetPVProfString(cEnvAtu,"TOPDATABASE","",cApxSrvIni)

Return

