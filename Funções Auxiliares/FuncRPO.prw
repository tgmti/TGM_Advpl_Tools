#Include 'Protheus.ch'

User Function FuncRPO()
	Local cMsgRet:= ""
	Local aF,Al,aT,aD,aH,aR
	Local cM,cSave,cSeek
	Local nHandle, nX
	Local bSave := {||aT[nX]+';'+aF[nX]+';'+aL[nX]+';'+DToc(aD[nX])+';'+aH[nX]+Chr(13)+Chr(10)}

	aF:=Al:=aT:=aD:=aH:=aR:= {}
	cM:=cSave:=cSeek:= ""
	nHandle:=nX:=0

	CriaPerg()
	Pergunte("TGM0001",.T.)
	cSeek:=AllTrim(MV_PAR01)
	cSave:=AllTrim(MV_PAR02)

	aR:=GetFuncArray(cSeek,aT,aF,aL,aD,aH)

	MemoWrite(cSave,'Lista de funcoes do RPO'+Chr(13)+Chr(10))
	nHandle:=fopen(cSave,2+64)
	If(nHandle==-1)
		Alert(ferror())
	EndIf
	FSeek(nHandle,0,2)
	FWrite(nHandle,'Funcao;Arquivo;Linha;Data;Hora'+Chr(13)+Chr(10))

	nX:=0
	aEval(aR,{|x| ++nX, cM:= x+Eval(bSave),FWrite(nHandle,cM) })
	fclose(nHandle)
	MsgAlert('Processo concluído!' +Chr(13)+Chr(10) + cValToChar(nX) + ' linhas gravadas.')

Return

Static Function CriaPerg()
	PutSX1( "TGM0001","01","Filtro","","","mv_ch1","C",60,/*nDecimal*/,/*nPresel*/,/*cGSC*/"G",/*cValid*/,/*cF3*/,/*cGrpSxg*/,/*cPyme*/,/*cVar01*/'MV_PAR01',/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
	PutSX1( "TGM0001","02","Arquivo para salvar ","","","mv_ch2","C",60,/*nDecimal*/,/*nPresel*/,/*cGSC*/"G",/*cValid*/,/*cF3*/,/*cGrpSxg*/,/*cPyme*/,/*cVar01*/'MV_PAR02',/*cDef01*/,/*cDefSpa1*/,/*cDefEng1*/,/*cCnt01*/,/*cDef02*/,/*cDefSpa2*/,/*cDefEng2*/,/*cDef03*/,/*cDefSpa3*/,/*cDefEng3*/,/*cDef04*/,/*cDefSpa4*/,/*cDefEng4*/,/*cDef05*/,/*cDefSpa5*/,/*cDefEng5*/,/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,/*cHelp*/ )
Return Nil