
CONSULTA 1 

CREATE INDEX idx_gist_consulta1 ON corrida USING gist (datapedido gist_trgm_ops)
DA MESMA MANEIRA QUE NO GIN NÃO FOI POSSIVEL GERAR O ÍNDICE, O GIST SEGUE A MESMA PREMISSA

CONSULTA 2

CREATE INDEX idx_gist_consulta2 ON motorista USING gist (nome gist_trgm_ops)
DROP INDEX idx_gist_consulta2

CONSULTA 3

CREATE INDEX idx_gist_consulta3 ON taxi USING gist (modelo gist_trgm_ops)
DROP INDEX idx_gist_consulta3

CONSULTA 4

CREATE INDEX idx_gist_consulta4 ON taxi USING gist (placa gist_trgm_ops)
DROP INDEX idx_gist_consulta4

CONSULTA 5

CREATE INDEX idx_gist_consulta5 ON fila USING gist (zona gist_trgm_ops)
DROP INDEX idx_gist_consulta5
