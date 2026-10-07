# Verificação da 026. Biblioteca do painel e faixa de ambiente nos tokens novos

- **Data:** 2026-10-06
- **Resultado:** aprovada com ressalvas (não conferido o que depende de login)

Revisão do código de `b2e0657` e `de73a17` (`git diff 7aecb06..HEAD`) e do app numa cópia em caminho ASCII: build release servido localmente e uma sessão em modo debug, abertos em `/admin/painel/biblioteca/geografia` e `/admin/painel/biblioteca/historia` sem login. Sem credenciais de teste e sem dados alterados.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas, antes e depois da correção |
| `dart format` no projeto (conferência do `CLAUDE.md`) | 0 arquivos mudados |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro |
| `grep` de `num_extension`, Dosis, componentes e getters de texto antigos e cores antigas no `lib/` | só `theme/`, `num_extension.dart`, os arquivos sem uso da Fase 7 e `AppHeadline`/`AppTitle`/`AppLabel`/`AppBody` (ver critério 3) |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Cinco arquivos sem tokens antigos | passou | `grep` acima: nenhum dos cinco aparece |
| 2 | Sem valor solto | passou | espaçamentos via `spacing`; tamanhos novos em `ComponentSizes` (`panelFiltersWidth`, `panelLibraryDocIcon`); folga do anel vem de `focus.width + focus.offset` |
| 3 | Busca no projeto | passou | sobram `screen_utils` (`getPageHorizontalPadding`), `custom_icon_button`, `common_title`, `pages_circles`, `avatar`, `highlights_dialog_carousel` e os quatro componentes de texto Dosis. `AppTitle` e `AppLabel` não têm uso; `AppHeadline` só em `common_title`, `AppBody` só em `highlights_dialog_carousel`, e esses dois não são importados por ninguém. Os quatro foram acrescentados aos arquivos sem uso no planejamento |
| 4 | Ações funcionam | passou em parte | filtrar (título sem resultado), fechar o painel e abrir documento conferidos na tela; criar, editar e excluir exigem login (chamadas ao store intocadas no diff) |
| 5 | Vazio com botões | passou | 390 px: "Nenhum documento encontrado." em `inkSecondary` e "Filtros" visível; "Criar documento" fora do ramo de vazio no código |
| 6 | Erro com "Tentar de novo" | não conferido na tela | por código: `StateErrorInline` com `onRetry: _fetchDocuments` |
| 7 | Card por teclado | passou (após correção) | Tab do "Limpar Filtros" vai ao primeiro card, anel de foco inteiro; Enter abre `/biblioteca/geografia/documento/...` |
| 8 | Botões por Tab e com nome | passou em parte | "Voltar", campos, "Aplicar Filtros", "Limpar Filtros", cards e "Carregar mais" com foco visível; nomes por tooltip/`Semantics` no código. Editar, excluir e "Criar documento" exigem login |
| 9 | Contraste | passou | `inkSecondary` 7,0:1 no branco e 6,4:1 em `surface`; faixa 4,87:1; "Fechar filtros" em `accentStrong` |
| 10 | Sem `overflow` | passou | 390, 768 e 1280 px, com e sem o painel de filtros, título longo quebrando; release e debug sem asserção no console nem no log |
| 11 | Faixa de ambiente | passou | Figtree, sem sublinhado, altura pelo mesmo token `environmentBannerHeight` |
| 12 | `analyze` | passou | sem problemas |

## Pontos da implementação conferidos
- Faixa dentro de `Material`: necessário, a faixa fica fora do `Scaffold`. A cor continua `accent`.
- Editar e excluir fora do `InkWell` do card: o card tem `Semantics(button, onTap)` com `excludeSemantics`, e os botões ficam como irmãos, com tooltip próprio. Correto.
- "Fechar filtros" em `accentStrong`: comentário explica o porquê. Aceito.
- Título no diálogo de documento: mesmo `PanelDialogTitle` dos demais diálogos. Não conferido na tela (login).
- `FormLabel` com `crossAxisAlignment.start`: os usos anteriores (diálogos de publicação) ficam em `Column` com `start`, que dá largura solta, e o rótulo já encolhia ao texto; nada muda. O login não usa `FormLabel`.
- Card sem ano: "Documento sem arquivo, sem instituição, sem ano..." mostra só o autor, sem "null".

## Problemas encontrados
- **Ordem do Tab** (`library_list_page.dart`, ajuste): no desktop, o Tab saía de "Limpar Filtros" para um card do meio da lista, pela ordem de leitura. Corrigido com um `FocusTraversalGroup` nos filtros e outro no conteúdo (`fcdc94c`); conferido na tela: Limpar → primeiro card → segundo card.
- **Anel de foco cortado** (`library_list_page.dart`, ajuste): o card ocupa a largura da lista e o anel, desenhado por fora, sumia nas laterais e embaixo. Corrigido com folga na lista igual ao recuo do anel (`fcdc94c`); conferido na tela com o anel inteiro.

## Ressalvas
- O painel de filtros da área História lista também as categorias de Geografia (`DocumentCategory.values`). É comportamento de antes e fora do escopo da migração.

## Não conferido
- Criar, editar e excluir documento, "Criar documento", editar/excluir no card e o diálogo de documento: exigem login, sem credenciais de teste.
- Erro de carregamento com "Tentar de novo": não houve como cortar a rede no navegador embutido.
- Leitor de tela de verdade.
