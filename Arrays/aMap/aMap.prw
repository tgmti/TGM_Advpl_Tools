#INCLUDE 'PROTHEUS.CH'


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

/*/
//============================================================================\
User Function aMap( aOrigin, bCallback )
Return aMap(aOrigin, bCallback)

Static Function aMap( aOrigin, bCallback )
    Local aDestino:= {}

    aEval(aOrigin, {|uValue,nIndex| aAdd(aDestino, Eval(bCallback, uValue, nIndex, aOrigin)) })

Return ( aDestino )
// FIM da Funcao aMap
//==============================================================================


