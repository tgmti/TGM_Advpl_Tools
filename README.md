# Ferramentas úteis para utilização com ADVPL

## Manipulação de Array

[aMap](./ArrayUtils/aMap/) -  O método map() invoca a função callback passada por argumento para cada elemento do Array e devolve um novo Array como resultado.

[aFilter](./ArrayUtils/aFilter/) - O método filter() cria um novo array com todos os elementos que passaram no teste implementado pela função fornecida.

[ValArray](./ArrayUtils/ValArray.prw/) - Recuperar informação dentro de um Array, validando se existem as posições passadas.

## [Classe de Valor Automática](./Classe%20de%20valor%20Automatica/)

Funções e pontos de entrada para sincronizar cadastro de clientes e fornecedores com cadastro de classes de valor.

## [Compatibilizador Customizado](./Compatibilizador%20Customizado/)

Classe para criação de Compabilizador que facilita o deploy de customizações

## [Consulta Borderos](./Consulta%20Borderos/)

Consulta em MVC para a tabela de Títulos enviados ao banco (SEA)

## [Consulta Sinesp Python](./Consulta%20Sinesp%20Python/)

Consulta de placas utilizando Python.

## [Editar SX5 - Tabelas Genéricas](./Editar%20SX5%20-%20Tabelas%20Genéricas/EDITASX5_MVC.prw)

Rotina em MVC para poder liberar a consulta e edição de tabelas genéricas (SX5)

## Funções Auxiliares

[fnWhereFil.prw](./Funções%20Auxiliares/fnWhereFil.prw) - Retorna as clausulas Where corretas para filtro de várias filiais

[FuncRPO.prw](./Funções%20Auxiliares/FuncRPO.prw) - Lista de funcoes do RPO.

[PUTSX1.prw](./Funções%20Auxiliares/PUTSX1.prw) - PutSX1 para a V12.

[SHELLADVPL.prw](./Funções%20Auxiliares/SHELLADVPL.prw) - Tela auxiliar para avaliação de expressões no Protheus.

[TINI.prw](./Funções%20Auxiliares/TINI.prw) - Inicializador padrão com poucos parâmetros, útil para quando o inicializador não cabe no X3.

[TPOS.prw](./Funções%20Auxiliares/TPOS.prw) - Posicione com poucos parâmetros, útil para usar em inicializadores com poucos caracteres de espaço.

## Leitura de XML

[TGETMSG](./Leitura%20de%20XML/TGETMSG.prw) - Recebe uma Mensagem e uma lista de parâmetros e retorna os dados encontrados. Útil para buscar dados em Tags de observação/informações complementares.

[TGETOXML](./Leitura%20de%20XML/TGETOXML.prw) - Abre um arquivo indicado e converte para XML.

[XmlChild](./Leitura%20de%20XML/XmlChild.prw) - Facilitador para Leitura de Tag XML.

## Logs

[GravaLog](./Logs/GravaLog.prw) - Função para centralizar logs.

## Mile

[MileImp](./Mile/MileImp.prw) - Rotina para facilitar a criação de modelos customizados na importação do Mile

## NF-e

[GerXMLNFe](./NF-e/GerXMLNFe.prw) - Exporta o XML da NF-e (saída e entrada), CT-e ou MDF-e, usando as funções padrão de transmissão. Útil para validar e depurar a geração do XML sem precisar transmitir para a SEFAZ.

## Usuarios no Banco de Dados

[TUSUXBCO](./Usuarios%20Banco%20de%20Dados/TUSUXBCO.prw) - Copia o cadastro de usuário para uma tabela no banco de dados

## ValidaCNH

[ValidaCNH](./ValidaCNH/CNHValid.PRW) - Validação do número da CNH

## WFWEBRelatorio

[WFWEBRelatorio](./WFWebRelatorio/WFWEBRelatorio.prw) - Classe que extende TWFProcess com Funções úteis para geração de relatório gráfico utilizando HTML.
