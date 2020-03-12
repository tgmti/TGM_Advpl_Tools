#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}aProduct
  ==============================================================================
    @description
    Implementação da funcionalidade Product para Vetores em ADVPL

    A função Product() retorna o produto cartesiano dos dados inputados
    O Produto cartesiano será um vetor do tamanho indicado, com todas as
    possibilidades de iterações entre os elementos do array de entrada.

    Inspirado no itertools.product(*iterables, repeat=1) do Python
    https://docs.python.org/pt-br/3/library/itertools.html#itertools.product

    Baseado nesta implementação para Javascript:
    https://gist.github.com/cybercase/db7dde901d7070c98c48

    @author Thiago Mota
    @author tgmspawn@gmail.com
    @author https://github.com/tgmti/

    @version 1.0
    @since 12/03/2020

    @param aIterables, Array, Array com os valores que devem constar no plano cartesiano
    @param nRepeat, Numérico, Quantidade de repetições, ou seja, tamanho dos arrays retornados

    @return Vetor, Cada linha será uma possibilidade de iteração entre os elementos do aIterables

    @obs
        Depende da Função aReduce

        O tamanho do Array para o plano cartesiano será igual a Len(aIterables) Elevado a nRepeat
        Ou seja, Product({0,1},3) Retornará 2^3 = 8 linhas com 3 posições cada:
            {00,00,00}
            {00,00,01}
            {00,01,00}
            {00,01,01}
            {01,00,00}
            {01,00,01}
            {01,01,00}
            {01,01,01}

        Já, Product({'A','B'},10) retorna 1024 linhas, com todas as possibilidades de 'A' e 'B'
        em 10 posições.
        Por conta disso, deve-se ter cuidado com as quantidades de iterações e repetições

        //TODO: Realizar testes de limites do ADVPL para documentar quais os máximos suportados nesta abordagem

/*/
//============================================================================\
User Function aProduct( aIterables, nRepeat )
Return aProduct( aIterables, nRepeat )

Static Function aProduct( aIterables, nRepeat )

    Local aRet
    Local aCopies:= {}
    Local nX

    Default nRepeat:= 1

    For nX:= 1 To nRepeat
        aAdd(aCopies, AClone(aIterables))
    Next nX

    aRet:= U_aReduce(aCopies, {|nAcc, uVal| FlatVet(nAcc, uVal) }, {{}})

Return aRet

// Função auxiliar para aProduct
Static Function FlatVet(nAcc, uVal)
    Local aTmp:= {}
    Local aConcat
    Local nY
    Local nZ

    For nY:= 1 To Len(nAcc)
        For nZ:= 1 To Len(uVal)
            aAdd(aTmp, aClone(nAcc[nY]))
            aAdd(aTail(aTmp), uVal[nZ])
        Next nZ
    Next nY

Return aTmp
// FIM da Funcao aProduct
//==============================================================================

