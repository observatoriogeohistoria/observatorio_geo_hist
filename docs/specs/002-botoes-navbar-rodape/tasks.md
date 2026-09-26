# Tarefas da 002. Botões, navbar e rodapé

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo. Pré-requisito: grupos B a E da [001](../001-fundacao/tasks.md) concluídos. Pontos P1 a P6 do [plano](plan.md) aprovados em 2026-09-26.

## Grupo A: Bases compartilhadas
- [ ] **A1.** Tokens de componente em `AppDimensions`: altura da navbar (68), altura mínima de botão (40 pequeno, 44 médio/grande), tamanho do ícone de menu, largura máxima do painel do dropdown, duração das animações de menu. Arquivo: `lib/app/theme/app_dimensions/app_dimensions.dart`. Conferir: valores da spec presentes, nenhum valor antigo alterado no `git diff`. Atende: critério 15 (só tokens).
- [ ] **A2.** Criar `AppFocusRing`: envolve um filho e desenha o contorno de 3 px, afastado 2 px, na cor de acento (tokens `focus` da 001), só quando o foco vem do teclado, sem alterar o layout. Arquivo: `lib/app/core/components/focus/app_focus_ring.dart`. Conferir: numa tela provisória, Tab mostra o anel e o clique do mouse não. Atende: critérios 1 e 13.
- [ ] **A3.** `openUrl` com parâmetro opcional para abrir na mesma aba (`mailto:` e `tel:`), sem mudar o comportamento atual. Em `AppStrings`: endereço sem CEP (do protótipo), os dois telefones separados, e os links `mailto:` e `tel:` derivados das constantes. Arquivos: `lib/app/core/utils/url/url.dart`, `lib/app/core/utils/constants/app_strings.dart`. Conferir: usos atuais de `openUrl` e de `AppStrings.address/phones` seguem iguais (busca por uso). Atende: critério 11.

## Grupo B: Botões (0.4)
- [ ] **B1.** Criar `AppButtonBase` (tipo, tamanho, texto, `onPressed`, `isDisabled`): `Material`+`InkWell`, cantos 10, altura mínima por tamanho, texto de 14/16/18 dos estilos novos, quebra de linha sem corte, `AppFocusRing`, cursor de clique, `Semantics(button, enabled)`, ocupa a largura toda quando o pai aperta. Estados de cor por tipo conforme a tabela da spec. Arquivo: `lib/app/core/components/buttons/app_button_base.dart`. Conferir: ainda sem uso; compila. Atende: critério 1.
- [ ] **B2.** `PrimaryButton` sobre a base, mesma API (`.small/.medium/.big`, `text`, `onPressed`, `isDisabled`) e mesmo `ButtonSize`. Repouso acento, hover acento forte, texto branco. Arquivo: `.../buttons/primary_button.dart`. Conferir: Enter e Espaço acionam; desativado não foca nem clica. Atende: critérios 1 e 2.
- [ ] **B3.** `SecondaryButton` sobre a base (borda e texto na cor do texto principal; hover com fundo escuro e texto branco). Arquivo: `.../buttons/secondary_button.dart`. Conferir: igual a B2. Atende: critérios 1 e 2.
- [ ] **B4.** `AppTextButton` (discreto) sobre a base: texto laranja, hover com fundo `accentSoft`, **foco por teclado** (hoje usa `GestureDetector`). Arquivo: `.../buttons/app_text_button.dart`. Conferir: Tab chega, anel aparece, Enter/Espaço acionam. Atende: critérios 1 e 2.
- [ ] **B5.** Tela de teste provisória com os 3 tipos × 3 tamanhos × (repouso, hover, foco, desativado, texto longo), em 390/768/1280 px, comparada com a aba "Fundamentos" do protótipo. Arquivos: `lib/app/dev/buttons_preview_page.dart` + rota provisória (removidas em H4). Conferir: visual igual ao protótipo, sem `overflow`. Atende: critério 1.
- [ ] **B6.** Regressão dos botões: abrir painel admin (login, uma aba com `AppTextButton.small` em `section_header_actions.dart`), filtros da biblioteca (`filters.dart`), Geoensine e site público. Corrigir `overflow` ou quebras de linha causados pela altura mínima. Conferir: nenhuma tela com erro amarelo/preto em 390, 768 e 1280. Atende: critérios 3 e 16.

