#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}aFilter
  ==============================================================================
    @description
    Implementação da Função Filter para ADVPL
    O método filter() cria um novo array com todos os elementos que passaram
    no teste implementado pela função fornecida.

    Inspirado no ArrayUtils.filter do Javascript moderno
    https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Array/filtro

    @author Thiago Mota
    @author tgmspawn@gmail.com
    @author mota.thiago@totvs.com.br
    @author https://github.com/tgmti/

    @version 1.0
    @since 23/01/2019

    @param aOrigin, Array, Array Original a ser avaliado
    @param bCallback, Bloco de Código, Função que ao ser executada por Eval() testa se o elemento
        deverá compor o novo Array.

    @return Array, Novo Array com os elementos que passaram no teste.

    @obs
        O Callback Recebe três argumentos:
        1 - uValue, Qualquer, O elemento que está sendo processado no array.
        2 - nIndex, Número, O índice do elemento atual que está sendo processado no array.
        3 - aOrigin, Array, O array para qual filter foi chamada.


/*/
//============================================================================\
User Function aFilter( aOrigin, bCallback )
Return aFilter(aOrigin, bCallback)

Static Function aFilter( aOrigin, bCallback )
    Local aDestiny:= {}

    aEval(aOrigin, {|uValue, nIndex| If(Eval(bCallback, uValue, nIndex, aOrigin),aAdd(aDestiny, uValue),Nil) })

Return ( aDestiny )
// FIM da Funcao aFilter
//==============================================================================



//============================================================================\
/*/{Protheus.doc}aFind
  ==============================================================================
    @description
    Retorna um elemento do array encontrado com aScan

    @author Thiago Mota
    @author tgmspawn@gmail.com
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



//============================================================================\
/*/{Protheus.doc}aJoin
  ==============================================================================
    @description
    Implementação da Função Join para array de ADVPL
    O método join() junta todos os elementos de uma array em uma string.

    Array.prototype.join() do Javascript
    https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Array/join

    @author Thiago Mota
    @author tgmspawn@gmail.com
    @author mota.thiago@totvs.com.br
    @author https://github.com/tgmti/

    @version 1.0
    @since 29/01/2019

    @param aOrigin, Array, Array Original a ser avaliado
    @param [cSep], Caractere, Opcional. Caractere separador (padrão: "")
	@para [lRecursive], Lógico, Opcional. Indica se deve agir recursivamente em arrays filhos (padrão .T.)

    @return String, String com todos os elementos do Array

/*/
//============================================================================\
User Function aJoin( aOrigin, cSep, lRecursive )
Return aJoin(aOrigin, cSep, lRecursive)

Static Function aJoin( aOrigin, cSep, lRecursive )
    Local cRet:= ''
	Local nLenght:= Len(aOrigin)

	Default cSep:= ''
	Default lRecursive:= .T.

    aEval(aOrigin, {|uValue, nIndex| cRet += ;
		If( lRecursive .And. ValType(uValue) == "A", ;
			aJoin(uValue, cSep, lRecursive), ;
			AsString(uValue) ) + ;
		IIf(nIndex >= nLenght, '', cSep) ;
	})

Return ( cRet )
// FIM da Funcao aJoin
//==============================================================================



//============================================================================\
/*/{Protheus.doc}aMap
  ==============================================================================
    @description
    Implementação da Função Map para ADVPL
    O método map() invoca a função callback passada por argumento para cada
    elemento do Array e devolve um novo Array como resultado.

    Inspirado no ArrayUtils.map do Javascript moderno
    https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Array/map

    @author Thiago Mota
    @author tgmspawn@gmail.com
    @author mota.thiago@totvs.com.br
    @author https://github.com/tgmti/

    @version 1.0
    @since 24/01/2019

    @param aOrigin, Array, Array Original a ser avaliado
    @param bCallback, Bloco de Código, Função que ao ser executada por Eval() produz o elemento do novo Array.

    @return Array, Novo Array com as modificações

    @obs
        O Callback Recebe três argumentos:
        1 - uValue, Qualquer, O elemento que está sendo processado no array.
        2 - nIndex, Número, O índice do elemento atual que está sendo processado no array.
        3 - aOrigin, Array, O array para qual map foi chamada.
        4 - aDestiny, Array   , O novo array que será retornado.

/*/
//============================================================================\
User Function aMap( aOrigin, bCallback )
Return aMap(aOrigin, bCallback)

Static Function aMap( aOrigin, bCallback )
    Local aDestiny:= {}

    aEval(aOrigin, {|uValue,nIndex| aAdd(aDestiny, Eval(bCallback, uValue, nIndex, aOrigin, aDestiny)) })

Return ( aDestiny )
// FIM da Funcao aMap
//==============================================================================



//============================================================================\
/*/{Protheus.doc}aReduce
  ==============================================================================
    @description
    Implementação da Função Reduce para ADVPL
    O método reduce()executa uma função reducer (provida por você) para cada
	membro do array, resultando num único valor de retorno.

    Inspirado no ArrayUtils.reduce do Javascript moderno
    https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce

    @author Thiago Mota
    @author tgmspawn@gmail.com
    @author mota.thiago@totvs.com.br
    @author https://github.com/tgmti/

    @version 1.0
    @since 29/01/2019

    @param aOrigin, Array, Array Original a ser avaliado
    @param bCallback, Bloco de Código, Função que ao ser executada por Eval() executa o acumulador. Valor Padrão {|x,y| x+y }
	@para [uInitValue], Indefinido, Opcional. Valor inicial na primeira execução. Valor padrão: 0

    @return Indefinido, Valor final do acumulador, o tipo retornado depende da função callback

    @obs
        O Callback Recebe quatro argumentos:
        1 - uAcumulator, Qualquer, O elemento que será retornado.
        1 - uValue, Qualquer, O elemento que está sendo processado no array.
        2 - nIndex, Número, O índice do elemento atual que está sendo processado no array.
        3 - aOrigin, Array, O array para qual map foi chamada.

/*/
//============================================================================\
User Function aReduce( aOrigin, bCallback, uInitValue )
Return aReduce(aOrigin, bCallback, uInitValue)

Static Function aReduce( aOrigin, bCallback, uInitValue )
    Local uAcumulator
	Default bCallback:= {|nAcc, uVal| nAcc + uVal }
	Default uInitValue:= 0

	uAcumulator:= uInitValue

    aEval(aOrigin, {|uValue,nIndex| uAcumulator:= Eval(bCallback, uAcumulator, uValue, nIndex, aOrigin) })

Return ( uAcumulator )
// FIM da Funcao aReduce
//==============================================================================

