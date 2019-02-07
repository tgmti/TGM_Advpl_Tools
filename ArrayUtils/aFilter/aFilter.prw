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


