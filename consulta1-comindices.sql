-- CONSULTA 1 
-- aqui vai puxar todas as corridas que foram realizadas, ordenando pela data do pedido
-- puxando todas as informações como nome do cliente, nome do motorista, qual o taxi
-- filtrando apenas pelas corridas que ocorreram no primeiro semestre de 2024
-- os indíces vão ser criados em cima da tabela corrida(datapedido)

SELECT
	corrida.cliid as codigoCliente,
    cli.nome as nomeCliente,
    mot.nome as nomeMotorista,
    mot.cnh,
    taxi.modelo,
    taxi.marca,
    corrida.placa,
    corrida.datapedido
FROM CORRIDA
   JOIN cliente cli ON cli.cliid = corrida.cliid
   JOIN motorista mot ON mot.placa = corrida.placa
   JOIN taxi ON taxi.placa = corrida.placa
   WHERE datapedido between '2024-01-01' and '2024-06-30' 
ORDER BY datapedido;

-- criação do primeiro indice btree(padrão)

CREATE INDEX idx_padrao_consulta1 ON corrida (datapedido);
DROP INDEX idx_padrao_consulta1;

-- indice 2 hash

CREATE INDEX idx_hash_consulta1 ON corrida USING hash (datapedido);
DROP INDEX idx_hash_consulta1

-- indice 3 gin
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_gin_consulta1 ON corrida USING gin (datapedido gin_trgm_ops)
ESSE INDÍCE NÃO VAI FUNCIONAR E VAMOS DEIXAR ASSIM PORQUE O TIPO GIN NÃO ACEITA DATAS COMO PARÂMETROS então é isso ai

-- indice 4 gin 
CREATE INDEX idx_gist_consulta1 ON corrida USING gist (datapedido gist_trgm_ops)
gist também não vai aceitar datas como coluna para indexar
-- criação da tabela que vai armazenar os dados do indice

--indice 5 concorrente
CREATE INDEX CONCURRENTLY idx_concorrente_consulta1 ON corrida (datapedido)
DROP INDEX idx_concorrente_consulta1

-- CRIAÇÃO DAS TABELAS
CREATE TABLE tempos_execucao_consulta1_comindice (
    execucao_num INT,
    tempo_ms NUMERIC
);

-- executar isso para dropar os dados armazenados da consulta anterior que está considerando os dados do outro indice
DROP TABLE tempos_execucao_consulta1_comindice;

CREATE OR REPLACE FUNCTION medir_tempo_execucao_consulta1_comindice()
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
            corrida.cliid as codigoCliente,
    		cli.nome as nomeCliente,
    		mot.nome as nomeMotorista,
    		mot.cnh,
    		taxi.modelo,
    		taxi.marca,
    		corrida.placa,
    		corrida.datapedido
		FROM CORRIDA
   			JOIN cliente cli ON cli.cliid = corrida.cliid
   			JOIN motorista mot ON mot.placa = corrida.placa
   			JOIN taxi ON taxi.placa = corrida.placa
   		WHERE datapedido between '2024-01-01' and '2024-06-30' 
		ORDER BY datapedido;

        fim := clock_timestamp();
		tempo_execucao := EXTRACT(MILLISECOND FROM (fim - inicio));		
        INSERT INTO tempos_execucao_consulta1_comindice (execucao_num, tempo_ms)
        VALUES (i, tempo_execucao);
    END LOOP;

END;
$$ LANGUAGE plpgsql;

SELECT medir_tempo_execucao_consulta1_comindice();

select*from tempos_execucao_consulta1_comindice;

SELECT 
    AVG(tempo_ms) AS tempo_medio,
    MIN(tempo_ms) AS tempo_minimo,
    MAX(tempo_ms) AS tempo_maximo
FROM tempos_execucao_consulta1_comindice;
