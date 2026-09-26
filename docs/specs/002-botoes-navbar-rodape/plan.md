# Plano da 002. Botões, navbar e rodapé

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-09-26

## Pré-requisito
A 002 usa os tokens da [001](../001-fundacao/spec.md): cores por função (`ink`, `accent`, `accentStrong`, `accentSoft`, `footer*`...), `spacing`/`radii`/`shadows`/`focus`, `AppTextStyles`, `Breakpoint` e `PageContent`. Em 2026-09-26 só o grupo A (fontes) da 001 estava feito. **Os grupos B, C, D e E da 001 precisam estar concluídos antes de começar a 002.** Se preferir paralelizar, as tarefas B a D abaixo podem começar assim que B1, C1 e D2 da 001 existirem.

## Abordagem
Trocar o "casco" sem mexer nas páginas, **preservando as APIs públicas** para que os cerca de 50 pontos de uso dos botões (site e painel admin) ganhem o visual novo sem alteração:

- **Botões:** `PrimaryButton.small/medium/big`, `SecondaryButton.*` e `AppTextButton.*` (o "discreto") mantêm nomes e parâmetros. Por dentro passam a usar uma base comum (`AppButtonBase`) feita com `Material` + `InkWell` (Enter/Espaço, foco por teclado e semântica de "desativado" vêm do Flutter) e um **anel de foco** compartilhado. Tamanhos fixos, sem `num_extension`.
- **Anel de foco (`AppFocusRing`):** widget único (3 px, afastado 2 px, cor de acento, só quando o foco vem do teclado) usado por botões, itens da navbar, opções do menu, links e ícones do rodapé. Assim o foco fica igual em todo lugar e o critério "todo clicável tem foco visível" se resolve num ponto.
- **Logo:** um SVG local com a marca (círculos concêntricos, tirado do protótipo) e um widget `AppLogo` (marca + "Observatório" + subtítulo opcional, versão clara e escura). Substitui `logo.webp` na navbar e no rodapé.
- **Navbar fixa:** hoje cada página coloca `Navbar` dentro de um `CustomScrollView` como `SliverToBoxAdapter`. Fixar = trocar essa linha por `NavbarSliver` (um `SliverPersistentHeader(pinned: true)` de 68 px). É uma linha por página, sem mexer no resto delas. O `Navbar` em si continua um widget de caixa, para uso em páginas sem `CustomScrollView` (404).
- **Menus de História/Geografia (desktop):** mantém-se o `OverlayPortal` atual (hover, alinhamento à direita, rolagem interna) e acrescenta-se teclado (setas, Esc, Tab), semântica de expandido/recolhido e os estados carregando/vazio/erro. Alternativa considerada: `MenuAnchor` do Material. Descartada porque não abre por hover, e o conteúdo tem esqueleto, botão de erro e divisor, o que pede controle fino do foco.
- **Menu de celular/tablet:** continua um `showGeneralDialog` (o Navigator já prende o foco no painel e o devolve ao botão ao fechar), agora como painel sobre a página, com sanfonas, "Fechar menu", Esc e toque fora. O destaque do item ativo passa a ser calculado na `Navbar` (que tem `GoRouterState`) e entregue ao painel, resolvendo a limitação descrita em `docs/arquitetura.md`.
- **Rodapé:** `Footer` continua `const Footer()`, agora em 4/2/1 colunas dentro de `PageContent`, com links reais (`GoRouter`, `mailto:`, `tel:`, redes em outra aba) e o ano vindo de `DateTime.now().year`.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens de componente que faltam: altura da navbar (68), alturas de botão (40/44), tamanho de ícone do menu, largura do painel do dropdown |
| Criar | `lib/app/core/components/focus/app_focus_ring.dart` | Anel de foco compartilhado |
| Criar | `lib/app/core/components/buttons/app_button_base.dart` | Base dos três botões (estados, tamanhos, semântica) |
| Alterar | `.../buttons/primary_button.dart`, `secondary_button.dart`, `app_text_button.dart` | Visual novo, mesma API |
| Alterar | `.../buttons/app_icon_button.dart`, `custom_icon_button.dart` | Foco visível e `tooltip` (nome acessível) |
| Alterar | `.../buttons/social_buttons.dart` | Ícones SVG, foco, nome acessível, versão para fundo escuro |
| Criar | `assets/images/logo.svg` e `assets/icons/{instagram,facebook,youtube}.svg` | Marca e redes em SVG |
| Criar | `lib/app/core/components/logo/app_logo.dart` | Marca + nome, versão clara/escura, link para a Home |
| Alterar | `lib/app/core/components/navbar/navbar.dart` | Layout 68 px, fixa, translúcida, item ativo, `NavbarSliver` |
| Criar | `lib/app/core/components/navbar/navbar_item.dart` | Item da navbar (texto, ativo com sublinhado, foco, expandido/recolhido) |
| Alterar | `lib/app/core/components/navbar/navbar_dropdown.dart` | Visual, teclado, estados, ícone de link externo, divisor |
| Criar | `lib/app/core/components/navbar/navbar_categories_menu.dart` | Conteúdo do menu por estado (esqueleto, vazio, erro, lista), usado no dropdown e nas sanfonas |
| Alterar | `lib/app/core/components/dialog/navbar_mobile_menu.dart` | Painel com sanfonas, fechar, Esc, foco |
| Remover | `navbar/navbar_menu.dart`, `dialog/navbar_sub_menu.dart` (e `full_screen_dialog.dart` se ficar sem uso) | Código morto depois da troca (conferir com busca antes) |
| Alterar | `lib/app/core/components/footer/footer.dart` | Rodapé escuro em colunas |
| Alterar | `lib/app/core/utils/constants/app_strings.dart` | Endereço sem CEP, telefones separados, links `mailto:`/`tel:` |
| Alterar | `lib/app/core/utils/url/url.dart` | `openUrl` com opção de abrir na mesma aba (`mailto:`/`tel:`) |
| Alterar | Páginas: `home_page`, `posts_page`, `post_detailed_page`, `library_page`, `contact_us_page`, `manifest_page`, `team_member_page`, `collaborate_page` (em `lib/app/features/**/pages/`) | `SliverToBoxAdapter(child: Navbar())` → `NavbarSliver()` |
| Alterar | `lib/app/router/page_not_found.dart` | Navbar e rodapé na 404 (ver ponto P1) |
| Criar | `docs/specs/002-botoes-navbar-rodape/verificacao.md` | Feito por `/sdd-verify` |

