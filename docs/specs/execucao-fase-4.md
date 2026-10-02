# Execução da Fase 4

- **Início:** 2026-10-02
- **Branch:** refactor/redesign-fase-4 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 016-biblioteca-indice-lista | índice (P-09), lista por área com filtros, resultados e paginação (T-06, P-10 a P-12) | feita (18 critérios, 15 tarefas) | pendente | pendente | |
| 017-biblioteca-documento | detalhe do documento (T-07) | pendente | pendente | pendente | |

## Divisão
- 016 redesenha a entrada da biblioteca (áreas com contagem) e a lista por área: filtros de tipo e categoria com contagem, busca, resultados, paginação e estados. Índice e lista compartilham cabeçalho e cards.
- 017 redesenha o detalhe do documento (metadados e visualizador), depois da 016 porque a lista leva a ele.

## Decisões tomadas sem a pessoa
- 016: rota pública ganha página nova e o painel fica na `LibraryListPage`; busca num campo com "Buscar em" Título/Autor/Instituição e inicial maiúscula automática; ano como campo numérico, sem seletor de instituição; quantidades do tipo e das categorias da área inteira; categorias zeradas escondidas, em ordem alfabética; filtros na hora com chips removíveis; linhas de 20 em 20 com "Ver mais documentos"; sem ações de edição e sem parceiros no site público. Detalhes em [016/spec.md](016-biblioteca-indice-lista/spec.md).

## Ressalvas
- (spec, ponto, o que foi tentado)

## Ocorrências
- 016 (spec): a leitura direta do Firestore por REST (contagens e índices) foi bloqueada pelo classificador de permissões; dados e índices ficam para a conferência no app (G2).
