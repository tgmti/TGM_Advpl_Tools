# https://github.com/victor-torres/sinesp-client/
# pip install sinesp-client
# Python instalado na versão 2.8.1 ou superior

from sinesp_client import SinespClient
import json
import sys

placa = str(sys.argv[1])

sc = SinespClient()

result = sc.search(placa)
resjson = json.dumps(result)

cfile = "C:\\temp\\placas\\" + placa + ".json"

try:
    arquivo = open(cfile, 'w')
except FileNotFoundError:
    arquivo = open(cfile, 'w')

arquivo.writelines(resjson)
arquivo.close()
