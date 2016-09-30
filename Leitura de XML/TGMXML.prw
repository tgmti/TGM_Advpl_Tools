#Include 'Protheus.ch'

CLASS TGMXML

	// Atributos técnicos
	DATA TipoArquivo 		AS STRING				// Indica se é NF-e ou CT-e
	DATA TipoImport			AS STRING				// Indica se é importação via Arquivo ou String
	DATA MensagemRetorno	AS STRING				// Mensagem com informações e erros
	DATA Status				AS BOOLEAN				// Flag de status do último processamento
	DATA Arquivo			AS STRING				// Arquivo a ser importado
	DATA StringXML			AS STRING				// String com o XML lido

	// Atributos de configuração da importação

	// Atributos de cabecalho
	DATA Numero				AS STRING				// Número da NF-e ou CT-e
	DATA Serie				AS STRING				// Série da NF-e ou CT-e
	DATA Chave				AS STRING				// Chave da NF-e ou CT-e
	DATA Emissao			AS DATE					// Data de emissao da nota ou CT-e

	DATA Protocolo			AS STRING				// Protocolo de autorização da NF-e ou CT-e
	DATA DataAut			AS DATE					// Data de autorização
	DATA HoraAut			AS STRING				// Hora de autorização

	DATA CGCEmitente		AS STRING				// CGC do emitente da nota ou CT-e
	DATA CGCRemetente		AS STRING				// CGC do remetente do CT-e
	DATA CGCDestinatario	AS STRING				// CGC do destinatário da nota ou CT-e
	DATA CGCDevedor			AS STRING				// CGC do devedor do frete no CT-e

	DATA InfAdic			AS STRING				// Informações adicionais da nota ou CT-e

	WSMETHOD New
	WSMETHOD ParseFile
	WSMETHOD ParseString

	// Dados de Transporte
/*
	DATA modFrete			AS STRING				// Modalidade do frete
	DATA CGCTransp			AS STRING				// CGC do Transportador
	DATA NomeTransp			AS STRING				// Razão Social ou nome do Transportador
	DATA IETransp			AS STRING				// Inscrição Estadual do Transportador
	DATA Veiculos			AS ARRAY OF Veiculo		// Veículos do Transporte
	DATA Volumes			AS ARRAY OF Volume		// Volumes da nota
*/

ENDCLASS

WSSTRUCT TAG										// Estrutura genérica para registro de Tags

	DATA NomeTag			AS STRING				// Nome da Tag
	DATA TipoDado			AS STRING				// Tipo de conteúdo da TAG
	DATA ContString			AS STRING				// Conteúdo do tipo Texto
	DATA ContNumero			AS FLOAT				// Conteúdo do tipo Número
	DATA ContData			AS DATE					// Conteúdo do tipo Data
	DATA ContArray			AS ARRAY OF TAG			// Conteúdo do tipo Array

	WSMETHOD New
	WSMETHOD GetValor
	WSMETHOD SetValor

ENDWSSTRUCT



/*
WSSTRUCT Veiculo									// Registro de veículos
	DATA Tipo				AS STRING				// Veículo ou reboque
	DATA Placa				AS STRING				// Placa do veículo
	DATA UfVeiculo			AS STRING				// Sigla da UF
ENDWSSTRUCT

WSSTRUCT Volume										// Registro de volumes
	DATA qVol				AS FLOAT				// Quantidade de volumes transportados
	DATA esp				AS STRING				// Espécie dos volumes transportados
	DATA marca				AS STRING				// Marca dos volumes
	DATA nVol				AS STRING				// Numeração dos volumes
	DATA pesoL				AS FLOAT				// Peso Líquido (em kg)
	DATA pesoB				AS FLOAT				// Peso Bruto (em kg)

	METHOD New
ENDWSSTRUCT
*/
User Function TGMXML(cArqXml)

	Local cAviso:= ""
	Local cErro:= ""

	Default cArqXml:= "C:\Temp\NfeTransleone\31150212229415001001550010000948451867466177.xml"

	cXml:= MemoRead(cArqXml)
	oXml:= XmlParser(cXml,"_",@cAviso,@cErro)

	If (oXml == Nil) //Verifico se foi possivel criar o objeto oXML
		// Tenta tratar os caracteres especiais antes de importar
		cXml:= EncodeUTF8( cXml )
		If ValType(cXml) == "C"
			oXml	:= XmlParser(cXml,"_",@cAviso,@cErro)
		EndIf
		If (oXml == Nil) //Verifico se foi possivel criar o objeto oXML
