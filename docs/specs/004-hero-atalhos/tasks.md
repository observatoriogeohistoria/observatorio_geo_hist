# Tarefas da 004. Home: hero e atalhos

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo (rodado na cópia em caminho ASCII). Critérios numerados na ordem da spec (1 = ordem da Home, 14 = analyze/build).

## Grupo A: Tokens e botões
- [ ] **A1.** Criar os estilos `display` e `lead` em `AppTextStyles` e os tokens do hero em `ComponentSizes` (respiros por faixa, vão até os atalhos, larguras máximas do título e do texto de apoio, quadro e ícone dos atalhos, subida no hover, largura máxima da janela, opacidades, raio inicial e passo dos anéis), com comentário apontando a origem no protótipo. Arquivos: `app_text_styles.dart`, `app_dimensions.dart`. Conferir: analyze limpo; valores conferem com o plano. Atende: critério 13.
- [x] **A2.** Parâmetro opcional `trailingIcon` em `AppButtonBase`, repassado por `PrimaryButton` e `SecondaryButton` (ícone após o texto, 8 px de vão, cor do texto, excluído da semântica). Arquivos: `app_button_base.dart`, `primary_button.dart`, `secondary_button.dart`. Conferir: sem o parâmetro, o botão fica idêntico (mesma altura e padding). Atende: critérios 2 e 13. *Nota: `trailingIcon` só troca o `Text` por uma `Row` quando é passado; sem ele, a árvore é a mesma. Tamanho do ícone relativo ao texto pelo token `buttonIconScale` (1,15 em, como no protótipo).*

## Grupo B: Hero
- [ ] **B1.** `HeroBackgroundPainter`: anéis concêntricos (acento no canto superior direito, `ink` no inferior esquerdo) com esmaecimento para a base, dentro de `ExcludeSemantics` + `RepaintBoundary`. Arquivo: `components/hero/hero_background_painter.dart`. Conferir: desenho visível e suave, sem foco nem leitura. Atende: critérios 2 e 10.
- [ ] **B2.** `HeroShortcutCard`: variantes horizontal e vertical, hover (borda acento, subida 2 px, sombra `soft`; sem subida e sem transição com movimento reduzido), `AppFocusRing`, `Semantics` botão/link com rótulo composto, ícones decorativos. Arquivo: `components/hero/hero_shortcut_card.dart`. Atende: critérios 10, 11 e 12.
- [ ] **B3.** `AreaCategoriesDialog` + função para abri-la com `showDialog`: título "Categorias de História/Geografia" (nome da rota para leitor de tela), `AppIconButton` "Fechar", `NavbarCategoriesMenu` rolável com `onSelected` fechando a janela, largura máxima do token, margem de 16 px no celular, véu `ink` com `scrimOpacity`. Arquivo: `components/hero/area_categories_dialog.dart`. Conferir: Esc, clique fora e "Fechar" fecham; foco volta ao atalho. Atende: critérios 5, 6, 7 e 8.
- [ ] **B4.** `HomeHero`: fundo `surface` com linha `line` na base e o painter; rótulo (`label`, `accentStrong`, caixa alta), título `display` com "em um só lugar." em `accent` e `Semantics(header: true)`, texto `lead` em `inkSecondary`, `Wrap` com "Explorar a biblioteca" (primário, seta, `/biblioteca`) e "Ler o manifesto" (secundário, `/manifest`), e os três atalhos (celular: coluna; tablet: três colunas verticais; desktop: três colunas horizontais) com `IntrinsicHeight`. Tudo dentro de `PageContent`. Arquivo: `components/hero/home_hero.dart`. Atende: critérios 2, 3, 4, 5, 9, 12 e 13.

## Grupo C: Home
- [ ] **C1.** Inserir `HomeHero` como primeiro sliver depois do `NavbarSliver`, sem `deferred`; demais slivers intactos, cada um com comentário da spec que o redesenha (005 a 009). Arquivo: `pages/home_page.dart`. Conferir: todos os blocos antigos continuam aparecendo. Atende: critério 1.
- [ ] **C2.** Atualizar `docs/arquitetura.md` (hero e janela de categorias na Home). Atende: documentação.

## Grupo D: Conferência
- [ ] **D1.** `fvm flutter analyze` (cópia ASCII) e `fvm flutter build web --release` sem erro; busca por `.scale`, `.fontSize`, `.verticalSpacing`, `Color(0x` e números de tamanho soltos nos arquivos novos sem ocorrências. Atende: critérios 13 e 14.
- [ ] **D2.** Rodar o app (build servido por Python com fallback de SPA, navegador embutido) em **390, 768 e 1280 px**: textos exatos do hero, layout dos atalhos por faixa, largura máxima em 1280, sem rolagem horizontal (`scrollWidth` = largura) e sem `overflow` no console; botões e atalho Biblioteca levam às rotas certas; janela de História e de Geografia (categorias reais, Expogeo/Geoensine primeiro), escolher categoria abre a página e deixa o item da navbar ativo; Tab/Enter/Esc e foco de volta ao atalho; hover dos cartões; contraste dos textos conferido. Voltar o navegador ao preset desktop e parar o servidor no fim. Atende: critérios 1 a 12.
- [ ] **D3.** Conferir por amostragem outras telas com botões (Contato, Biblioteca, 404, Manifesto) para garantir que o `trailingIcon` não mudou nada. Atende: critério 13 (regressão do componente compartilhado).
