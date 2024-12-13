
CONSULTA 1

CREATE INDEX idx_concorrente_consulta1 ON corrida USING brin(datapedido)
DROP INDEX idx_concorrente_consulta1
  
CONSULTA 2

CREATE INDEX idx_concorrente_consulta2 ON motorista USING brin(nome)
DROP INDEX idx_concorrente_consulta1


CONSULTA 3

CREATE INDEX idx_concorrente_consulta3 ON taxi USING brin (modelo)
DROP INDEX idx_concorrente_consulta3

CONSULTA 4


CREATE INDEX idx_concorrente_consulta4 ON taxi USING brin (modelo)
DROP INDEX idx_concorrente_consulta4

CONSULTA 5

CREATE INDEX idx_concorrente_consulta5 ON fila USING brin (zona)
DROP INDEX idx_concorrente_consulta5