## Grupo C: Botões de ícone e nome acessível (0.4)
- [ ] **C1.** `AppIconButton` e `CustomIconButton`: `AppFocusRing`, tamanho mínimo tocável e novo parâmetro `tooltip` (que vira `Tooltip` + `Semantics`). Começar **opcional** para manter o app compilando. Arquivos: `.../buttons/app_icon_button.dart`, `custom_icon_button.dart`. Conferir: foco visível com Tab. Atende: critérios 13 e 2.
- [ ] **C2.** Dar `tooltip` a todos os usos de `AppIconButton` (~28: cards do painel, `panel_page`, `filters`, `library_document_card`, `app_video_player`, `full_screen_dialog`, `navbar`...) e de `CustomIconButton` (~8: `team`, `highlights`, `highlights_dialog_carousel`, `library_document_viewer`). Textos em português ("Editar", "Excluir", "Anterior", "Próximo"...). Conferir: `grep` sem usos sem `tooltip`. Atende: critério 13.
- [ ] **C3.** Tornar `tooltip` obrigatório nos dois widgets. Conferir: `analyze` limpo prova que nenhum uso ficou sem nome. Atende: critério 13.

## Grupo D: Logo (0.4/decisões)
- [ ] **D1.** Extrair a marca do protótipo (círculos concêntricos) e criar `assets/images/logo.svg`, com cores da marca e sem texto. Conferir: abre no navegador, nítido em qualquer zoom, sem depender de fonte. Atende: critério 4.
- [ ] **D2.** Criar `AppLogo`: marca + "Observatório" + "Ensino de História e Geografia" (o subtítulo some abaixo de 600 px), versões para fundo claro e escuro, clique leva à Home, foco visível, `Semantics(label: 'Observatório do Ensino de História e Geografia, início')`. Arquivo: `lib/app/core/components/logo/app_logo.dart`. Conferir: nítido em 1× e 2× (zoom 200% e tela retina). Atende: critério 4.

