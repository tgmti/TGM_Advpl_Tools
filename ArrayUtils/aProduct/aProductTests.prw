#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite TESTaProd Description 'Testes da função aProduct' Verbose
    Feature Vetor2_3 Description 'Produto de um vetor com 2 posições e 3 elementos'
    Feature Vetor3_3 Description 'Produto de um vetor com 3 posições e 3 elementos'
    Feature VetorMax Description 'Teste do Maior vetor suportado'
EndTestSuite

Feature Vetor2_3 TestSuite TESTaProd
    Local aIterables:= {0,1}
    Local nRepeat:= 3
    Local aProduct:= U_aProduct( aIterables, nRepeat )
    /*
    {00,00,00}
    {00,00,01}
    {00,01,00}
    {00,01,01}
    {01,00,00}
    {01,00,01}
    {01,01,00}
    {01,01,01}
    */

    ::Expect( Len(aProduct) ):ToBe( 8 )

    ::Expect( aProduct[1,1] ):ToBe( 00 )
    ::Expect( aProduct[1,2] ):ToBe( 00 )
    ::Expect( aProduct[1,3] ):ToBe( 00 )
    ::Expect( aProduct[2,1] ):ToBe( 00 )
    ::Expect( aProduct[2,2] ):ToBe( 00 )
    ::Expect( aProduct[2,3] ):ToBe( 01 )
    ::Expect( aProduct[3,1] ):ToBe( 00 )
    ::Expect( aProduct[3,2] ):ToBe( 01 )
    ::Expect( aProduct[3,3] ):ToBe( 00 )
    ::Expect( aProduct[4,1] ):ToBe( 00 )
    ::Expect( aProduct[4,2] ):ToBe( 01 )
    ::Expect( aProduct[4,3] ):ToBe( 01 )
    ::Expect( aProduct[5,1] ):ToBe( 01 )
    ::Expect( aProduct[5,2] ):ToBe( 00 )
    ::Expect( aProduct[5,3] ):ToBe( 00 )
    ::Expect( aProduct[6,1] ):ToBe( 01 )
    ::Expect( aProduct[6,2] ):ToBe( 00 )
    ::Expect( aProduct[6,3] ):ToBe( 01 )
    ::Expect( aProduct[7,1] ):ToBe( 01 )
    ::Expect( aProduct[7,2] ):ToBe( 01 )
    ::Expect( aProduct[7,3] ):ToBe( 00 )
    ::Expect( aProduct[8,1] ):ToBe( 01 )
    ::Expect( aProduct[8,2] ):ToBe( 01 )
    ::Expect( aProduct[8,3] ):ToBe( 01 )

Return

Feature Vetor3_3 TestSuite TESTaProd
    Local aIterables:= {'A','B','C'}
    Local nRepeat:= 3
    Local aProduct:= U_aProduct( aIterables, nRepeat )
    Local nX
    Local nSpec:= 27
    Local aSpected:= { ;
          {'A','A','A'} , {'A','A','B'} , {'A','A','C'} , {'A','B','A'} , {'A','B','B'} ;
        , {'A','B','C'} , {'A','C','A'} , {'A','C','B'} , {'A','C','C'} , {'B','A','A'} ;
        , {'B','A','B'} , {'B','A','C'} , {'B','B','A'} , {'B','B','B'} , {'B','B','C'} ;
        , {'B','C','A'} , {'B','C','B'} , {'B','C','C'} , {'C','A','A'} , {'C','A','B'} ;
        , {'C','A','C'} , {'C','B','A'} , {'C','B','B'} , {'C','B','C'} , {'C','C','A'} ;
        , {'C','C','B'} ;
        , {'C','C','C'} ;
    }

    ::Expect( Len(aProduct) ):ToBe( nSpec )

    For nX:= 1 To nSpec
        ::Expect( aProduct[nX,1] ):ToBe( aSpected[nX,1] )
        ::Expect( aProduct[nX,2] ):ToBe( aSpected[nX,2] )
        ::Expect( aProduct[nX,3] ):ToBe( aSpected[nX,3] )
    Next nX

Return

// TODO: Testar com mais dados - Consumo de memória e processamento foram bastante pesados
Feature VetorMax TestSuite TESTaProd
    Local aIterables:= {.T.,.F.}
    Local nRepeat:= 20
    Local aProduct:= U_aProduct( aIterables, nRepeat )
    Local nSpec:= Len(aIterables) ^ nRepeat

    ::Expect( Len(aProduct) ):ToBe( nSpec )

Return

CompileTestSuite TESTaProd
