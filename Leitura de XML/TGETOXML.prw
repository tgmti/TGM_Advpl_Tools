#Include 'Protheus.ch'

//====================================================================================================================\\
/*/{Protheus.doc}TGETOXML
  ====================================================================================================================
	@description
	Abre um arquivo indicado e converte para XML

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		06/04/2016
	@return		oXml, Padrão: := Nil - Conteúdo do arquivo Convertido para XML

	@param		cArq, Caractere	, Caminho e nome do arquivo a ser convertido
	@param		oXml, Objeto	, Objeto que será retornado como XML
	@param		cLog, Caractere	, Variável para retorno dos erros e avisos encontrados em caso de problema na conversão

	@obs
	Áreas utilizadas: Areas
	obs_description

	@sample	U_TGETOXML(cArq, oXml, cLog)

/*/
//===================================================================================================================\\
User Function TGETOXML(cArq, oXml, cLog)

	Local lRet		:= .F.
	Local clError   := ""
	Local clWarning := ""
	Local nHdl
	Local nBuffer
	Local cFileXml

	Default cArq	:= ""
	Default cLog	:= ""
	oXml:= Nil

	If File(cArq)

		nHdl:= fOpen( cArq )

		If nHdl >= 0

			nBuffer:= fSeek(nHdl,0,2)
			cFileXml	:= Space(nBuffer)
			FSeek(nHdl, 0, 0)
			cFileXml := FReadStr( nHdl, nBuffer )
			FClose(nHdl)

			oXml := XmlParser(cFileXml,"_",@clError,@clWarning)

			If ValType(oXml) == "O"

				lRet:= .T.

			Else

				cLog:= "Erro ao converter o arquivo '" + cArq + "'."

				If ! Empty(clError)
					cLog+= CRLF + clError
				EndIf

				If ! Empty(clWarning)
					cLog+= CRLF + clWarning
				EndIf

				oXml:= Nil

			EndIf

		Else

			cLog:= "Erro ao abrir o arquivo '" + cArq + "'. FERROR: " + str(ferror(),4)

		EndIf

	Else

		cLog:= "Arquivo '" + cArq + "' não encontrado para conversão."

	Endif

Return ( lRet )
// FIM da Funcao TGETOXML
//======================================================================================================================