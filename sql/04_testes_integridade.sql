-- TESTES EXTRAS (OPCIONAIS)
-- Cada bloco propositalmente tenta violar uma regra e mostra o erro esperado.
-- Por usar ROLLBACK, nenhum dos blocos altera o projeto de forma permanente.
-- Execute UM bloco por vez no pgAdmin, se quiser verificar as constraints.

-- TESTE A: nao permite CPF de 10 digitos.
BEGIN;
SET search_path TO ecommerce, public;
INSERT INTO cliente_pf (id_cliente, cpf) VALUES (1, '1234567890');
ROLLBACK;

-- TESTE B: nao permite uma segunda subclasse PJ para a cliente PF de ID 1.
-- A violacao da especializacao e avaliada ao COMMIT.
BEGIN;
SET search_path TO ecommerce, public;
INSERT INTO cliente_pj (id_cliente, cnpj, razao_social)
VALUES (1, '99999999000199', 'Empresa Indevida LTDA');
COMMIT;
-- Se executar o bloco B, o COMMIT produz erro e a transacao nao e salva.

-- TESTE C: nao permite pagamento com cartao de outro cliente.
-- Pedido 3 pertence ao cliente 2; forma de pagamento 1 pertence ao cliente 1.
BEGIN;
SET search_path TO ecommerce, public;
INSERT INTO pagamento
(id_cliente, id_pedido, id_forma_pagamento, valor, status_pagamento)
VALUES (2, 3, 1, 10, 'PENDENTE');
ROLLBACK;
