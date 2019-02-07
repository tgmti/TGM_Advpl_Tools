#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}aFind
  ==============================================================================
    @description
    Retorna um elemento do array encontrado com aScan

    @author Thiago Mota
    @author mota.thiago@totvs.com.br
    @author https://github.com/tgmti/

    @version 1.0
    @since 29/01/2019

    @param aOrigin, Array, Array Original a ser avaliado
    @param bCallback, Bloco de Código, Função que ao ser executada por aScan retorna a posição do elemento no array
	@para  [uDefault], Numérico, Opcional. Define um valor padrão, caso não encontrar o elemento
	@para  [nIni], Numérico, Opcional. Define em que posição do Array inicia a busca (padrão: 1)
	@para  [nEnd], Numérico, Opcional. Define quantos elementos irá avaliar a partir de nIni (padrão: todos)
    
    @return Indefinido, Elemento ou valor default se infordo.

    @obs
        O Callback Recebe apenas o próprio elemento como parâmetro, semelhante ao aScan

	@example
		// Pode ser utilizado para facilitar a leitura de trechos assim:
		aItens:= {"XPTO"}
		
		xItem:= aItens[aScan(aItens, {|x| x[1] == "XPTO" })][1] // XPTO

		xItem:= aFind(aItens, {|x| x[1] == "XPTO" })[1] // XPTO

		E usando o Default, evitar erros
		xItem:= aFind(aItens, {|x| x[1] == "XPTY" }, {"ARRAY PADRAO"})[1] // ARRAY PADRAO


/*/
//============================================================================\
User Function aFind( aOrigin, bCallback, uDefault, nIni, nEnd )
Return aFind(aOrigin, bCallback, uDefault, nIni, nEnd)

Static Function aFind(aOrigin, bCallback, uDefault, nIni, nEnd)
    Local nPos:= aScan( aOrigin, bCallback, nIni, nEnd )
	Local uRet:= uDefault
	If nPos > 0
		uRet:= aOrigin[nPos]
	EndIf

Return ( uRet )
// FIM da Funcao aFind
//==============================================================================
