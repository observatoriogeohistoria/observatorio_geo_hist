# Execução da Fase 4

- **Início:** 2026-10-02
- **Término:** 2026-10-02
- **Branch:** refactor/redesign-fase-4 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 016-biblioteca-indice-lista | índice (P-09), lista por área com filtros, resultados e paginação (T-06, P-10 a P-12) | feita (18 critérios, 15 tarefas) | feita (4 commits) | feita (1 `fix:`) | verificada com ressalvas: 1 correção (clique fora dos menus); índices da busca com filtro a publicar |
| 017-biblioteca-documento | detalhe do documento (T-07) | feita (14 critérios, 14 tarefas) | feita (3 commits) | feita | verificada com ressalvas: 2 correções (borda dos cantos do visualizador, nome da página do PDF); painel não conferido no app |

## Divisão
- 016 redesenha a entrada da biblioteca (áreas com contagem) e a lista por área: filtros de tipo e categoria com contagem, busca, resultados, paginação e estados. Índice e lista compartilham cabeçalho e cards.
- 017 redesenha o detalhe do documento (metadados e visualizador), depois da 016 porque a lista leva a ele.

## Decisões tomadas sem a pessoa
- 016: rota pública ganha página nova e o painel fica na `LibraryListPage`; busca num campo com "Buscar em" Título/Autor/Instituição e inicial maiúscula automática; ano como campo numérico, sem seletor de instituição; quantidades do tipo e das categorias da área inteira; categorias zeradas escondidas, em ordem alfabética; filtros na hora com chips removíveis; linhas de 20 em 20 com "Ver mais documentos"; sem ações de edição e sem parceiros no site público. Detalhes em [016/spec.md](016-biblioteca-indice-lista/spec.md).
- 016 (implementação): com busca, a ordem continua por data (a alfabética pedia índice novo até para a busca sozinha); na instituição, termo todo em minúsculas vira caixa alta (552 de 602 gravadas assim), em título e autor ganha inicial maiúscula; o título do cartão de área fica só visual, sem `h2` para leitores de tela, porque o cartão é lido como um link só.
- 016 (verificação): menus de filtro consomem o clique de fora, para fechar sem abrir o documento embaixo.
- 017: sem "← Área" nem "Voltar" (migalhas com "Início" levam à área); só "Abrir documento", sem "Baixar"; visualizador com página e anterior/próxima, sem zoom nem tela cheia; coluna de 920 px sem faixa de cabeçalho; sai a data de cadastro; documento inexistente ou área inválida dão a 404 atual, área válida trocada mostra o documento; slug codificado no endereço e, quando não serve (espaço, `/` ou mais de 200 caracteres), a lista usa o id no mesmo parâmetro e o detalhe busca por slug e depois por id; store próprio do detalhe, sem tocar no `LibraryStore`; sem compartilhar. Detalhes em [017/spec.md](017-biblioteca-documento/spec.md).
- 017 (implementação): 12 documentos de prod têm o resumo no slug (todos com espaço no fim, 5 com `/`) e abrem pelo id; visualizador desenhado direto com o `pdfx`, sem o `PdfView` (zoom e animação); sem barra no erro e sem arquivo, e sem moldura no sem arquivo; ícone de link externo à direita; `PrimaryButton` com opção `expand` para a largura toda no celular.
- 017 (verificação): borda do visualizador desenhada por cima, para não sumir nos cantos; nome da página do PDF pelo `semanticLabel` da imagem.

## Ressalvas
- 016: busca junto com tipo, ano ou categoria cai no erro tratado até a pessoa publicar os índices compostos de `docs/deploy-ambientes.md` nos dois projetos.
- 016: não conferidos no app: área sem documentos e documento sem slug (não existem em prod) e o painel (sem credenciais de teste; código sem diff).
- 016: dados de prod fora do escopo: registros todos em maiúsculas não aparecem na busca com inicial maiúscula; ao menos um documento tem o resumo como slug e o detalhe dele dá erro (017 e painel).
- 017: painel não conferido no app (sem credenciais; código sem diff).
- 017: 4 documentos de prod têm um JPEG no lugar do PDF e o visualizador mostra o erro (ajuste de dados, fora do escopo).

### Revisão (2026-10-06)
- Índices da busca: em `firestore.indexes.json`, publicados pelo deploy.
- Maiúsculas na busca: resolvida; a busca compara em minúsculas com `title_lower`, `author_lower` e `institution_lower`.
- Documento com o resumo como slug: resolvida; o endereço usa o id, e o slug só serve para links antigos.
- JPEG no lugar do PDF: resolvida; o visualizador reconhece imagem e a mostra.
- Seguem em aberto: área sem documentos e painel não conferidos no app.

## Ocorrências
- 016 (spec): a leitura direta do Firestore por REST (contagens e índices) foi bloqueada pelo classificador de permissões; dados e índices ficam para a conferência no app (G2).
- 016 (verificação): o navegador embutido, com o painel escondido, não pintava e perdia cliques; a conferência foi feita num Chrome sem janela via CDP.
- 017 (implementação): interrompida pelo limite de uso e retomada.
