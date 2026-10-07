# Tarefas da 023. Login e estrutura do painel nos tokens novos

Legenda: `- [ ]` a fazer, `- [x]` feita.

Os critérios citados são os da seção "Critérios de aceite" da spec, na ordem: 1 arquivos do painel sem tokens antigos; 2 componentes de `core/` sem tokens antigos; 3 sem valores soltos; 4 login funciona; 5 mostrar senha acessível; 6 abas funcionam; 7 barra lateral e teclado; 8 estado vazio; 9 contraste; 10 painel sem `overflow`; 11 telas públicas sem `overflow`; 12 `analyze`.

## Grupo A: tema
- [ ] **A1.** Criar a cor `info` (`#1E5AA8`) e os tokens do painel em `ComponentSizes`: `panelSidebarWidth` (304), `panelSidebarIcon` (28), `panelSidebarItemPadding` (16), `panelContentPadding(breakpoint)` (16/24/32), `panelSectionGap` (24), `signinCardMaxWidth` (440), `signinCardPadding(breakpoint)`, `loadingIndicatorSize` (32), `scrollbarThickness` e `scrollbarInset`. Arquivos: `app_colors.dart`, `app_dimensions.dart`. Atende: 3, 12.

## Grupo B: componentes de `core/`
- [ ] **B1.** `CircularLoading` e `LinearLoading` com tamanho e espaçamento de token, na cor `accent`. Arquivos: `loading/circular_loading.dart`, `loading/linear_loading.dart`. Atende: 2, 3.
- [ ] **B2.** `AppScrollbar` com espessura, raio, recuo e cor novos (`accentSoftBorder`). Arquivo: `scroll/app_scrollbar.dart`. Atende: 2, 3.
- [ ] **B3.** `AppIconButton` sem `.scale`: ícone no tamanho pedido e preenchimento `spacing.s8`. Arquivo: `buttons/app_icon_button.dart`. Atende: 2, 3.
- [ ] **B4.** `AppCard` com fundo `page`, borda `line`, raio `radii` e espaçamento padrão `spacing`; ícone de hover em `accent` com tamanho de token. Arquivo: `card/app_card.dart`. Atende: 2, 3.
- [ ] **B5.** `Messenger` com fundos `error`, `success` e `info` e texto branco no estilo `small` da tipografia nova. Arquivo: `utils/messenger/messenger.dart`. Atende: 2, 9.
- [ ] **B6.** Conferir no site público, em 390, 768 e 1280 px: menu do celular, vídeo da Home, diálogo de categorias do hero e biblioteca (lista e filtros). Atende: 11.

## Grupo C: login
- [ ] **C1.** Migrar a página de login: fundo `surface`; cartão com largura máxima `signinCardMaxWidth` e margem lateral no celular; título "LOGIN" em `h2`/`ink`; espaçamentos `spacing`; regra da senha em `small`/`inkSecondary`. Arquivo: `signin_page.dart`. Atende: 1, 3, 9, 10.
- [ ] **C2.** Trocar o `GestureDetector` do olho por `AppIconButton` com tooltip "Mostrar senha" / "Ocultar senha". Arquivo: `signin_page.dart`. Atende: 5.
- [ ] **C3.** Conferir: validação de e-mail e senha, aviso com credencial errada, login certo abre o painel, Tab percorre e-mail → senha → olho → "ENTRAR" com foco visível. Atende: 4, 5.

## Grupo D: barra lateral
- [ ] **D1.** `SidebarHeader` com espaçamento de token. Arquivo: `sidebar_header.dart`. Atende: 1, 3.
- [ ] **D2.** `SidebarMenuItem`: ícone `panelSidebarIcon` em `accent`; título em `h3`/`ink`; item selecionado com fundo `accentSoft`; subitens em `regular` (`inkSecondary`, ou `accent` quando selecionados); `AppFocusRing` no item e nos subitens. Arquivo: `sidebar_menu_item.dart`. Atende: 1, 3, 7, 9.
- [ ] **D3.** `ToggleCollpaseButton` vira `AppIconButton` com tooltip "Recolher menu" / "Expandir menu" (no celular, "Fechar menu"). Arquivo: `toggle_collpase_button.dart`. Atende: 1, 7.
- [ ] **D4.** `Sidebar`: largura aberta `panelSidebarWidth`, recolhida `panelSidebarIcon + 2 × panelSidebarItemPadding`, espaçamentos `spacing`. Arquivo: `sidebar_navigation.dart`. Atende: 1, 3, 10.

## Grupo E: painel e abas
- [ ] **E1.** `PanelPage`: barra do topo em `accent` com título em `h3` branco em todas as larguras; "Sair" com tamanho de token; recuo do conteúdo `panelContentPadding`. Arquivo: `panel_page.dart`. Atende: 1, 3, 9.
- [ ] **E2.** `SectionHeaderTitle` (título em `h2`/`accent`), `SectionHeaderActions` (espaçamentos `spacing`) e `FormLabel` (estilo `formLabel`, `ink`). Arquivos: `section_header_title.dart`, `section_header_actions.dart`, `form_label.dart`. Atende: 1, 3.
- [ ] **E3.** `CrudSection`: tokens novos e, com a lista vazia fora do carregamento, "Nenhum item cadastrado." centralizado em `regular`/`inkSecondary`. Arquivo: `sections/crud_section.dart`. Atende: 1, 3, 8.
- [ ] **E4.** `PostsSection`: tokens novos e estado vazio ("Nenhuma publicação encontrada." com qualquer filtro preenchido; "Nenhum item cadastrado." sem filtro). Arquivo: `sections/posts_section.dart`. Atende: 1, 3, 8.
- [ ] **E5.** `LibrarySection`: blocos de área em `accent` com texto branco `h3`, `InkWell` + `AppFocusRing` e espaçamentos `spacing`. Arquivo: `sections/library_section.dart`. Atende: 1, 3, 7.

## Grupo F: conferência final
- [ ] **F1.** Rodar a busca de tokens antigos do plano nos arquivos da tabela (nada encontrado) e procurar números soltos de cor, fonte e espaçamento. Atende: 1, 2, 3.
- [ ] **F2.** `fvm flutter analyze` sem erros novos e `fvm dart format` nos arquivos alterados. Atende: 12.
- [ ] **F3.** Em 390, 768 e 1280 px: todas as abas abrem e listam; "Criar" abre o diálogo; filtros de Publicações filtram e "Limpar filtros" limpa; barra recolhe e expande (desktop) e abre e fecha como menu (celular e tablet); "Sair" volta ao login; sem `overflow` nem rolagem horizontal. Atende: 6, 7, 10.
- [ ] **F4.** Percorrer por Tab a barra lateral, os subitens, "Sair", "Criar" e os blocos da biblioteca, com foco visível. Medir o contraste da regra da senha, dos subitens e do texto branco na barra do topo. Atende: 7, 9.
- [ ] **F5.** Ver uma aba sem itens (ou um filtro sem resultado em Publicações) mostrando a mensagem de vazio. Atende: 8.
