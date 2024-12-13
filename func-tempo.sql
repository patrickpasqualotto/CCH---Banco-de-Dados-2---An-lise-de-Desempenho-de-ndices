
-- cria uma tabela que vai armazenar os tempos da consulta
CREATE TABLE tempos_execucao_consulta(
    execucao_num INT,
    tempo_ms NUMERIC
);
-- drop pra limpar ela antes de executar a nova consulta por exemplo
DROP TABLE tempos_execucao_consulta;

CREATE OR REPLACE FUNCTION medir_tempo_execucao()
RETURNS VOID AS $$
DECLARE
    inicio TIMESTAMP;
    fim TIMESTAMP;
    tempo_execucao NUMERIC; 
    i INT;
BEGIN
  FOR i in 1..100 LOOP
    inicio := clock_timestamp();
    PERFORM
        --aqui vai colar a consulta sem o select 

    fim := clock_timestamp();
		tempo_execucao := EXTRACT(MILLISECOND FROM (fim - inicio));		
        INSERT INTO tempos_execucao_consulta (execucao_num, tempo_ms)
        VALUES (i, tempo_execucao);
    END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT medir_tempo_execucao();

select*from tempos_execucao_consulta;

SELECT 
    AVG(tempo_ms) AS tempo_medio,
    MIN(tempo_ms) AS tempo_minimo,
    MAX(tempo_ms) AS tempo_maximo
FROM tempos_execucao_consulta;

DROP TABLE tempos_execucao_consulta;
-- se foi utilizado o indice tem que dropar antes de ir pro proximo
