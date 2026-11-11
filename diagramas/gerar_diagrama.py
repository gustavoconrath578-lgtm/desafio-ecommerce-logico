from pathlib import Path
import subprocess
from html import escape

out = Path(__file__).parent
objects = {
 'CLIENTE': [('PK','id_cliente'),('','nome · email (UK)'),('','telefone · tipo_cliente')],
 'CLIENTE_PF': [('PK/FK','id_cliente'),('UK','cpf'),('','data_nascimento')],
 'CLIENTE_PJ': [('PK/FK','id_cliente'),('UK','cnpj'),('','razao_social · nome_fantasia')],
 'PEDIDO': [('PK','id_pedido'),('FK','id_cliente'),('','data_pedido · status_pedido'),('','valor_total')],
 'ITEM_PEDIDO': [('PK/FK','id_pedido'),('PK/FK','id_produto'),('','quantidade · preco_unitario')],
 'PRODUTO': [('PK','id_produto'),('','nome · categoria'),('','descricao · preco')],
 'FORMA_PAGAMENTO': [('PK','id_forma_pagamento'),('FK','id_cliente'),('','tipo · identificador_mascarado'),('','token_referencia')],
 'PAGAMENTO': [('PK','id_pagamento'),('FK','id_cliente · id_pedido'),('FK','id_forma_pagamento'),('','valor · data · status')],
 'ENTREGA': [('PK','id_entrega'),('FK/UK','id_pedido'),('UK','codigo_rastreio'),('','status · transportadora · datas')],
 'FORNECEDOR': [('PK','id_fornecedor'),('','razao_social · cnpj (UK)')],
 'VENDEDOR_TERCEIRO': [('PK','id_vendedor'),('','nome · documento (UK)')],
 'ESTOQUE': [('PK','id_estoque'),('','localizacao')],
 'PRODUTO_FORNECEDOR': [('PK/FK','id_produto'),('PK/FK','id_fornecedor')],
 'PRODUTO_VENDEDOR': [('PK/FK','id_produto'),('PK/FK','id_vendedor')],
 'PRODUTO_ESTOQUE': [('PK/FK','id_produto'),('PK/FK','id_estoque'),('','quantidade')]
}
accent = {k: '#2C667C' for k in ('CLIENTE','CLIENTE_PF','CLIENTE_PJ')}
accent.update({k:'#976121' for k in ('ENTREGA','PAGAMENTO','FORMA_PAGAMENTO')})
accent.update({k:'#526A5C' for k in ('PRODUTO_FORNECEDOR','PRODUTO_VENDEDOR','PRODUTO_ESTOQUE')})
lines = [
'digraph Ecommerce {',
'graph [layout=dot, rankdir=LR, bgcolor="white", splines=polyline, nodesep=0.5, ranksep=1.00, pad=0.3, labelloc=t, label="MODELO LÓGICO RELACIONAL — E-COMMERCE\\n15 tabelas | chaves e relacionamentos", fontname="DejaVu Sans", fontsize=22, fontcolor="#203B56", outputorder=edgesfirst];',
'node [shape=plain, fontname="DejaVu Sans"];',
'edge [color="#8C9BAA", penwidth=1.15, arrowsize=0.6, fontname="DejaVu Sans", fontsize=10];'
]
for name, fields in objects.items():
 color=accent.get(name,'#253D5B')
 rows = [f'<TR><TD BGCOLOR="{color}" ALIGN="CENTER" COLSPAN="2"><FONT COLOR="white"><B>{escape(name)}</B></FONT></TD></TR>']
 for prefix, val in fields:
  rows.append(f'<TR><TD ALIGN="LEFT" BGCOLOR="#EDF2F7"><FONT POINT-SIZE="10" COLOR="#36536D">{escape(prefix or '—')}</FONT></TD><TD ALIGN="LEFT"><FONT POINT-SIZE="11">{escape(val)}</FONT></TD></TR>')
 label = '<<TABLE BORDER="1" COLOR="'+color+'" CELLBORDER="0" CELLSPACING="0" CELLPADDING="6">'+''.join(rows)+'</TABLE>>'
 lines.append(f'"{name}" [label={label}];')
rels = [
('CLIENTE','CLIENTE_PF','1:0..1'),('CLIENTE','CLIENTE_PJ','1:0..1'),('CLIENTE','PEDIDO','1:N'),('CLIENTE','FORMA_PAGAMENTO','1:N'),
('PEDIDO','ITEM_PEDIDO','1:N'),('PRODUTO','ITEM_PEDIDO','1:N'),('PEDIDO','PAGAMENTO','1:N'),('FORMA_PAGAMENTO','PAGAMENTO','1:N'),('PEDIDO','ENTREGA','1:0..1'),
('FORNECEDOR','PRODUTO_FORNECEDOR','1:N'),('PRODUTO','PRODUTO_FORNECEDOR','1:N'),
('VENDEDOR_TERCEIRO','PRODUTO_VENDEDOR','1:N'),('PRODUTO','PRODUTO_VENDEDOR','1:N'),
('ESTOQUE','PRODUTO_ESTOQUE','1:N'),('PRODUTO','PRODUTO_ESTOQUE','1:N')
]
for a,b,c in rels:
 lines.append(f'"{a}" -> "{b}" [label="{c}"];')
lines.append('}')
(out/'modelo_logico.dot').write_text('\n'.join(lines),encoding='utf-8')
for fmt in ('png','svg'):
 subprocess.run(['dot',f'-T{fmt}',str(out/'modelo_logico.dot'),'-o',str(out/f'modelo_logico.{fmt}')],check=True)
print('Diagramas gerados:', (out/'modelo_logico.png').stat().st_size)
