
CONSULTA 1

CREATE INDEX CONCURRENTLY idx_concorrente_consulta1 ON corrida (datapedido)
DROP INDEX idx_concorrente_consulta1
  
CONSULTA 2

CREATE INDEX CONCURRENTLY idx_concorrente_consulta2 ON motorista (nome)
DROP INDEX idx_concorrente_consulta1


CONSULTA 3

CREATE INDEX CONCURRENTLY idx_concorrente_consulta3 ON taxi (modelo)
DROP INDEX idx_concorrente_consulta3

CONSULTA 4


CREATE INDEX CONCURRENTLY idx_concorrente_consulta4 ON taxi (modelo)
DROP INDEX idx_concorrente_consulta4

CONSULTA 5

CREATE INDEX CONCURRENTLY idx_concorrente_consulta5 ON fila (zona)
DROP INDEX idx_concorrente_consulta5
