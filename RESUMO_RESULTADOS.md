# Conferência dos dados de exemplo

Estes são alguns resultados esperados após executar os arquivos de criação e carga:

| Verificação | Resultado esperado |
| --- | --- |
| Quantidade de tabelas | 15 |
| Quantidade de clientes | 6 (4 PF e 2 PJ) |
| Quantidade de produtos | 7 |
| Quantidade de pedidos | 8 |
| Quantidade de lançamentos de pagamento | 9 |
| Quantidade de consultas | 16 |
| Clientes com pelo menos dois pedidos | Ana Clara e Empresa Alfa |
| Vendedor que também é fornecedor | Tech Atacado Marketplace / Tech Atacado LTDA |
| Clientes com mais de uma forma de pagamento | Ana Clara e Empresa Alfa |
| Consulta de divergência no valor dos pedidos | Nenhuma linha |

**Nota sobre a conferência:** a estrutura e os dados foram verificados em ambiente de compatibilidade SQL (SQLite) para testar consultas, chaves estrangeiras e consistência dos valores. A implementação específica dos triggers diferíveis deve ser executada diretamente no PostgreSQL para validação completa.
