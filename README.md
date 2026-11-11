# Projeto de Banco de Dados — E-commerce

## Sobre o projeto

Este projeto é a continuação de um desafio de modelagem de banco de dados para uma loja virtual. Nesta etapa, passei do modelo conceitual para o modelo lógico, criando as tabelas e definindo como elas se relacionam.

O banco guarda informações sobre clientes, produtos, pedidos, pagamentos, entregas, fornecedores e estoque. Também adicionei dados de exemplo e consultas SQL para testar o funcionamento.

## O que foi feito

- Separei os clientes em **Pessoa Física (PF)** e **Pessoa Jurídica (PJ)**, sem permitir que o mesmo cliente seja dos dois tipos.
- Permiti que cada cliente cadastre **mais de uma forma de pagamento**.
- Incluí o **status da entrega** e o **código de rastreio** dos pedidos.
- Criei as tabelas com suas **chaves primárias, estrangeiras e restrições**.
- Preparei consultas usando `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING` e `JOIN`, além de cálculos e condições.

As consultas ajudam a responder perguntas como: quantos pedidos cada cliente fez, quais produtos pertencem a cada fornecedor e quais produtos estão no estoque.

## Modelo lógico

![Diagrama do modelo lógico](diagramas/modelo_logico.png)

## Arquivos

- `sql/01_criar_esquema.sql` — cria as tabelas e suas regras.
- `sql/02_inserir_dados.sql
