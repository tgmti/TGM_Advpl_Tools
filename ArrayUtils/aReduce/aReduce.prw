#INCLUDE 'PROTHEUS.CH'


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


