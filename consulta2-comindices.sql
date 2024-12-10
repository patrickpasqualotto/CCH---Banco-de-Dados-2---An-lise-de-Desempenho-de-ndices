-- consulta 2 vai puxar o nome de todos os motorista que começam com a letra d
-- mostrando a kmtragem que cada um percorreu e mostrando isso da maior para a menor kmtragem

SELECT
			M.Nome AS Motorista,
    		SUM(F.KmIn) AS KmtragemTotal
		FROM 
    		Motorista M
		JOIN 
    		Fila F ON M.CNH = F.CNH
		WHERE 
			M.Nome LIKE 'D%'
		GROUP BY 
    		M.CNH, M.Nome
		ORDER BY 
    		KmtragemTotal DESC;
			
-- criação do primeiro indice btree(padrão)

CREATE INDEX idx_padrao_consulta2 ON motorista (nome);
DROP INDEX idx_padrao_consulta2;

-- indice 2 hash

CREATE INDEX idx_hash_consulta2 ON motorista USING hash (nome);
DROP INDEX idx_hash_consulta2

-- indice 3 gin
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta2 ON motorista USING gin (nome gin_trgm_ops)
DROP INDEX idx_gin_consulta2
-- indice 4 gin 
CREATE INDEX idx_gist_consulta2 ON motorista USING gist (nome gist_trgm_ops)
DROP INDEX idx_gist_consulta2-- criação da tabela que vai armazenar os dados do indice

--indice 5 concorrente
CREATE INDEX CONCURRENTLY idx_concorrente_consulta2 ON motorista (nome)
DROP INDEX idx_concorrente_consulta1

-- CRIAÇÃO DAS TABELAS
CREATE TABLE tempos_execucao_consulta2_comindice (
    execucao_num INT,
    tempo_ms NUMERIC
);

-- executar isso para dropar os dados armazenados da consulta anterior que está considerando os dados do outro indice
DROP TABLE tempos_execucao_consulta2_comindice;

CREATE OR REPLACE FUNCTION medir_tempo_execucao_consulta2_comindice()
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
    		Motorista M
		JOIN 
    		Fila F ON M.CNH = F.CNH
		WHERE 
			M.Nome LIKE 'D%'
		GROUP BY 
    		M.CNH, M.Nome
		ORDER BY 
    		KmtragemTotal DESC;

        fim := clock_timestamp();
		tempo_execucao := EXTRACT(MILLISECOND FROM (fim - inicio));		
        INSERT INTO tempos_execucao_consulta2_comindice (execucao_num, tempo_ms)
        VALUES (i, tempo_execucao);
    END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT medir_tempo_execucao_consulta2_comindice();

select*from tempos_execucao_consulta2_comindice;

SELECT 
    AVG(tempo_ms) AS tempo_medio,
    MIN(tempo_ms) AS tempo_minimo,
    MAX(tempo_ms) AS tempo_maximo
FROM tempos_execucao_consulta2_comindice;
drop table tempos_execucao_consulta2_comindice;