CONSULTA 1

CREATE INDEX idx_hash_consulta1 ON corrida USING hash (datapedido);
DROP INDEX idx_hash_consulta1

CONSULTA 2 

CREATE INDEX idx_hash_consulta2 ON motorista USING hash (nome);
DROP INDEX idx_hash_consulta2

CONSULTA 3

CREATE INDEX idx_hash_consulta3 ON taxi USING hash (modelo);
DROP INDEX idx_hash_consulta3
  
CONSULTA 4

CREATE INDEX idx_hash_consulta4 ON taxi USING hash (placa);
DROP INDEX idx_hash_consulta4
  
CONSULTA 5

CREATE INDEX idx_hash_consulta5 ON fila USING hash (zona);
DROP INDEX idx_hash_consulta5
