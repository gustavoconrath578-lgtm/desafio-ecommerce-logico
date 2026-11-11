-- CONSULTAS PARA RESPONDER AS PERGUNTAS DO DESAFIO
-- Execute apos criar o esquema e inserir os dados.
SET search_path TO ecommerce, public;

-- 1. Quais produtos existem na loja e quais sao seus precos?
-- SELECT simples.
SELECT id_produto, nome, categoria, preco
FROM produto;

-- 2. Quais produtos de informatica custam mais de R$ 500?
-- Filtro com WHERE + ORDER BY.
SELECT nome, preco, categoria
FROM produto
WHERE categoria = 'Informatica' AND preco > 500
ORDER BY preco DESC;

-- 3. Qual o subtotal de cada item e quanto ficaria com 10% de desconto?
-- Expressoes para gerar atributos derivados.
SELECT ip.id_pedido, pr.nome AS produto, ip.quantidade,
       ip.preco_unitario,
       (ip.quantidade * ip.preco_unitario) AS subtotal,
       ROUND(ip.quantidade * ip.preco_unitario * 0.90, 2) AS subtotal_com_desconto
FROM item_pedido ip
JOIN produto pr ON pr.id_produto = ip.id_produto
ORDER BY ip.id_pedido, pr.nome;

-- 4. Quais sao os produtos mais caros?
-- Ordenacao com ORDER BY.
SELECT nome, preco
FROM produto
ORDER BY preco DESC, nome ASC;

-- 5. Quantos pedidos foram realizados por cada cliente?
-- LEFT JOIN inclui clientes com zero pedidos.
SELECT c.id_cliente, c.nome AS cliente,
       COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY total_pedidos DESC, cliente;

-- 6. Quais clientes fizeram dois ou mais pedidos?
-- GROUP BY e HAVING: filtra grupos, nao linhas isoladas.
SELECT c.nome AS cliente, COUNT(p.id_pedido) AS total_pedidos
FROM cliente c
JOIN pedido p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(p.id_pedido) >= 2
ORDER BY total_pedidos DESC, cliente;

-- 7. Algum vendedor tambem e fornecedor?
-- Comparacao do documento (CNPJ) cadastrado nos dois cadastros.
SELECT v.nome AS vendedor, f.razao_social AS fornecedor,
       v.documento AS cnpj_em_comum
FROM vendedor_terceiro v
JOIN fornecedor f ON f.cnpj = v.documento
ORDER BY vendedor;

-- 8. Quais fornecedores oferecem cada produto e quanto ha em estoque?
-- JOIN de fornecedores/produtos com soma de quantidades por produto.
SELECT f.razao_social AS fornecedor, p.nome AS produto,
       COALESCE(SUM(pe.quantidade), 0) AS quantidade_total_estoque
FROM fornecedor f
JOIN produto_fornecedor pf ON pf.id_fornecedor = f.id_fornecedor
JOIN produto p ON p.id_produto = pf.id_produto
LEFT JOIN produto_estoque pe ON pe.id_produto = p.id_produto
GROUP BY f.id_fornecedor, f.razao_social, p.id_produto, p.nome
ORDER BY fornecedor, produto;

-- 9. Qual e a relacao entre nomes dos fornecedores e nomes dos produtos?
SELECT f.razao_social AS fornecedor, p.nome AS produto
FROM fornecedor f
JOIN produto_fornecedor pf ON pf.id_fornecedor = f.id_fornecedor
JOIN produto p ON p.id_produto = pf.id_produto
ORDER BY fornecedor, produto;

-- 10. Qual a situacao dos pedidos, seus clientes, pagamentos e entregas?
-- A subconsulta agrega pagamentos ANTES do JOIN e evita duplicacao de valores.
SELECT ped.id_pedido, c.nome AS cliente, c.tipo_cliente,
       ped.valor_total, ped.status_pedido,
       COALESCE(pg.total_pago, 0) AS total_pago,
       COALESCE(e.status_entrega, 'SEM_ENTREGA') AS status_entrega,
       e.codigo_rastreio
FROM pedido ped
JOIN cliente c ON c.id_cliente = ped.id_cliente
LEFT JOIN (
    SELECT id_pedido, SUM(valor) AS total_pago
    FROM pagamento
    WHERE status_pagamento = 'PAGO'
    GROUP BY id_pedido
) pg ON pg.id_pedido = ped.id_pedido
LEFT JOIN entrega e ON e.id_pedido = ped.id_pedido
ORDER BY ped.id_pedido;

-- 11. Os totais armazenados nos pedidos batem com os seus itens?
-- Consulta de auditoria: com os dados de exemplo, deve retornar ZERO linhas.
SELECT ped.id_pedido, ped.valor_total AS valor_cadastrado,
       SUM(ip.quantidade * ip.preco_unitario) AS valor_calculado
FROM pedido ped
JOIN item_pedido ip ON ip.id_pedido = ped.id_pedido
GROUP BY ped.id_pedido, ped.valor_total
HAVING ABS(ped.valor_total - SUM(ip.quantidade * ip.preco_unitario)) > 0.01;

-- 12. Quais clientes possuem mais de uma forma de pagamento cadastrada?
SELECT c.nome AS cliente, COUNT(fp.id_forma_pagamento) AS formas_cadastradas
FROM cliente c
JOIN forma_pagamento fp ON fp.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(fp.id_forma_pagamento) > 1
ORDER BY formas_cadastradas DESC, cliente;

-- 13. Qual o valor pago por cliente (desconsiderando estornos e pendencias)?
SELECT c.nome AS cliente, SUM(pg.valor) AS total_pago
FROM cliente c
JOIN pagamento pg ON pg.id_cliente = c.id_cliente
WHERE pg.status_pagamento = 'PAGO'
GROUP BY c.id_cliente, c.nome
ORDER BY total_pago DESC;

-- 14. Quantos pedidos existem em cada status?
SELECT status_pedido, COUNT(*) AS quantidade
FROM pedido
GROUP BY status_pedido
ORDER BY quantidade DESC, status_pedido;

-- 15. Quais clientes sao PF e quais sao PJ?
-- CASE cria o nome para exibicao a partir da especializacao EER.
SELECT c.id_cliente, c.tipo_cliente,
       CASE WHEN c.tipo_cliente = 'PF' THEN c.nome
            ELSE pj.razao_social END AS nome_exibicao,
       CASE WHEN c.tipo_cliente = 'PF' THEN pf.cpf
            ELSE pj.cnpj END AS documento
FROM cliente c
LEFT JOIN cliente_pf pf ON pf.id_cliente = c.id_cliente
LEFT JOIN cliente_pj pj ON pj.id_cliente = c.id_cliente
ORDER BY c.id_cliente;

-- 16. Quais produtos estao sendo vendidos pelos vendedores terceiros?
SELECT v.nome AS vendedor, p.nome AS produto, p.preco
FROM vendedor_terceiro v
JOIN produto_vendedor pv ON pv.id_vendedor = v.id_vendedor
JOIN produto p ON p.id_produto = pv.id_produto
ORDER BY vendedor, produto;