## Grupo E: Navbar (0.5)
- [ ] **E1.** Criar `NavbarItem` (texto, `isActive` com laranja + sublinhado de 2 px, foco com `AppFocusRing`, hover, `Semantics` com `expanded` quando abre menu). Arquivo: `lib/app/core/components/navbar/navbar_item.dart`. Conferir: tela provisória com item ativo, inativo, com foco e com menu. Atende: critérios 6 e 13.
- [ ] **E2.** Reescrever `Navbar`: 68 px, fundo branco translúcido com linha fina na base, dentro de `PageContent`; `AppLogo` + itens em ≥ 1024, `AppLogo` + botão de menu em < 1024. Item ativo calculado aqui (rota via `GoRouterState`, área via `selectedCategory`; Biblioteca também em subrotas, ponto P5). Criar também `NavbarSliver` (`SliverPersistentHeader` fixo). Ainda sem os menus novos: usar o dropdown atual. Arquivo: `.../navbar/navbar.dart`. Conferir: em uma página de teste, a barra fica fixa ao rolar e os itens ativam pela rota. Atende: critérios 5 e 6.
- [ ] **E3.** `NavbarCategoriesMenu`: conteúdo por estado (**carregando** com linhas de esqueleto, **vazio** "Nenhuma categoria por enquanto" desativado, **erro** "Não foi possível carregar as categorias" + "Tentar de novo" que chama `fetchCategories()`, **lista** com categoria atual marcada). Em Geografia, Expogeo e Geoensine (ícone de link externo, nome "abre em outra aba") vêm antes, com divisor. Nome longo quebra em duas linhas. Arquivo: `.../navbar/navbar_categories_menu.dart`. Conferir: os quatro estados numa tela provisória, forçando o estado do store. Atende: critérios 8 e 10.
- [ ] **E4.** `NavbarDropdown` novo: visual (raio, sombra elevada, borda), abre por hover e por clique/toque/Enter/Espaço/seta para baixo, fecha por saída do mouse, clique fora, Esc e escolha; alinha à direita perto da borda; rolagem interna; usa `NavbarCategoriesMenu`; sem animação com movimento reduzido. Arquivo: `.../navbar/navbar_dropdown.dart` e ligação em `navbar.dart`. Conferir: em 1024 e 1280, hover e clique abrem/fecham; menu perto da borda direita não sai da tela. Atende: critério 7.
- [ ] **E5.** Teclado do dropdown: Enter/Espaço/seta para baixo abrem e levam ao primeiro item; setas sobem/descem; Esc fecha e devolve o foco ao item; Tab sai e fecha; menu aberto por hover não fecha sob quem tem foco dentro. Conferir: percurso completo só com teclado (Tab até História, abrir, escolher categoria, chegar na página). Atende: critérios 7 e 13.
- [ ] **E6.** Aplicar `NavbarSliver` nas páginas: `home_page`, `posts_page`, `post_detailed_page`, `library_page`, `contact_us_page`, `manifest_page`, `team_member_page`, `collaborate_page`. Conferir: em cada uma, rolar e ver a barra fixa; a categoria escolhida continua marcada ao navegar. Atende: critérios 5 e 6.
- [ ] **E7.** Pontos P1 e P3: `PageNotFound` ganha `Navbar` (sem sliver, no topo de uma coluna) e `Footer` no fim; `library_document_detailed_page` troca `LibraryNavbar` por `NavbarSliver` e `LibraryNavbar` é removido. Conferir: 404 com navbar e rodapé; detalhe de documento com navbar fixa. Atende: critério 5.

## Grupo F: Menu de celular e tablet (0.5)
- [ ] **F1.** Reescrever `NavbarMobileMenu` como painel sobre a página: Sobre, História e Geografia (sanfonas com `NavbarCategoriesMenu`, Expogeo/Geoensine primeiro na de Geografia), Biblioteca; item ativo recebido da `Navbar`; botão "Fechar menu"; Esc e toque fora fecham; escolher uma opção fecha e navega; sem animação com movimento reduzido. Arquivo: `.../dialog/navbar_mobile_menu.dart`, ajuste em `navbar.dart`. Conferir: em 390 e 768 abre, expande, navega e fecha de todas as formas. Atende: critério 9.
- [ ] **F2.** Acessibilidade do painel: botão de menu com nome "Abrir menu"/"Fechar menu" e estado expandido; foco fica dentro do painel e volta ao botão ao fechar (Tab, Shift+Tab, Esc). Conferir: percurso só com teclado. Atende: critérios 9 e 13.
- [ ] **F3.** Limpeza: buscar usos e remover `navbar_menu.dart`, `navbar_sub_menu.dart` e `full_screen_dialog.dart` se ficarem sem uso (conferir se o `NavButton` ainda tem uso antes de decidir). Conferir: `grep` sem referências, `analyze` limpo. Atende: critério 17.

