#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite aMapTests Description 'Testes da função aMap' Verbose
    Feature VetorSimples Description 'Converte os dados de um Vetor simples'
    Feature UtizaPosicao Description 'Converte os dados do vetor, utilizando os parametros posicao e original'
    Feature MudaMatriz Description 'Converte dois vetores em uma Matriz de registros no formato para execauto'
EndTestSuite

Feature VetorSimples TestSuite aMapTests
    Local aVetor := {2,4,6,8}
    
    aNovo:= U_aMap( aVetor, {|x| x*2 } )

    ::Expect( ValType(aNovo) ):ToBe( "A" )
    ::Expect( Len(aNovo) ):ToBe( 4 )
    ::Expect( aNovo[1] ):ToBe( 04 )
    ::Expect( aNovo[2] ):ToBe( 08 )
    ::Expect( aNovo[3] ):ToBe( 12 )
    ::Expect( aNovo[4] ):ToBe( 16 )
Return


Feature UtizaPosicao TestSuite aMapTests
    Local aVetor := {'A','B','C','D'}
    
    aNovo:= U_aMap( aVetor, {|x,y,z| cRet:= 'Posicao: ' + cValToChar(y), ;
        cRet+= ', Conteudo: ' + x , ;
        cRet+= ', Anterior: ' + z[y], ;
        cRet ;
     } )

    ::Expect( ValType(aNovo) ):ToBe( "A" )
    ::Expect( Len(aNovo) ):ToBe( 4 )
    ::Expect( aNovo[1] ):ToBe( 'Posicao: 1, Conteudo: A, Anterior: A' )
    ::Expect( aNovo[2] ):ToBe( 'Posicao: 2, Conteudo: B, Anterior: B' )
    ::Expect( aNovo[3] ):ToBe( 'Posicao: 3, Conteudo: C, Anterior: C' )
    ::Expect( aNovo[4] ):ToBe( 'Posicao: 4, Conteudo: D, Anterior: D' )
    
Return


Feature MudaMatriz TestSuite aMapTests

    Local aCampos  := { "C6_NUM", "C6_PRODUTO", "C6_DATA", "C6_VALOR" }
    Local aValores := {}

    aAdd( aValores, {"000001", "0001", Stod("20191201"), 10 } )
    aAdd( aValores, {"000002", "0002", Stod("20191202"), 20 } )
    
    aNovo:= U_aMap( aValores, {|x| aLinha:= x, U_aMap( aCampos, {|cCampo, nCol| { cCampo, aLinha[nCol], Nil } } ) } )

    ::Expect( ValType(aNovo) ):ToBe( "A" )
    ::Expect( Len(aNovo) ):ToBe( 2 )
    ::Expect( ValType(aNovo[1]) ):ToBe( "A" )
    ::Expect( Len(aNovo[1]) ):ToBe( 4 )
    ::Expect( ValType(aNovo[1,1]) ):ToBe( "A" )

    /*
        Resultado esperado são dois regitros no formato de ExecAuto para linhas
        {
            { "C6_NUM", "000001", Nil }
            { "C6_PRODUTO", "0001", Nil }
            {"C6_DATA", Stod("20191201"), Nil }
            {"C6_VALOR", 10 , Nil }
        }


    */

    ::Expect( Len(aNovo[1,1]) ):ToBe( 3 )
    ::Expect( aNovo[1,1,1] ):ToBe( "C6_NUM" )
    ::Expect( aNovo[1,1,2] ):ToBe( "000001" )
    ::Expect( aNovo[1,2,1] ):ToBe( "C6_PRODUTO" )
    ::Expect( aNovo[1,3,2] ):ToBe( Stod("20191201") )
    ::Expect( aNovo[1,4,2] ):ToBe( 10 )

    ::Expect( Len(aNovo[2,1]) ):ToBe( 3 )
    ::Expect( aNovo[2,1,1] ):ToBe( "C6_NUM" )
    ::Expect( aNovo[2,1,2] ):ToBe( "000002" )
    ::Expect( aNovo[2,2,1] ):ToBe( "C6_PRODUTO" )
    ::Expect( aNovo[2,3,2] ):ToBe( Stod("20191202") )
    ::Expect( aNovo[2,4,2] ):ToBe( 20 )

Return

CompileTestSuite aMapTests
