# Ideias futuras

Ideias levantadas no redesign e deixadas fora do escopo. Para virar trabalho, cada uma passa pelo fluxo de specs ([specs/README.md](specs/README.md)).

## Busca geral do site
Uma lupa na navbar (atalho `/`) abriria um painel com resultados agrupados em **Publicações** e **Biblioteca**, com navegação por teclado. Enter levaria a uma página de resultados filtrável por grupo. O desenho está no protótipo (aba "Busca (ideia)").

**Situação atual:** posts têm busca por prefixo do título (`body.title_lower`), por categoria e em `/publicacoes`. A biblioteca busca por prefixo em título, autor e instituição (`*_lower`). Não existe busca que atravesse os dois.

**Motor (decisão adiada):**

| Opção | Como funciona | Limites |
|---|---|---|
| A. Firestore por prefixo | Consulta `collectionGroup` em posts e a coleção `library` | Só prefixo, sem acentos e sem várias palavras |
| B. Índice leve no cliente | Ao abrir a busca, carrega uma lista enxuta dos itens publicados e pesquisa no navegador, ignorando acentos e caixa e aceitando várias palavras | Vale enquanto o total for de centenas a poucos milhares de itens |
| C. Serviço de busca (Typesense, Algolia) | Índice externo sincronizado com o Firestore | Custo e operação extras |

Para decidir, é preciso saber quantos posts e documentos existem hoje.

## Copiar citação no documento da biblioteca
Um botão que copia a referência bibliográfica pronta (ex.: "SOBRENOME, Nome. Título. 2024. Dissertação – UFU."). O formato ABNT precisaria ser validado.

## Envio de e-mail pelo próprio site
Hoje os formulários abrem o programa de e-mail do visitante. Enviar direto exigiria um serviço (extensão "Trigger Email" do Firebase, Cloud Function ou serviço de formulário), proteção contra spam e, provavelmente, o plano Blaze do Firebase.
