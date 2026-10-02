# Execução da Fase 3

- **Início:** 2026-10-02
- **Branch:** refactor/redesign-fase-3 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 014-listagem-categoria | cards de post, listagem de categoria | feita (18 critérios, 12 tarefas) | pendente | pendente | |
| 015-todas-publicacoes | T-11, link "Ver todas" dos Destaques | pendente | pendente | pendente | |

## Divisão
- 014 cria o card de post do novo desenho e o aplica na listagem da categoria (cabeçalho, busca, chips de tipo, grade, paginação e estados).
- 015 reaproveita a listagem da 014 em `/publicacoes`, sem filtro de categoria e com consulta em todas as categorias, e devolve o link "Ver todas as publicações" aos Destaques da Home.

## Decisões tomadas sem a pessoa
- 014: card novo unificado com o "Leia também" do post (sai o `RelatedPostCard`; Destaques da Home mantêm card próprio); um bloco por tipo com "Ver mais", 12 itens por vez; chips com quantidade só com 2+ tipos (some só o número se a contagem falhar); "N publicações"; com busca, ordem alfabética; cabeçalho de página da 010 com migalhas e sem imagem de fundo; "Colabore com esta categoria" só com `hasCollaborateOption`; categoria vazia e busca vazia com caixas diferentes; área/categoria inexistente → 404; busca e chip fora da URL; `FetchPostsStore` vira `PostsListingStore`, pronto para a 015. Detalhes em [014/spec.md](014-listagem-categoria/spec.md).

## Ressalvas

## Ocorrências
