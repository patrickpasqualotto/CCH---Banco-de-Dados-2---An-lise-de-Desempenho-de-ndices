
CONSULTA 1
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta1 ON corrida USING gin (datapedido gin_trgm_ops)
ESSE INDÍCE NÃO VAI FUNCIONAR PORQUE NA CONSULTA UM TEMOS UM WHERE BUSCANDO POR DADOS DO TIPO NUMERIC E NO GIN ELE UTILIZA TEXTO(VARCHAR) COMO PARÂMETRO

  
CONSULTA 2

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta2 ON motorista USING gin (nome gin_trgm_ops)
DROP INDEX idx_gin_consulta2
  
CONSULTA 3

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta3 ON taxi USING gin (modelo gin_trgm_ops)
DROP INDEX idx_gin_consulta3

CONSULTA 4

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta4 ON taxi USING gin (placa gin_trgm_ops)
DROP INDEX idx_gin_consulta4
 
CONSULTA 5

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta5 ON fila USING gin (zona gin_trgm_ops)
DROP INDEX idx_gin_consulta5
