-- 1. Comandantes que realizaram voos com destino a Paris entre 31/10/2015 e 30/11/2015.
Select piloto.id, tripulante.nome, tripulante.apelido, voo.data_chegada AS chegada
FROM tripulante, piloto, voo, rota, aeroporto
WHERE tripulante.tipo = 'piloto' 
    AND tripulante.id = piloto.id 
    AND piloto.tipo = 'comandante'
    AND voo.id_comandante = piloto.id
    AND voo.cod_rota = rota.cod_rota
    AND rota.cod_aeroporto_fim = aeroporto.cod_aeroporto
    AND aeroporto.local = 'Paris'
    AND ('31/10/2015' <= voo.data_chegada <= '30/11/2015');

-- 2. Número total de voos efetuados por cada avião desde o início do presente ano.
SELECT aviao.nome, aviao.matricula, COUNT(voo.n_voo) AS voos
FROM aviao, voo
WHERE voo.matricula = aviao.matricula
GROUP BY aviao.matricula;

-- 3. Voos em que o comandante Abel Antunes e o copiloto Carlos Caldas voaram juntos.
SELECT DISTINCT voo.n_voo AS voo, aviao.nome AS aviao, voo.matricula, voo.data_partida AS partida, voo.data_chegada AS chegada
FROM voo, aviao, tripulante, piloto 
WHERE voo.id_comandante = (SELECT tripulante.id FROM tripulante WHERE tripulante.nome = 'Abel' AND tripulante.apelido = 'Antunes') 
	AND voo.id_copiloto = (SELECT tripulante.id FROM tripulante WHERE tripulante.nome = 'Carlos' AND tripulante.apelido = 'Caldas')
ORDER BY aviao.nome, voo.n_voo ASC;

-- 4 Comandantes (nome completo, n.º licença e data de emissão da licença) habilitados a
-- pilotar aviões cuja autonomia seja superior a 500km. Pretende-se que o resultado seja
-- ordenado alfabeticamente, por nome próprio e por apelido, respetivamente.
SELECT DISTINCT tripulante.nome, tripulante.apelido, habilitado.n_licenca AS licença, habilitado.data_licenca AS emissão
FROM tripulante, piloto, habilitado, tipoaviao
WHERE tripulante.id = piloto.id AND piloto.id = habilitado.id
	AND piloto.tipo = 'comandante'
	AND habilitado.cod_tipo = tipoaviao.cod_tipo
    AND tipoAviao.autonomia > 500
ORDER BY tripulante.nome, tripulante.apelido, habilitado.data_licenca

-- 5. Pilotos que nunca realizaram voos da rota 12345.
SELECT DISTINCT piloto.id AS id, tripulante.nome, tripulante.apelido
FROM tripulante, piloto
WHERE tripulante.id = piloto.id 
	AND piloto.id NOT IN (SELECT voo.id_comandante FROM voo WHERE voo.cod_rota = 12345)
    AND piloto.id NOT IN (SELECT voo.id_copiloto FROM voo WHERE voo.cod_rota = 12345)


-- 6. Aviões que já efetuaram voos em todas as rotas da companhia.
SELECT aviao.nome, aviao.matricula, COUNT(DISTINCT rota.cod_rota) AS rotas
FROM aviao, rota, voo
WHERE voo.matricula = aviao.matricula AND voo.cod_rota = rota.cod_rota
GROUP BY aviao.matricula
HAVING COUNT(voo.cod_rota) = 13;

-- R.: Não existe nenhum avião que tenha feito as 13 rotas.

-- 7. Nome e n.º de horas de voo dos copilotos que fizeram o maior número de voos.
-- Pretende-se saber o n.º exato de voos feitos por cada um desses copilotos.
SELECT tripulante.nome, tripulante.apelido, piloto.n_horas_voo AS horas, COUNT(voo.n_voo) AS voos
FROM tripulante, piloto, voo
WHERE tripulante.id = piloto.id AND piloto.tipo = 'copiloto'
	AND voo.id_copiloto = piloto.id
GROUP BY piloto.id

-- 8. Voos que permitem viagens de Lisboa a Paris. Note que devem ser considerados
-- também os voos que contenham escalas nestas duas cidades
SELECT DISTINCT voo.n_voo, voo.matricula AS aviao
FROM voo, rota, escala, escala e1, escala e2, aeroporto
WHERE (voo.cod_rota = rota.cod_rota AND rota.cod_aeroporto_ini = 'LIS' AND rota.cod_aeroporto_fim = 'CDG') 
	OR (voo.cod_rota = rota.cod_rota AND rota.cod_aeroporto_ini = 'LIS' AND escala.cod_rota = rota.cod_rota AND escala.cod_aeroporto = 'CDG')
    OR (voo.cod_rota = rota.cod_rota AND rota.cod_aeroporto_fim = 'CDG' AND escala.cod_rota = rota.cod_rota AND escala.cod_aeroporto = 'LIS' )
    OR (voo.cod_rota = rota.cod_rota AND e1.cod_rota = rota.cod_rota AND e2.cod_rota = rota.cod_rota AND e1.n_ordem < e2.n_ordem AND e1.cod_aeroporto = 'LIS' AND e2.cod_aeroporto = 'CDG')
ORDER BY voo.n_voo

-- 9. Pretende-se obter todas as escalas por ordem ascendente e agrupadas por rota apresentando também a
-- a cidade, o aeroporto de origem (com respetiva cidade) e o aeroporto de destino (com respetiva cidade).
-- A rota têm que passar em Lisboa e ter pelo menos 1 escala em Frankfurt ou Madrid.

SELECT escala.cod_rota, rota.cod_aeroporto_ini,
ae1.local origem, rota.cod_aeroporto_fim,
ae2.local destino, escala.cod_aeroporto,
ae3.local paragem, escala.n_ordem

FROM aeroporto ae1, aeroporto ae2, aeroporto ae3, rota, escala

WHERE escala.cod_rota = rota.cod_rota
	AND (rota.cod_aeroporto_ini = 'LIS' OR rota.cod_aeroporto_fim = 'LIS')
    AND (ae1.cod_aeroporto = rota.cod_aeroporto_ini)
    AND (ae2.cod_aeroporto = rota.cod_aeroporto_fim)
    AND (ae3.cod_aeroporto = escala.cod_aeroporto)
    
GROUP BY escala.cod_rota
HAVING escala.cod_aeroporto = 'FRA'
ORDER BY escala.cod_rota