--mostre o nome de todos os motoristas que possuem o digito 0 na placa de seus táxis
SELECT 
    m.Nome,
    t.Modelo,
    t.Marca,
    t.Placa
FROM 
    Taxi t
JOIN 
    Motorista m ON t.placa = m.placa
WHERE 
    t.Placa LIKE '%0%';
	
	
-- criação do primeiro indice btree(padrão)

CREATE INDEX idx_padrao_consulta4 ON taxi (placa);
DROP INDEX idx_padrao_consulta4;

-- indice 2 hash

CREATE INDEX idx_hash_consulta4 ON taxi USING hash (placa);
DROP INDEX idx_hash_consulta4

-- indice 3 gin
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta4 ON taxi USING gin (placa gin_trgm_ops)
DROP INDEX idx_gin_consulta4
-- indice 4 gin 
CREATE INDEX idx_gist_consulta4 ON taxi USING gist (placa gist_trgm_ops)
DROP INDEX idx_gist_consulta4-- criação da tabela que vai armazenar os dados do indice

--indice 5 concorrente
CREATE INDEX CONCURRENTLY idx_concorrente_consulta4 ON taxi (modelo)
DROP INDEX idx_concorrente_consulta4

-- CRIAÇÃO DAS TABELAS
CREATE TABLE tempos_execucao_consulta4_comindice (
    execucao_num INT,
    tempo_ms NUMERIC
);

-- executar isso para dropar os dados armazenados da consulta anterior que está considerando os dados do outro indice
DROP TABLE tempos_execucao_consulta4_comindice;

CREATE OR REPLACE FUNCTION medir_tempo_execucao_consulta4_comindice()
RETURNS VOID AS $$
DECLARE
    inicio TIMESTAMP;
    fim TIMESTAMP;
    tempo_execucao NUMERIC; 
    i INT;
BEGIN
    FOR i IN 1..100 LOOP
        inicio := clock_timestamp();
        PERFORM 
            SELECT 
				m.Nome,
				t.Modelo,
				t.Marca,
				t.Placa
			FROM 
				Taxi t
			JOIN 
				Motorista m ON t.placa = m.placa
			WHERE 
				t.Placa LIKE '%0%';

        fim := clock_timestamp();
		tempo_execucao := EXTRACT(MILLISECOND FROM (fim - inicio));		
        INSERT INTO tempos_execucao_consulta4_comindice (execucao_num, tempo_ms)
        VALUES (i, tempo_execucao);
    END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT medir_tempo_execucao_consulta4_comindice();

select*from tempos_execucao_consulta4_comindice;

SELECT 
    AVG(tempo_ms) AS tempo_medio,
    MIN(tempo_ms) AS tempo_minimo,
    MAX(tempo_ms) AS tempo_maximo
FROM tempos_execucao_consulta4_comindice;
drop table tempos_execucao_consulta4_comindice;