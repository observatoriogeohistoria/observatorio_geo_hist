# Tarefas da 009. Home: realização e apoio, chamada para contato

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo (rodado na cópia em caminho ASCII do scratchpad). Critérios numerados na ordem da spec (1 = blocos na Home, 18 = tokens/analyze/build).

## Grupo A: Dados e tokens
- [x] **A1.** Conferir os 9 sites da tabela da spec com `curl -sIL` (e no navegador embutido os que falharem no `curl`); criar o enum `Partner` na ordem do protótipo, com `acronym`, `fullName`, `url` (`null` para site que não abriu) e `assetPath`; apagar `partners_images.dart` e trocar os usos. Arquivos: `core/utils/enums/partner.dart`, `core/utils/enums/partners_images.dart` (apagar), `components/partners.dart` e `support/support.dart` (só o import e o nome, provisório até B3/B4). Conferir: sites anotados aqui como abertos ou não. Atende: critérios 2 e 5. Feito: os 9 sites abrem (8 com 200 no `curl`; `gov.br/cnpq` dá 403 ao `curl` e abre no navegador), nenhum `url` nulo.
- [ ] **A2.** Tokens dos logos e da chamada em `ComponentSizes` e estilo `ctaTitle`, com comentário de origem no protótipo (`.logos`, `.logo`, `.cta`); constante `AppRoutes.contact`. Arquivos: `app_dimensions.dart`, `app_text_styles.dart`, `core/routes/app_routes.dart`. Conferir: valores iguais ao plano. Atende: critérios 3, 4, 10 e 18.

## Grupo B: Realização e apoio
- [x] **B1.** `PartnerLogo`: área com padding e raio, logo em proporção fixa com `contain` e largura ≤ 150; repouso cinza a 55 %; hover e foco com cor, escala 1,05, subida de 3 px, fundo `page`, borda `line` e sombra `soft`; com `url`: link com nome completo, `AppFocusRing`, `InkWell` com `openUrl`, cursor de mão; sem `url`: imagem com nome completo, sem foco; `errorBuilder` com a sigla; movimento reduzido sem subir nem crescer; altura ≥ 44 px. Arquivo: `core/components/partners/partner_logo.dart`. Atende: critérios 4, 5, 6 e 12. Feito; o efeito do foco só vale com teclado (`FocusHighlightMode.traditional`), para o clique não deixar o logo aceso.
- [x] **B2.** `PartnerLogoGrid`: colunas `floor((largura + 12) / (mínimo + 12))`, mínimo 1, `Row` + `Expanded`, 12 px entre logos, última linha completada com vazios; `minColumnWidth` configurável. Arquivo: `core/components/partners/partner_logo_grid.dart`. Atende: critérios 3 e 8. Feito.
- [x] **B3.** `PartnersSection` (fundo `page`, `PageContent`, respiro de seção em cima e embaixo, "Realização e apoio" `h2` com `Semantics(header)`, grade de 150 px) no lugar de `Partners` na Home, na Biblioteca e em Colabore; apagar `components/partners.dart`. Arquivos: `core/components/partners/partners_section.dart`, `home_page.dart`, `library_page.dart`, `collaborate_page.dart`, `components/partners.dart` (apagar). Conferir: `git grep "components/partners.dart"` sem resultado. Atende: critérios 1, 2, 7 e 12. Feito.
- [x] **B4.** `Support` do post: trocar a grade de 4 `AppCard` pela `PartnerLogoGrid` de 130 px com os 9 `Partner.values`; redes sociais, divisória, título "APOIO" e fundo sem mudança; remover imports sem uso. Arquivo: `core/components/support/support.dart`. Conferir: `git diff` só na grade. Atende: critério 8. Feito; `flutter_staggered_grid_view` segue em uso em `posts_section_list.dart`.

## Grupo C: Chamada, espaços e documentação
- [ ] **C1.** `ContactCallSection`: quadro `accentSoft`, raio 20, padding 28/46/56; título `ctaTitle`/`ink` com `Semantics(header)` e largura máxima; texto `regular`/`inkSecondary` 8 px abaixo com largura máxima; `PrimaryButton.medium('Fale com a gente')` com seta → `go(AppRoutes.contact)`; `Row` no desktop (centralizada, ≥ 24 px entre textos e botão) e `Column` alinhada à esquerda abaixo de 1024 px ou com texto ≥ 130 %; respiro de seção só embaixo. Arquivo: `features/home/presentation/components/contact_call/contact_call_section.dart`. Atende: critérios 9, 10, 13 e 14.
- [ ] **C2.** Home: import adiado de `contact_call_section` no lugar de `contact_us`; apagar `contact_us.dart`; tirar os comentários "redesenho na spec 009"; `TeamSection` com respiro de baixo 0. Arquivos: `home_page.dart`, `components/contact_us.dart` (apagar), `components/team/team_section.dart`. Conferir: ordem Equipe → Realização e apoio → chamada → rodapé; `git grep "contact_us.dart"` só com `contact_us_page.dart`. Atende: critérios 1 e 11.
- [ ] **C3.** Documentação: seção "Home" e tabela de features de `docs/arquitetura.md` com Realização e apoio (compartilhado com Biblioteca, Colabore e post) e a chamada. Atende: documentação.

