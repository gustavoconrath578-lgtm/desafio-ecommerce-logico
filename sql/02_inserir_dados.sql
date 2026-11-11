-- DADOS FICTICIOS PARA TESTAR AS TABELAS E AS CONSULTAS
-- Execute depois de 01_criar_esquema.sql.
-- Este arquivo foi feito para um esquema recem-criado (IDs iniciando em 1).

BEGIN;
SET search_path TO ecommerce, public;

INSERT INTO cliente (nome, email, telefone, tipo_cliente) VALUES
('Ana Clara',     'ana@exemplo.com',          '45999990001', 'PF'),
('Bruno Lima',    'bruno@exemplo.com',        '45999990002', 'PF'),
('Carla Souza',   'carla@exemplo.com',        '45999990003', 'PF'),
('Diego Martins', 'diego@exemplo.com',        '45999990004', 'PF'),
('Empresa Alfa',  'contato@alfa.exemplo.com', '45999990005', 'PJ'),
('Loja Beta',     'vendas@beta.exemplo.com',  '45999990006', 'PJ');

INSERT INTO cliente_pf (id_cliente, cpf, data_nascimento) VALUES
(1, '12345678901', '1998-04-12'),
(2, '23456789012', '1995-09-20'),
(3, '34567890123', '2001-01-17'),
(4, '45678901234', '1990-06-03');

INSERT INTO cliente_pj (id_cliente, cnpj, razao_social, nome_fantasia) VALUES
(5, '10101010000101', 'Empresa Alfa Tecnologia LTDA', 'Empresa Alfa'),
(6, '20202020000102', 'Loja Beta Comercio LTDA', 'Loja Beta');

INSERT INTO produto (nome, descricao, preco, categoria) VALUES
('Notebook',      'Notebook para estudo e trabalho', 3500.00, 'Informatica'),
('Mouse',         'Mouse USB',                         80.00, 'Perifericos'),
('Teclado',       'Teclado mecanico',                 160.00, 'Perifericos'),
('Monitor',       'Monitor 24 polegadas',             900.00, 'Informatica'),
('Headset',       'Fone com microfone',               250.00, 'Perifericos'),
('Webcam',        'Webcam Full HD',                   220.00, 'Acessorios'),
('Cadeira',       'Cadeira para escritorio',          650.00, 'Moveis');

INSERT INTO pedido (id_cliente, data_pedido, status_pedido, valor_total) VALUES
(1, '2026-10-28', 'ENVIADO',    3580.00),
(1, '2026-10-29', 'ENTREGUE',    570.00),
(2, '2026-10-29', 'ENTREGUE',   1120.00),
(3, '2026-10-30', 'CANCELADO',   240.00),
(4, '2026-11-01', 'PENDENTE',    650.00),
(5, '2026-11-02', 'ENVIADO',    7160.00),
(5, '2026-11-03', 'ENTREGUE',    750.00),
(6, '2026-11-04', 'PAGO',       2450.00);

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00), (1, 2, 1,  80.00),
(2, 3, 2,  160.00), (2, 5, 1, 250.00),
(3, 4, 1,  900.00), (3, 6, 1, 220.00),
(4, 2, 1,   80.00), (4, 3, 1, 160.00),
(5, 7, 1,  650.00),
(6, 1, 2, 3500.00), (6, 2, 2,  80.00),
(7, 5, 3,  250.00),
(8, 4, 2,  900.00), (8, 7, 1, 650.00);

INSERT INTO forma_pagamento
(id_cliente, tipo, identificador_mascarado, token_referencia) VALUES
(1, 'CARTAO', '**** 1234', 'token_ficticio_ana_1'),
(1, 'PIX',    'chave ana (teste)', NULL),
(2, 'PIX',    'chave bruno (teste)', NULL),
(3, 'CARTAO', '**** 4422', 'token_ficticio_carla_1'),
(4, 'BOLETO', 'boleto cadastrado', NULL),
(5, 'PIX',    'chave alfa (teste)', NULL),
(5, 'CARTAO', '**** 7788', 'token_ficticio_alfa_1'),
(6, 'PIX',    'chave beta (teste)', NULL);

INSERT INTO pagamento
(id_cliente, id_pedido, id_forma_pagamento, valor, data_pagamento, status_pagamento) VALUES
(1, 1, 1, 3580.00, '2026-10-28', 'PAGO'),
(1, 2, 2,  570.00, '2026-10-29', 'PAGO'),
(2, 3, 3, 1120.00, '2026-10-29', 'PAGO'),
(3, 4, 4,  240.00, '2026-10-31', 'ESTORNADO'),
(4, 5, 5,  650.00, NULL,         'PENDENTE'),
(5, 6, 6, 5000.00, '2026-11-02', 'PAGO'),
(5, 6, 7, 2160.00, '2026-11-02', 'PAGO'),
(5, 7, 7,  750.00, '2026-11-03', 'PAGO'),
(6, 8, 8, 2450.00, '2026-11-04', 'PAGO');

INSERT INTO entrega
(id_pedido, status_entrega, codigo_rastreio, transportadora, data_envio, data_prevista, data_entrega) VALUES
(1, 'EM_TRANSITO', 'BR20260001', 'Transportes Sul', '2026-10-29', '2026-11-07', NULL),
(2, 'ENTREGUE',    'BR20260002', 'Entrega Rapida',  '2026-10-30', '2026-11-04', '2026-11-02'),
(3, 'ENTREGUE',    'BR20260003', 'Entrega Rapida',  '2026-10-30', '2026-11-05', '2026-11-04'),
(5, 'PREPARANDO',  NULL,         NULL,              NULL,         '2026-11-10', NULL),
(6, 'EM_TRANSITO', 'BR20260006', 'Transportes Sul', '2026-11-03', '2026-11-10', NULL),
(7, 'ENTREGUE',    'BR20260007', 'Entrega Rapida',  '2026-11-04', '2026-11-09', '2026-11-07'),
(8, 'PREPARANDO',  NULL,         NULL,              NULL,         '2026-11-12', NULL);

INSERT INTO fornecedor (razao_social, cnpj) VALUES
('Tech Atacado LTDA',         '11111111000191'),
('Perifericos Sul LTDA',      '22222222000182'),
('Work Home Brasil LTDA',     '33333333000173'),
('Nova Distribuicao LTDA',    '44444444000164');

INSERT INTO vendedor_terceiro (nome, documento) VALUES
('Tech Atacado Marketplace', '11111111000191'), -- tambem e fornecedor
('Outlet Digital',           '55555555000155'),
('Loja Central',             '66666666000146');

INSERT INTO estoque (localizacao) VALUES
('Deposito de Curitiba - PR'),
('Deposito de Sao Paulo - SP'),
('Deposito de Porto Alegre - RS');

INSERT INTO produto_fornecedor (id_produto, id_fornecedor) VALUES
(1,1), (2,1), (3,1), (2,2), (3,2), (5,2),
(4,3), (6,3), (7,3), (1,4), (4,4), (6,4);

INSERT INTO produto_vendedor (id_produto, id_vendedor) VALUES
(1,1), (2,1), (4,1), (3,2), (5,2), (6,3), (7,3);

INSERT INTO produto_estoque (id_produto, id_estoque, quantidade) VALUES
(1,1,15), (1,2, 8),
(2,1,80), (2,2,55),
(3,1,40), (3,3,20),
(4,2,18), (4,3, 9),
(5,1,25), (5,3,30),
(6,2,22), (6,3,11),
(7,1, 7), (7,2,14);

COMMIT;
