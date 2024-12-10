- qual foi os 10 motoristas que mais rodaram na zona "89hlb706"?

SELECT 
    M.Nome AS Motorista,
    SUM(F.KmIn) AS KmtragemTotal
FROM 
    Fila F
JOIN 
    Motorista M ON F.CNH = M.CNH
WHERE 
    F.Zona = '89hlb706'  
GROUP BY 
    M.Nome
ORDER BY 
    KmtragemTotal DESC
LIMIT 10;

	
-- criação do primeiro indice btree(padrão)

CREATE INDEX idx_padrao_consulta5 ON fila (zona);
DROP INDEX idx_padrao_consulta5;

-- indice 2 hash

CREATE INDEX idx_hash_consulta5 ON fila USING hash (zona);
DROP INDEX idx_hash_consulta5

-- indice 3 gin
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta5 ON fila USING gin (zona gin_trgm_ops)
DROP INDEX idx_gin_consulta5
-- indice 4 gin 
CREATE INDEX idx_gist_consulta5 ON fila USING gist (zona gist_trgm_ops)
DROP INDEX idx_gist_consulta5-- criação da tabela que vai armazenar os dados do indice

--indice 5 concorrente
CREATE INDEX CONCURRENTLY idx_concorrente_consulta5 ON fila (zona)
DROP INDEX idx_concorrente_consulta5

-- CRIAÇÃO DAS TABELAS
CREATE TABLE tempos_execucao_consulta5_comindice (
    execucao_num INT,
    tempo_ms NUMERIC
);

-- executar isso para dropar os dados armazenados da consulta anterior que está considerando os dados do outro indice
DROP TABLE tempos_execucao_consulta5_comindice;

CREATE OR REPLACE FUNCTION medir_tempo_execucao_consulta5_comindice()
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
				SUM(F.KmIn) AS KmtragemTotal
			FROM 
				Fila F
			JOIN 
				Motorista M ON F.CNH = M.CNH
			WHERE 
				F.Zona = '89hlb706'  
			GROUP BY 
				M.Nome
			ORDER BY 
				KmtragemTotal DESC
			LIMIT 10;

        fim := clock_timestamp();
		tempo_execucao := EXTRACT(MILLISECOND FROM (fim - inicio));		
        INSERT INTO tempos_execucao_consulta5_comindice (execucao_num, tempo_ms)
        VALUES (i, tempo_execucao);
    END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT medir_tempo_execucao_consulta5_comindice();

select*from tempos_execucao_consulta5_comindice;

SELECT 
    AVG(tempo_ms) AS tempo_medio,
    MIN(tempo_ms) AS tempo_minimo,
    MAX(tempo_ms) AS tempo_maximo
FROM tempos_execucao_consulta5_comindice;
drop table tempos_execucao_consulta5_comindice;