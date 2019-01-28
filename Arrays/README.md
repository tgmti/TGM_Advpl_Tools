# ArrayUtils - Manipulação de Array

## aFilter

Inpirado no Array.Filter do Javascript, permite retornar uma cópia do array original, filtrando apenas os elementos que passarem em um teste.

Exemplo:
    Local aFil1:= U_aFilter( { 12, 5, 8, 130, 44 }, {|x| x > 10 } )
    // Resultado: {12,130,44}

## aMap

Inpirado no Array.Map do Javascript, permite retornar uma cópia do array original, porém com as posições modificadas conforme necessidade do desenvolvedor.

Exemplo:
    aOriginal:= {2,4,6,8}
    aModificado:= aMap(aOriginal, {|x| x*2 })
    // Resultado: {4,8,12,16}

> Obs: Testes implementados com https://github.com/nginformatica/advpl-testsuite