## Grupo D: Conferência
- [ ] **D1.** `fvm flutter analyze` (cópia ASCII) e `fvm flutter build web --release` sem erro; busca por `.scale`, `.fontSize`, `.verticalSpacing`, `Color(0x` e números de tamanho soltos nos arquivos novos sem ocorrências (fora dos tokens e da matriz de cinza); `git diff` sem mudança em `app_router.dart`, `contact_us_page.dart`, modelos, datasources e `features/admin`. Atende: critérios 17 e 18.
- [ ] **D2.** Testes de widget **temporários, só na cópia do scratchpad** (`test/partners_contact_test.dart`): grade com 6/4/2 colunas em 1280/768/390 (posições, 12 px, última linha à esquerda) e com 130 px no `Support`; ordem dos 9; semântica (link com nome completo; sem `url` → imagem fora do Tab); Tab percorre os logos na ordem e ativa o efeito; Enter e toque semântico chamam `openUrl` (canal do `url_launcher` simulado); logo com asset inexistente mostra a sigla com a mesma altura; movimento reduzido sem escala nem subida; chamada em `Row` a 1280 e `Column` a 768/390 e a 200 %; botão navega para `/contato` com `GoRouter`; nenhuma exceção de `overflow` a 100 % e 200 %. Anotar o número de testes. Atende: critérios 3 a 6, 9, 10, 12 e 14.
- [ ] **D3.** Rodar o app **com dados simulados** (só na cópia): `lib/main_home_preview.dart` igual ao `main.dart`, trocando no GetIt os repositórios de destaques e equipe por falsos escolhidos por `?home=cheio|vazio|lento|erro` (3 destaques e 7 membros no `cheio`); build com `-t`, servido por Python com fallback de SPA, no navegador embutido em **390, 768 e 1280 px**. Conferir a **Home inteira** contra o protótipo: ordem das seções (navbar, hero, Destaques, Quem somos, Vídeo, Nossa história, Equipe, Realização e apoio, chamada, rodapé), respiros entre blocos (um só entre Equipe, logos, chamada e rodapé; medir pelo `getBoundingClientRect` da árvore de semântica ou por captura), transições de fundo sem linha solta, colunas dos logos, hover dos logos (cor, subida, sombra), chamada lado a lado só no desktop; `lento` → esqueletos de Destaques e Equipe; `erro` → mensagens e "Tentar de novo"; `vazio` → Destaques e Equipe somem e Realização e apoio não encosta em Nossa história; `scrollWidth` igual à largura; console sem `overflow`; contraste calculado da chamada. Atende: critérios 1 a 4, 9 a 11, 13, 15 e 16.
- [ ] **D4.** Rodar o **app real** (build de `main.dart`, Firebase de testes) em **390, 768 e 1280 px**: Home (sem destaques e sem membros: Realização e apoio com respiro acima), `/biblioteca` e `/colaborar` com o bloco novo sem `overflow` nem linha solta, um post aberto pela navegação com o `Support` mostrando os 9 logos, clique num logo abre o site em outra aba, botão da chamada abre `/contato` e a página continua igual, `scrollWidth` igual à largura e console sem `overflow` em todas. Voltar o navegador ao preset desktop, parar os servidores e confirmar com `git status` na pasta original que nenhum arquivo de teste ou de pré-visualização entrou no repositório. Painel admin: não se aplica (nada muda nele; conferido pelo `git diff` da D1). Atende: critérios 1, 5, 7, 8, 11, 15 e 17.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1 | B3, C2, D3, D4 |
| 2 | A1, B3, D2, D3 |
| 3 | A2, B2, D2, D3 |
| 4 | A2, B1, D2, D3 |
| 5 | A1, B1, D2, D4 |
| 6 | B1, D2 |
| 7 | B3, D4 |
| 8 | B2, B4, D2, D4 |
| 9 | C1, D2, D3 |
| 10 | A2, C1, D2, D3 |
| 11 | C2, D3, D4 |
| 12 | B1, B3, D2 |
| 13 | C1, D3 |
| 14 | C1, D2 |
| 15 | D3, D4 |
| 16 | D3 |
| 17 | D1, D4 |
| 18 | A2, D1 |