## Decisões técnicas
- **API dos botões intacta.** Alternativa (renomear para `AppButton`) obrigaria a mexer em ~50 arquivos, inclusive do painel, sem ganho.
- **`Material`+`InkWell` e não `TextButton`.** O contorno de foco fora do botão (3 px, afastado 2 px) não cabe em `ButtonStyle`. O anel é desenhado por `AppFocusRing` com `Stack`/`Positioned` de inset negativo, sem alterar o layout.
- **Foco só do teclado.** `AppFocusRing` usa `FocusManager.instance.highlightMode` (`traditional`) para não aparecer no clique do mouse.
- **Contraste do desativado.** O texto esmaecido do botão desativado é exceção da regra de contraste (componente inativo), mas o estado é informado por `Semantics(enabled: false)`.
- **Item ativo calculado na `Navbar`.** Rota atual via `GoRouterState` e área via `selectedCategory`. Passa-se um mapa/flag para o painel de celular, que não tem `GoRouterState`.
- **Movimento reduzido.** Animações do menu e da sanfona usam `MediaQuery.disableAnimationsOf(context)` para duração zero.
- **Ícones de rede em SVG** de uma fonte livre (Simple Icons, CC0), monocromáticos para poderem trocar de cor. O `flutter_svg` já está no projeto. Os PNG antigos ficam onde ainda são usados (`Support`, fora do escopo).
- **Esqueleto.** Reaproveita `Skeleton` de `core/components/skeleton`.
- **Fonte dos textos.** Toda tipografia nova sai de `AppTheme.typography.of(context)` (001), não de `AppTitle`/`AppLabel`, que usam Dosis e `num_extension`.

