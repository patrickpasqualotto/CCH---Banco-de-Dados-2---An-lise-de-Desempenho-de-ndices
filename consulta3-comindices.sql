-- consulta 3 
--aqui vamos procurar por todos os motoristas que possuem um taxi do modelo onix e trazer quantas corridas eles realizaram

SELECT 
    M.Nome AS Motorista,
    T.Modelo AS Modelo,
    COUNT(C.CliId) AS TotalCorridas
FROM 
    Taxi T
JOIN 
    Motorista M ON T.Placa = M.Placa
LEFT JOIN 
    Corrida C ON M.Placa = C.Placa
WHERE 
    T.Modelo = 'Onix'
GROUP BY 
    M.Nome, T.Modelo;
	
-- criação do primeiro indice btree(padrão)

CREATE INDEX idx_padrao_consulta3 ON taxi (modelo);
DROP INDEX idx_padrao_consulta3;

-- indice 2 hash

CREATE INDEX idx_hash_consulta3 ON taxi USING hash (modelo);
DROP INDEX idx_hash_consulta3

-- indice 3 gin
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta3 ON taxi USING gin (modelo gin_trgm_ops)
DROP INDEX idx_gin_consulta3
-- indice 4 gin 
CREATE INDEX idx_gist_consulta3 ON taxi USING gist (modelo gist_trgm_ops)
DROP INDEX idx_gist_consulta3-- criação da tabela que vai armazenar os dados do indice

--indice 5 concorrente
CREATE INDEX CONCURRENTLY idx_concorrente_consulta3 ON taxi (modelo)
DROP INDEX idx_concorrente_consulta3

-- CRIAÇÃO DAS TABELAS
CREATE TABLE tempos_execucao_consulta3_comindice (
    execucao_num INT,
    tempo_ms NUMERIC
);

-- executar isso para dropar os dados armazenados da consulta anterior que está considerando os dados do outro indice
DROP TABLE tempos_execucao_consulta3_comindice;

CREATE OR REPLACE FUNCTION medir_tempo_execucao_consulta3_comindice()
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
            M.Nome AS Motorista,
    		T.Modelo AS Modelo,
    		COUNT(C.CliId) AS TotalCorridas
			FROM 
    			Taxi T
			JOIN 
    			Motorista M ON T.Placa = M.Placa
			LEFT JOIN 
    			Corrida C ON M.Placa = C.Placa
			WHERE 
				T.Modelo = 'Onix'
			GROUP BY 
				M.Nome, T.Modelo;

        fim := clock_timestamp();
		tempo_execucao := EXTRACT(MILLISECOND FROM (fim - inicio));		
        INSERT INTO tempos_execucao_consulta3_comindice (execucao_num, tempo_ms)
        VALUES (i, tempo_execucao);
    END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT medir_tempo_execucao_consulta3_comindice();

select*from tempos_execucao_consulta3_comindice;

SELECT 
    AVG(tempo_ms) AS tempo_medio,
    MIN(tempo_ms) AS tempo_minimo,
    MAX(tempo_ms) AS tempo_maximo
FROM tempos_execucao_consulta3_comindice;
drop table tempos_execucao_consulta3_comindice;