//			lErroImp:= SfAddMsg( cArquivo, STR_ARQUIVOXMLINVALIDO )
			alert("Arquivo XML inválido!")
		Endif
	Endif
	If !Empty(cAviso)
//		lErroImp:= SfAddMsg( cArquivo, I18N(STR_FALHACRIACAO,{ cAviso }) )
		MsgInfo("Aviso:" + cAviso)
	EndIf
	If !Empty(cErro)
//		lErroImp:= SfAddMsg( cArquivo, I18N(STR_FALHACRIACAO,{ cErro }) )
		MsgInfo("Erro:" + cErro)
	EndIf

	cCgc:= SfXmlChild(oXml,'_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL')


	//TODO: Criar uma classe para leitura/parse correto de xml de notas e CT-e
	/*
		Método ler arquivo e método ler texto
		Mensagem de retorno de erro
		Alguns campos/tags são padrão e obrigatórios
		Alguns campos/tags podem ser solicitada obrigatoriedade via parâmetro do método de leitura (protocolo de autorização por exemplo)
		Alguns campos podem ser solicitados via campos da classe
		Outros campos complementares podem ser passados via campo array da classe

		Todos os campos que podem ser array na classe, retornarão Array
		Ao pedir o conteúdo de um campo, caso for array, pode-se pedir apenas o primeiro valor, ou apenas o primeiro valor preenchido (como o campo volume na transportadora)

		No futuro cruzar com o XSD para trazer sempre a nota completa

	*/


Return (cCgc)

//====================================================================================================================\\
/*/{Protheus.doc}SfXmlChild
  ====================================================================================================================
	@description
	Leitura de uma Tag XML

	@author		TSC681 Thiago Mota
	@version	1.0
	@since		28/02/2015

/*/
//===================================================================================================================\\
Static Function SfXmlChild( oXml, xTag, cTipRet, cResVal, xConteudo, lValido, nOpcArr, nI )
	Local xResult
	Local xRet
	Local aTag
	Local nLen
	Local lExit		:= .F.
	Local oNivelAt	:= oXml //TODO:Testar se é por referência

	Default cTipRet	:= "C"	// C = Caractere, A = Array, D = Data, N = Número, H = Hora
	Default cResVal	:= "R"	// V = Validação, R = Resultado
	Default lValido	:= .F.
	Default nOpcArr	:= 1	// 0 - Primeiro elemento, 1 - Primeiro elemento com valor
	Default nI		:= 1

	If Valtype(xTag)=="C"
		aTag:= StrToKarr( xTag, ":" )
	EndIf
	nLen:= Len(aTag)

	While !lExit .And. nI <= nLen
		If ! Empty( XmlChildEx(oNivelAt, aTag[nI] ) )
			oNivelAt:= XmlChildEx(oNivelAt, aTag[nI] )
			If ValType( oNivelAt )=="A" .And. nI < nLen

				For nJ:= 1 To Len(oNivelAt)
					xResult:= SfXmlChild(oNivelAt[nJ], xTag, cTipRet, cResVal, xConteudo, lValido, nOpcArr, nI+1)
					If nOpcArr == 0
						lExit:=.T.
					ElseIf nOpcArr == 1 .And. ! Empty(xResult)
						lExit:= .T.
					EndIf
				Next (nJ)

			ElseIf nI == nLen

				xResult:= oNivelAt
				If cTipRet != "A" .And. ValType(xResult)=="O" .And. ! Empty( XmlChildEx(xResult, 'TEXT' ) )
					xResult:= XmlChildEx(xResult, 'TEXT' )
				ElseIf cTipRet == "A" .And. ValType(xResult) == "O"
					xResult:= { xResult }
				EndIf
			EndIf

		Else
			lExit:= .T.
		EndIf
		nI++
	EndDo

	If xResult != Nil
		If cTipRet == "N"
			xResult:= Val(xResult)
		ElseIf cTipRet == "D"
			xResult:= Stod(StrTran(xResult,"-",""))
		ElseIf cTipRet == "H"
			If At("T",xResult) > 0
				xResult:= StrTran(SubStr( xResult, At("T",xResult)+1, 5 ),":","")
			EndIf
		EndIf

		xConteudo:= xResult
	EndIf

	If cResVal == "V"
		xRet:= lValido
	Else
		xRet:= xResult
	EndIf

Return ( xRet )
// FIM da Funcao SfXmlChild
//======================================================================================================================

