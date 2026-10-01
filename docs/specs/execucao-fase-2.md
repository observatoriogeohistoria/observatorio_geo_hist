# Execução da Fase 2

- **Início:** 2026-10-01
- **Branch:** refactor/redesign-fase-2 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 010-leitura-manifesto | layout de leitura, T-01 | feita (14 critérios, 11 tarefas) | feita (2 commits) | feita (1 fix) | verificada (5 commits) |
| 011-nossa-historia-pessoa | T-03, T-02 | feita (17 critérios, 12 tarefas) | feita (4 commits) | feita (1 fix) | verificada com ressalvas (7 commits) |
| 012-post-base | T-08 (artigo), P-05, P-07, P-08 | pendente | pendente | pendente | |
| 013-compartilhamento-post | P-06 | pendente | pendente | pendente | |

## Divisão
- 010 cria o layout de leitura compartilhado (cabeçalho de página e coluna de texto) e o aplica no Manifesto, a página mais simples.
- 011 junta Nossa história e Pessoa da equipe: duas páginas curtas que reaproveitam o layout da 010.
- 012 é o layout-base do post com o tipo artigo; os demais tipos ficam para a Fase 5.
- 013 separa o compartilhamento (P-06) do layout do post, por ser entrega isolada e depender da 012.

## Decisões tomadas sem a pessoa
- 010: texto do Manifesto com a revisão do protótipo (abertura, lista, destaque e pequenas correções, sem apagar frases); migalhas no cabeçalho de página; base de leitura só com os blocos do Manifesto (subtítulo e lista com marcadores na 011); Nossa história provisória não migra na 010. Detalhes em [010/spec.md](010-leitura-manifesto/spec.md).
- 011: texto de Nossa história atual palavra por palavra na estrutura do protótipo (sem a reescrita dele); foto `our-history.webp` em 21:9 com recorte para cima; sem o botão "← Equipe"; "Equipe" nas migalhas vai para a Home; pessoa não encontrada usa a 404 atual; laço de leituras já resolvido no código, mantido como critério. Detalhes em [011/spec.md](011-nossa-historia-pessoa/spec.md).

## Ressalvas
- 010: a seta do `PrimaryButton` (spec 002) não cresce com o texto a 200%; não quebra o layout. Anotada para quando o botão for revisto.
- 011: offline, o Firestore responde do cache vazio e a pessoa cai na 404 em vez da caixa de erro (comportamento anterior; mudar exige mexer no datasource). Membro sem descrição e botão Lattes só conferidos com dados injetados (não há no banco de dev).

## Ocorrências
- 010: na verificação, as migalhas saíam como grupo; passaram a `navigation` "Você está em" (`fix:` próprio). Texto a 200% conferido ampliando a fonte raiz do documento, que o Flutter web respeita.
- 011: na verificação, com a página rolada as migalhas recebiam foco escondidas sob a navbar fixa (e vinham antes da navbar no Tab). Corrigido no `ReadingPageScaffold` (`fix:` próprio): navbar primeiro na ordem e item focado rolado para aparecer. Vale também para o Manifesto.
