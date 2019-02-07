#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite aReduceTests Description 'Testes da função aReduce' Verbose
    Feature VetorSimples Description 'Soma dados de um Vetor Simples'
    Feature UtizaPosicao Description 'Soma dados utilizando os parametros posicao, original e InitValue.'
    Feature SomaMatriz Description 'Soma dados de um Array com múltiplas dimensões.'
EndTestSuite

Feature VetorSimples TestSuite aReduceTests
    Local aVetor := {2,4,6,8}
    Local nNovo:= U_aReduce( aVetor ) // Default do CallBack é {|x,y| x+y }

    ::Expect( ValType(nNovo) ):ToBe( "N" )
    ::Expect( nNovo ):ToBe( 20 )
Return


Feature UtizaPosicao TestSuite aReduceTests
    Local aVetor := {2,4,6,8}
	Local nInit  := 5
	Local nNovo:= U_aReduce( aVetor, {|nAcc,uVal,nIdx,aOri| nAcc + aOri[nIdx] }, nInit )

    ::Expect( ValType(nNovo) ):ToBe( "N" )
    ::Expect( nNovo ):ToBe( 25 )
    
Return


Feature SomaMatriz TestSuite aReduceTests

    Local aMatriz  := {{'A',2},{'B',4},{'C',6},{'D',8}}
    Local nNovo:= U_aReduce(aMatriz, {|nAcc, uVal| nAcc + uVal[2] })

    ::Expect( ValType(nNovo) ):ToBe( "N" )
    ::Expect( nNovo ):ToBe( 20 )

Return

CompileTestSuite aReduceTests
