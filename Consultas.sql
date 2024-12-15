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

- qual foi os 10 motoristas que mais rodaram na zona "89hlb706"?

SELECT 
    M.Nome AS Motorista,
    SUM(F.KmIn) AS KmtragemTotal
FROM 
    Fila F
JOIN 
    Motorista M ON F.CNH = M.CNH
WHERE 
    F.Zona = 'Azevedo de Rocha'  
GROUP BY 
    M.Nome
ORDER BY 
    KmtragemTotal DESC
LIMIT 10;

