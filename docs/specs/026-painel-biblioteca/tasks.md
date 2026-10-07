# Tarefas da 026. Biblioteca do painel e faixa de ambiente nos tokens novos

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios da spec, na ordem: 1 arquivos sem tokens antigos; 2 sem valores soltos; 3 busca no projeto inteiro; 4 ações funcionam; 5 vazio com botões; 6 erro com tentar de novo; 7 teclado e nomes; 8 contraste; 9 sem `overflow`; 10 faixa de ambiente; 11 `analyze`.

## Grupo A: tema e faixa
- [ ] **A1.** Token `panelFiltersWidth` (300) em `ComponentSizes`. Arquivo: `app_dimensions.dart`. Atende: 2.
- [ ] **A2.** Faixa de ambiente com estilo `label` da tipografia nova. Arquivo: `environment_banner.dart`. Atende: 1, 8, 10.

## Grupo B: filtros e card
- [ ] **B1.** `Filters`: largura `panelFiltersWidth` no desktop e cheia no painel do celular e do tablet; fundo `surface` e borda `line`; "Filtros" em `h3`; grupos com `FormLabel`; espaçamentos `spacing`. Arquivo: `filters.dart`. Atende: 1, 2, 9.
- [ ] **B2.** `LibraryDocumentCard`: `InkWell` + `AppFocusRing` com nome "Abrir documento: <título>"; textos e ícone nos tokens novos; botões editar (`accent`) e excluir (`error`). Arquivo: `library_document_card.dart`. Atende: 1, 2, 7, 8.

## Grupo C: página e diálogo
- [ ] **C1.** `LibraryListPage`, barra do topo: `accent`, título `h3` branco, "Voltar" como `AppIconButton`. Painel de filtros do celular e do tablet limitado a `mobileMenuMaxWidth`. Arquivo: `library_list_page.dart`. Atende: 1, 7, 8.
- [ ] **C2.** `LibraryListPage`, estados: erro com `StateErrorInline` (tenta de novo chamando a busca); vazio com o texto e mantendo "Criar documento" e a fileira "Filtros"/"Carregar mais"; divisórias com `AppDivider`; espaçamentos `spacing`. Arquivo: `library_list_page.dart`. Atende: 1, 2, 5, 6.
- [ ] **C3.** Diálogo de documento: título com `PanelDialogTitle`, grupos com `FormLabel`, espaçamentos `spacing`. Arquivo: `create_or_update_document_dialog.dart`. Atende: 1, 2.

## Grupo D: conferência
- [ ] **D1.** Busca de tokens antigos nos arquivos da tabela do plano e no `lib/` inteiro (fora de `theme/`, `num_extension.dart` e dos arquivos sem uso da Fase 7). Atende: 1, 2, 3.
- [ ] **D2.** `fvm flutter analyze` sem erros novos e `fvm dart format`. Atende: 11.
- [ ] **D3.** Filtrar, limpar, carregar mais, criar, editar e excluir documento em Geografia e História. Atende: 4.
- [ ] **D4.** Filtro sem resultado: mensagem, "Filtros" e "Criar documento" visíveis. Sem rede: mensagem de erro e o botão recarrega ao voltar a rede. Atende: 5, 6.
- [ ] **D5.** Tab por "Voltar", filtros, "Aplicar Filtros", "Limpar Filtros", cards, editar, excluir, "Criar documento", "Filtros", "Carregar mais" e "Fechar filtros", com foco visível. Medir contraste dos textos secundários e da faixa. Atende: 7, 8.
- [ ] **D6.** Em 390, 768 e 1280 px, com e sem o painel de filtros aberto e com título longo: sem `overflow` nem rolagem horizontal. Faixa "Ambiente de Testes" no dev com a mesma altura. Atende: 9, 10.
