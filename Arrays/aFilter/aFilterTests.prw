#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite aFilterTests Description 'Testes da função aFilter' Verbose
    Feature VetorSimples Description 'Filtros Basicos'
    Feature UtizaPosicao Description 'Converte os dados do vetor, utilizando os parametros posicao e original'
EndTestSuite

Feature VetorSimples TestSuite aFilterTests
    Local aFil1:= U_aFilter( { 12, 5, 8, 130, 44 }, {|x| x > 10 } )
    Local aFil2:= U_aFilter( { { 'PRODUTO1', 10, .T.},{'PRODUTO2',20,.F.},{'PRODUTO3',30,.T.} }, {|x| x[3] } )
    Local aFil3:= U_aFilter(aFil2, {|x| x[1] == 'PRODUTO3' })

    ::Expect( ValType(aFil1) ):ToBe( "A" )
    ::Expect( Len(aFil1) ):ToBe( 3 )
    ::Expect( aFil1[1] + aFil1[2] + aFil1[3] ):ToBe( 186 )
    
    ::Expect( ValType(aFil2) ):ToBe( "A" )
    ::Expect( Len(aFil2) ):ToBe( 2 )
    ::Expect( aFil2[1] ):ToBe( { 'PRODUTO1', 10, .T.} )
    ::Expect( aFil2[2] ):ToBe( {'PRODUTO3',30,.T.} )
    ::Expect( ValType(aFil2) ):ToBe( "A" )

    ::Expect( ValType(aFil3) ):ToBe( "A" )
    ::Expect( Len(aFil3) ):ToBe( 1 )
    ::Expect( aFil3[1] ):ToBe( {'PRODUTO3',30,.T.} )
    
Return


Feature UtizaPosicao TestSuite aFilterTests
    
    Local aVetor1 := { 1, 2, 3, 4, 5, 6}
    Local aVetor2:= { 1, 0, 3, 0, 0, 6}

    Local aFil1:= U_aFilter(aVetor1, {|x,y,z| z[y] == aVetor2[y] })

    ::Expect( ValType(aFil1) ):ToBe( "A" )
    ::Expect( Len(aFil1) ):ToBe( 3 )
    
    ::Expect( aFil1[1] ):ToBe( 1 )
    ::Expect( aFil1[2] ):ToBe( 3 )
    ::Expect( aFil1[3] ):ToBe( 6 )
    
Return


Return

CompileTestSuite aFilterTests
