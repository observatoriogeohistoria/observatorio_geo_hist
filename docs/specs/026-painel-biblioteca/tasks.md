# Tarefas da 026. Biblioteca do painel e faixa de ambiente nos tokens novos

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios da spec, na ordem: 1 arquivos sem tokens antigos; 2 sem valores soltos; 3 busca no projeto inteiro; 4 ações funcionam; 5 vazio com botões; 6 erro com tentar de novo; 7 card do documento por teclado; 8 teclado e nomes; 9 contraste; 10 sem `overflow`; 11 faixa de ambiente; 12 `analyze`.

## Grupo A: tema e faixa
- [x] **A1.** Token `panelFiltersWidth` (300) em `ComponentSizes`. Arquivo: `app_dimensions.dart`. Atende: 2. Também `panelLibraryDocIcon` (32) para o ícone do card.
- [x] **A2.** Faixa de ambiente com estilo `label` da tipografia nova. Arquivo: `environment_banner.dart`. Atende: 1, 9, 11. Dentro de um `Material` para não herdar o sublinhado de erro.

## Grupo B: filtros e card
- [x] **B1.** `Filters`: largura `panelFiltersWidth` no desktop e cheia no painel do celular e do tablet; fundo `surface` e borda `line`; "Filtros" em `h3`; grupos com `FormLabel`; espaçamentos `spacing`. Arquivo: `filters.dart`. Atende: 1, 2, 10. "Fechar filtros" em `accentStrong` (contraste).
- [x] **B2.** `LibraryDocumentCard`: `InkWell` + `AppFocusRing` com nome "Abrir documento: <título>"; textos e ícone nos tokens novos; botões editar (`accent`) e excluir (`error`). Arquivo: `library_document_card.dart`. Atende: 1, 2, 7, 8, 9. Botões fora da área clicável do card; `Semantics` com `onTap` para o leitor de tela acionar.

## Grupo C: página e diálogo
- [x] **C1.** `LibraryListPage`, barra do topo: `accent`, título `h3` branco, "Voltar" como `AppIconButton`. Painel de filtros do celular e do tablet limitado a `mobileMenuMaxWidth`. Arquivo: `library_list_page.dart`. Atende: 1, 8, 9.
- [x] **C2.** `LibraryListPage`, estados: erro com `StateErrorInline` (tenta de novo chamando a busca); vazio com o texto e mantendo "Criar documento" e a fileira "Filtros"/"Carregar mais"; divisórias com `AppDivider`; espaçamentos `spacing`. Arquivo: `library_list_page.dart`. Atende: 1, 2, 5, 6. Vazio com `EmptyListMessage` da 023.
- [x] **C3.** Diálogo de documento: título com `PanelDialogTitle`, grupos com `FormLabel`, espaçamentos `spacing`. Arquivo: `create_or_update_document_dialog.dart`. Atende: 1, 2. Título "Criar documento"/"Atualizar documento".

## Grupo D: conferência
- [x] **D1.** Busca de tokens antigos nos arquivos da tabela do plano e no `lib/` inteiro (fora de `theme/`, `num_extension.dart` e dos arquivos sem uso da Fase 7). Atende: 1, 2, 3. Arquivos da tabela limpos. No `lib/` inteiro, sobram só `theme/`, `num_extension.dart`, os arquivos sem uso da Fase 7 e os componentes de texto Dosis de `core/components/text/`, usados só por esses arquivos (saem juntos na Fase 7).
- [x] **D2.** `fvm flutter analyze` sem erros novos e `fvm dart format`. Atende: 12. `analyze` sem problemas (cópia em caminho sem acento).
- [x] **D3.** Filtrar, limpar, carregar mais, criar, editar e excluir documento em Geografia e História. Atende: 4. Filtrar, filtro sem resultado, limpar e carregar mais conferidos na tela (release). Criar, editar e excluir não conferidos: exigem login; fluxo e chamadas ao store intocados.
- [x] **D4.** Filtro sem resultado: mensagem, "Filtros" e "Criar documento" visíveis. Sem rede: mensagem de erro e o botão recarrega ao voltar a rede. Atende: 5, 6. Vazio conferido (mensagem e "Filtros"; "Criar documento" só com login, conferido no código). Erro de carregamento não conferido na tela: não deu para cortar a rede no navegador embutido.
- [x] **D5.** Tab por "Voltar", filtros, "Aplicar Filtros", "Limpar Filtros", cards, editar, excluir, "Criar documento", "Filtros", "Carregar mais" e "Fechar filtros", com foco visível. Enter no card abre o documento. Medir contraste dos textos secundários e da faixa. Atende: 7, 8, 9. Foco visível no card e Enter abre o documento; "Filtros" e "Fechar filtros" (Esc) conferidos. Nomes acessíveis conferidos no código (a árvore de acessibilidade do Flutter não abriu no navegador embutido). Editar, excluir e "Criar documento" exigem login. Contraste: `inkSecondary` 7,0:1 no branco e 6,4:1 no `surface`; faixa 4,87:1; "Fechar filtros" em `accentStrong`.
- [x] **D6.** Em 390, 768 e 1280 px, com e sem o painel de filtros aberto e com título longo: sem `overflow` nem rolagem horizontal. Faixa "Ambiente de Testes" no dev com a mesma altura. Atende: 10, 11. Sem `overflow` em 390, 768 e 1280, com e sem o painel de filtros e com título longo (release e debug, sem asserções). Faixa com 32 px, em Figtree.
