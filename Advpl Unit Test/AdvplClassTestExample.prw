#Include 'protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} AdvplClassTestExample
Classe de testes | Exemplo

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Class AdvplClassTestExample From FWDefaultTestCase
	Method AdvplClassTestExample()

    //Métodos especias
    Method SetUp()
    Method SetUpClass()
    Method TearDown()
    Method TearDownClass()

    //Métodos de teste
	Method MTrue()
    Method MFalse()
    Method MEqual()
    Method MNotEqual()
    Method MError()
    Method MSkip()
EndClass

//-------------------------------------------------------------------
/*/{Protheus.doc} AdvplClassTestExample
Método de instância da classe de testes

Obs.: O método de instância deve ter o mesmo nome da classe!
	
@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method AdvplClassTestExample() Class AdvplClassTestExample
    //Adição dos métodos default
	_Super:FWDefaultTestCase()

    //Adição dos métodos de teste
	Self:AddTestMethod( "MTrue"     ,, "AssertTrue"     )
    Self:AddTestMethod( "MFalse"    ,, "AssertFalse"    )
    Self:AddTestMethod( "MEqual"    ,, "AssertEqual"    )
    Self:AddTestMethod( "MNotEqual" ,, "AssertNotEqual" )
    Self:AddTestMethod( "MSkip"     ,, "Skip"           )

    //Adição de método de teste que espera um error.log
    Self:AddTestMethod( "MError" , .T. , "AssertNotEquals" )
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} SetUp
Método que é chamado antes de cada teste, podendo ser chamado N vezes

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method SetUp() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()

Return oResult

//-------------------------------------------------------------------
/*/{Protheus.doc} SetUpClass
Método que é chamado antes de inicializar os testes da Classe,
sendo assim esse método é chamado somente uma vez

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method SetUpClass() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()

Return oResult

//-------------------------------------------------------------------
/*/{Protheus.doc} TearDown
Método que é chamado após cada teste, podendo ser chamado N vezes

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method TearDown() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()

Return oResult

//-------------------------------------------------------------------
/*/{Protheus.doc} TearDownClass
Método que é chamado após a finalização dos testes da Classe,
sendo assim esse método é chamado somente uma vez

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method TearDownClass() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()

Return oResult

//-------------------------------------------------------------------
/*/{Protheus.doc} MTrue
Método que de teste que utilizada de resultado positivo ( .T. )

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method MTrue() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()
oResult:AssertTrue( .T. )

Return oResult

//-------------------------------------------------------------------
/*/{Protheus.doc} MFalse
Método que de teste que utilizada de resultado negativo ( .F. )

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method MFalse() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()

oResult:AssertFalse( .F. )

Return oResult

//-------------------------------------------------------------------
/*/{Protheus.doc} MEqual
Método que de teste que utilizada de igualdade

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method MEqual() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()

oResult:AssertEqual( 'X' , 'X' )

Return oResult

//-------------------------------------------------------------------
/*/{Protheus.doc} MNotEqual
Método que de teste que utilizada de diferença

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method MNotEqual() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()

oResult:AssertNotEqual( 'X' , 'T' )

Return oResult

//-------------------------------------------------------------------
/*/{Protheus.doc} MSkip
Método que de teste que deixa de ser executado

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method MSkip() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()

oResult:Skip()

Return oResult

//-------------------------------------------------------------------
/*/{Protheus.doc} MError
Método que de teste que utilizada de error.log (Exceção)

@author Daniel Mendes
@since Jul 31, 2018
@version 12
/*/
//-------------------------------------------------------------------
Method MError() Class AdvplClassTestExample
Local oResult As Object

oResult := FWTestResult():FWTestResult()

//Gero algum error.log

If aNotExists[0] == aExistsNot
EndIf

If lNotFound == 9
EndIf

If 'AAAAA' == 8
EndIf

Return oResult