## Pontos aprovados (2026-09-26)
Todos aprovados. P2 ficou sem objeto: a seção interna do Geoensine foi removida do projeto.
- **P1. Navbar e rodapé na 404.** Hoje `PageNotFound` não tem nenhum dos dois, mas a spec cita "navbar visível na 404" e "rodapé em páginas de erro". *Proposta:* incluir os dois na 404 (é o que a spec descreve). O componente `PageErrorContent` (erro de carga dentro de páginas) já convive com navbar/rodapé e não muda.
- **P2. Rodapé no Geoensine.** Sem objeto: a seção interna do Geoensine foi removida. Resta apenas o link externo no menu de Geografia.
- **P3. `LibraryNavbar`.** A página de detalhe de documento usa `LibraryNavbar` (logo + redes), não a `Navbar`. A spec cita "biblioteca" na navbar fixa. *Proposta:* trocar `LibraryNavbar` por `NavbarSliver` nessa página e apagar `LibraryNavbar`.
- **P4. Nome acessível nos botões de ícone.** `AppIconButton`/`CustomIconButton` têm ~35 usos sem rótulo. Para cumprir "todo clicável tem nome acessível", `tooltip` teria de ser **obrigatório**, o que obriga a editar todos os usos (inclui painel admin). *Proposta:* torná-lo obrigatório, em um grupo próprio de tarefas mecânicas (grupo C), para o compilador apontar o que falta.
- **P5. Item "Biblioteca" ativo em subrotas.** Hoje só `/biblioteca` exato. *Proposta:* ativo também em `/biblioteca/...` (a pessoa continua "na Biblioteca").
- **P6. "Equipe" no rodapé.** Leva à Home (`/`). *Proposta:* só `context.go('/')`, sem âncora para a seção da equipe (não existe âncora hoje).

## Dependências e geração de código
- Nenhum pacote novo (`flutter_svg`, `url_launcher`, `go_router` já existem).
- Assets novos em pastas já declaradas no `pubspec.yaml` (`assets/images/`, `assets/icons/`).
- `build_runner`: só se algum store MobX mudar. Não deve mudar (a navbar só chama `fetchCategories()` de novo no "Tentar de novo").
- Sem rotas novas. Sem registro em `*_setup.dart`.

## Riscos e cuidados
- **Botões em todo o app.** Altura mínima de 44 px e largura por conteúdo podem causar `overflow` em linhas apertadas do painel admin e dos filtros da biblioteca (`AppTextButton.small` em `section_header_actions.dart` e `filters.dart`). Tarefa de regressão dedicada.
- **Navbar fixa em `CustomScrollView`.** `SliverPersistentHeader` com altura fixa; conferir que o `Navbar` não perde estado (busca de categorias) ao rolar e que páginas com `SliverFillRemaining` (erro) continuam certas.
- **Foco preso ou perdido** no painel de celular e no dropdown. Testar Tab/Shift+Tab, Esc e retorno do foco em Chrome.
- **Hover x teclado no dropdown.** O menu aberto por hover não pode fechar sob quem navega por teclado (o foco dentro do painel mantém aberto).
- **Menu perto da borda** e listas longas: alinhar à direita e rolar por dentro; testar em 1024 e 1280.
- **Contraste** do acento sobre `accentSoft` (botão discreto no hover) e do texto ativo da navbar: valores calculados na 001 (F3) e anotados no `verificacao.md`.
- **`openUrl` para `mailto:`/`tel:`.** Abrir em nova aba deixa uma aba em branco; por isso a opção de mesma aba. Testar no Chrome e, se possível, num celular.

## Como conferir
- `fvm flutter analyze` ao fim de cada tarefa (sem novos avisos).
- `fvm flutter run -d chrome` e abrir em 390, 768 e 1280 px, comparando navbar e rodapé com o protótipo e os botões com a aba "Fundamentos".
- Teclado: Tab, Shift+Tab, Enter, Espaço, setas e Esc na navbar, nos menus, nos botões e no rodapé.
- Rolar Home, categoria, post, biblioteca, contato, manifesto, membro e 404 com a navbar fixa.
- Abrir painel admin (login e uma aba) para ver os botões novos.
- Script de contraste (na pasta temporária) para os pares listados na spec.
- Nota: `fvm flutter analyze` trava no caminho com "ó" de "Observatório"; usar a cópia em caminho ASCII, como na 001 (A3).