## Grupo G: Rodapé (0.6)
- [ ] **G1.** Ícones de Instagram, Facebook e YouTube em SVG monocromático e `SocialButtons` com foco visível, `Semantics`/tooltip ("Instagram", "Facebook", "YouTube"), abrindo em outra aba, versão para fundo escuro. Arquivos: `assets/icons/{instagram,facebook,youtube}.svg`, `.../buttons/social_buttons.dart`. Conferir: o uso antigo em `LibraryNavbar` (removido em E7) não deixa referência solta; `Support` não muda. Atende: critérios 11 e 13.
- [ ] **G2.** Reescrever `Footer` (fundo escuro, dentro de `PageContent`): colunas Marca (logo escuro + endereço + redes), Explorar (Sobre, Biblioteca), Institucional (Manifesto, Equipe → Home, Fale com a gente), Contato (e-mail `mailto:`, dois telefones `tel:`). Faixa inferior com ano de `DateTime.now().year` e a licença Creative Commons. Links com foco visível e mudança de cor no hover. Sem "Colabore" e sem "Nossa história". 4 colunas em ≥ 1024, 2 em 600–1023, 1 abaixo. Arquivo: `.../footer/footer.dart`. Conferir: cada link leva ao destino certo; e-mail e telefones abrem o app correspondente; nenhum ano escrito no código. Atende: critérios 11 e 12.
- [ ] **G3.** Conferir o rodapé em todas as telas que o usam (home com carregamento adiado, lista/detalhe de post, biblioteca, detalhe de documento, contato, manifesto, membro, colaborar, 404) em 390, 768 e 1280. Conferir: sem `overflow`, sem rolagem horizontal, `Footer` no fim de cada página. Atende: critérios 11 e 16.

## Grupo H: Verificação e limpeza
- [ ] **H1.** Contraste: script na pasta temporária (fora do projeto) com as razões WCAG de branco sobre acento (repouso) e sobre acento forte (hover), acento sobre branco (item ativo) e sobre `accentSoft`, texto do rodapé e destaque sobre o fundo escuro, texto secundário. Guardar os valores para o `verificacao.md`. Se algum falhar, propor ajuste e registrar na spec antes de mudar a cor. Atende: critério 14.
- [ ] **H2.** Passada de tokens: `grep` nos arquivos novos/alterados por cores (`Color(`, `Colors.`), números soltos de fonte/espaçamento e `num_extension`. Conferir: nenhum achado fora do que for token (transparências de `Colors.black` viram token de sombra). Atende: critério 15.
- [ ] **H3.** Conferência final nas 3 larguras, com teclado e com "reduzir movimento" ligado no sistema: navbar (fixa, ativo, menus, painel), botões, rodapé, painel admin abrindo sem erro. Rodar `fvm flutter analyze` na cópia ASCII. Conferir: todos os critérios da spec marcáveis. Atende: critérios 3, 5 a 10, 16 e 17.
- [ ] **H4.** Remover as telas e rotas provisórias (`lib/app/dev/buttons_preview_page.dart` e a rota, sem tocar em nada da 001 que ainda esteja lá). Conferir: `git status` sem arquivos provisórios, `analyze` limpo. Atende: critério 17.

## Cobertura dos critérios de aceite
| # | Critério | Tarefas |
|---|---|---|
| 1 | Botões: tipos, tamanhos e estados | A2, B1–B5 |
| 2 | Enter/Espaço; discreto com foco | B2–B4, C1 |
| 3 | Admin e site abrem sem erro | B6, H3 |
| 4 | Logo SVG na navbar e no rodapé, nítido | D1, D2 |
| 5 | Navbar fixa em todas as páginas | E2, E6, E7 |
| 6 | Item ativo laranja e sublinhado | E1, E2, E6 |
| 7 | Menus desktop: hover, teclado, fechamento | E4, E5 |
| 8 | Geografia: Expogeo e Geoensine, divisor, outra aba | E3 |
| 9 | Menu de celular/tablet | F1, F2 |
| 10 | Estados carregando, vazio e erro | E3 |
| 11 | Rodapé em 4/2/1 colunas, links clicáveis | A3, G1, G2, G3 |
| 12 | Ano dinâmico | G2 |
| 13 | Foco visível e nome acessível em todo clicável | A2, C1–C3, E1, E5, F2, G1 |
| 14 | Contraste ≥ 4,5:1 | H1 |
| 15 | Só tokens, sem `num_extension` | A1, H2 |
| 16 | Sem rolagem horizontal nem `overflow` | B6, G3, H3 |
| 17 | `analyze` sem novos avisos | todas, F3, H3, H4 |
