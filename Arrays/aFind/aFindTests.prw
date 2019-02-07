#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite aFindTests Description 'Testes da função aFind' Verbose
    Feature TestaElemento Description 'Teste Simples'
EndTestSuite

Feature TestaElemento TestSuite aFindTests
    Local aMatriz := {}

    aAdd( aMatriz, {"000001", "0001", Stod("20191201"), 10 } )
    aAdd( aMatriz, {"000002", "0002", Stod("20191202"), 20 } )
    aAdd( aMatriz, {"000003", "0003", Stod("20191203"), 30 } )

	aVetor:= U_aFind(aMatriz, {|x| x[2]=="0002" })
	nValor:= aVetor[4]

    ::Expect( ValType(aVetor) ):ToBe( "A" )
    ::Expect( nValor ):ToBe( 20 )

	// Testa a referência
	aVetor[4]:= 40
    ::Expect( aMatriz[2][4] ):ToBe( 40 )
	
	aVetor:= U_aFind(aMatriz, {|x| x[2]=="0004" }, {,,,50})
	nValor:= aVetor[4]
    ::Expect( nValor ):ToBe( 50 )


Return


CompileTestSuite aFindTests
