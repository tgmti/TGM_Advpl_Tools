#INCLUDE "totvs.ch"
#DEFINE ENTER chr(13)+chr(10)

/*=========================================================================*\
|| ####################################################################### ||
|| # Sistema:  maps01                                                    # ||
|| #                                                                     # ||
|| # Objetivo: Retorna a Latitude e Longitude conforme o endereço        # ||
|| #                                                                     # ||
|| # Data:     22/06/2015                                                # ||
|| ####################################################################### ||
\*=========================================================================*/

User Function maps01()

	Local aCoordenadas	:= {}
	Local cStatus		:= ""
	Local cLat			:= ""
	Local cLong			:= ""
	Local API_KEY		:= ""

	cHtmlPage := Httpget("https://maps.googleapis.com/maps/api/geocode/xml?address="+StrTran(Alltrim(SA1->A1_MUN)," ","%20")+","+StrTran(Alltrim(SA1->A1_END)," ","%20")+"+"+StrTran(Alltrim(SA1->A1_EST)," ","%20")+"&key="+API_KEY)
	cAviso	:= ""
	cErro	:= ""
	oXml	:= XmlParser(cHtmlPage,"_",@cAviso,@cErro)
	if oXml <> NIL
		cStatus:= U_XmlChild( oXml, "_GEOCODERESPONSE:_STATUS")
		if ! Empty(cStatus) .And. cStatus <> 'ZERO_RESULTS'

			cLat	:= U_XmlChild( oXml, "_GEOCODERESPONSE:_RESULT:_GEOMETRY:_LOCATION:_LAT" )
			cLong	:= U_XmlChild( oXml, "_GEOCODERESPONSE:_RESULT:_GEOMETRY:_LOCATION:_LNG" )

			if ! Empty(cLat) .And. ! Empty(cLong)

				dbselectarea("DAR") //TODO: 020 - Incluir esta parte de tratar a DAR dentro do TRA43W03
				dbsetorder(1) //DAR->DAR_FILIAL + DAR->DAR_FILENT + DAR->DAR_ENTIDA + DAR->DAR_CODENT + DAR->DAR_LATITU + DAR->DAR_LONGIT
				if ! dbseek(xFilial("DAR")+xFilial("DAR")+"SA1"+SA1->A1_COD+SA1->A1_LOJA)
					Reclock("DAR",.T.)
						DAR->DAR_FILIAL := xFilial("DAR")
						DAR->DAR_FILENT := xFilial("DAR")
						DAR->DAR_ENTIDA := "SA1"
						DAR->DAR_CODENT := SA1->A1_COD+SA1->A1_LOJA
						DAR->DAR_LATITU := cLat
						DAR->DAR_LONGIT := cLong
					MsUnlock()
					aAdd( aCoordenadas, { cLat, cLong } )
					conout("Insercao de coordenadas para o cliente: "+SA1->A1_COD+SA1->A1_LOJA+ENTER+"Latitude: "+cLat+ENTER+"Longitude: "+cLong)

				else //TODO: 020 - Tratar as mensagens
					conout("Não foi feita a Insercao de coordenadas para o cliente: "+SA1->A1_COD+SA1->A1_LOJA+ENTER+"Latitude: "+cLat+ENTER+"Longitude: "+cLong)
				endif

			else
				conout("Erro ao buscar as coordenadas(1): "+StrTran(Alltrim(SA1->A1_MUN)," ","%20")+","+StrTran(Alltrim(SA1->A1_END)," ","%20")+"+"+Alltrim(SA1->A1_EST))
			endif

		else
			conout("Não foram encontradas coordenadas para o cliente: "+SA1->A1_COD+SA1->A1_LOJA)
		endif
	else
		conout("Erro ao buscar as coordenadas(2): "+StrTran(Alltrim(SA1->A1_MUN)," ","%20")+","+StrTran(Alltrim(SA1->A1_END)," ","%20")+"+"+Alltrim(SA1->A1_EST))
	endif

Return (aCoordenadas)