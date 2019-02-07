#INCLUDE 'PROTHEUS.CH'


//============================================================================\
/*/{Protheus.doc}aJoin
  ==============================================================================
    @description
    Implementação da Função Join para array de ADVPL
    O método join() junta todos os elementos de uma array em uma string.

    Array.prototype.join() do Javascript
    https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Array/join

    @author Thiago Mota
    @author mota.thiago@totvs.com.br
    @author https://github.com/tgmti/

    @version 1.0
    @since 29/01/2019

    @param aOrigin, Array, Array Original a ser avaliado
    @param [cSep], Caractere, Opcional. Caractere separador (padrão: "")
	@para [lRecursive], Lógico, Opcional. Indica se deve agir recursivamente em arrays filhos (padrão .T.)
    
    @return String, String com todos os elementos do Array

/*/
//============================================================================\
User Function aJoin( aOrigin, cSep, lRecursive )
Return aJoin(aOrigin, cSep, lRecursive)

Static Function aJoin( aOrigin, cSep, lRecursive )
    Local cRet:= ''
	Local nLenght:= Len(aOrigin)

	Default cSep:= ''
	Default lRecursive:= .T.

    aEval(aOrigin, {|uValue, nIndex| cRet += ;
		If( lRecursive .And. ValType(uValue) == "A", ;
			aJoin(uValue, cSep, lRecursive), ;
			AsString(uValue) ) + ;
		IIf(nIndex >= nLenght, '', cSep) ;
	})

Return ( cRet )
// FIM da Funcao aJoin
//==============================================================================


