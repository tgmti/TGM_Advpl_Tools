#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite aJoinTests Description 'Testes da função aJoin' Verbose
    Feature VetorSimples Description 'Converte um vetor simples'
    // Feature Matriz Description 'Testa o uso do parâmetro lRecursive.'
EndTestSuite

Feature VetorSimples TestSuite aJoinTests
    Local aVetor := {2,"TESTE",.T.}
    Local cString:= U_aJoin( aVetor, "|" )

    ::Expect( ValType(cString) ):ToBe( "C" )
    ::Expect( cString ):ToBe( "2|TESTE|.T." )

Return 

CompileTestSuite aJoinTests
