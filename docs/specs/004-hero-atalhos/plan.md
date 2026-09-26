# Plano da 004. Home: hero e atalhos

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-09-26

## Abordagem
O hero é um componente novo da feature `home`, sem dados: texto fixo, dois botões e três atalhos. Ele entra como primeiro sliver da `HomePage`, **sem** carregamento adiado (`deferred`), para aparecer junto com a navbar. Os demais slivers da Home ficam exatamente como estão; só ganham um comentário por bloco indicando a spec que vai redesenhá-lo (005 a 009), para as próximas specs saberem onde mexer.

Tudo segue o padrão das telas novas: `PageContent` para largura máxima e margens, `AppTheme.typography.of(context)` para texto, `ScreenUtils.breakpointOf` para decidir o layout por faixa, tokens de `AppDimensions`/`AppColors` para o resto. Os valores que faltam (tamanho do título do hero, texto de apoio, espaçamentos do hero, tamanho do ícone dos atalhos, opacidades do desenho de fundo) entram no tema antes do componente.

Para os atalhos História e Geografia, a janela de categorias reaproveita o `NavbarCategoriesMenu` da 002, que já trata carregando, vazio, erro com "Tentar de novo", Expogeo/Geoensine e a navegação para a categoria (inclusive `setSelectedCategory`). A janela é aberta com `showDialog`, que já prende o foco, fecha por Esc e clique fora e devolve o foco ao elemento que a abriu. Nenhuma consulta nova: o `FetchCategoriesStore` é o mesmo singleton que a navbar carrega.

A seta do botão "Explorar a biblioteca" exige ícone opcional à direita no `AppButtonBase` (hoje só texto). É uma mudança aditiva num componente compartilhado: sem o parâmetro, nada muda nas ~30 telas que usam os botões.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | Estilos `display` (título do hero: 35/54/64, peso 800, altura 1,05, −0,035 em) e `lead` (texto de apoio: 17/20/20, altura 1,55) |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens do hero em `ComponentSizes`: respiro superior/inferior por faixa (48/80/104 e 40/48/64), vão até os atalhos (36/48/60), largura máxima do título (≈ 15 caracteres → 640 px no desktop) e do texto de apoio (60 caracteres → 620 px), tamanho do quadro do ícone (46) e do ícone (22), subida no hover (2), largura máxima da janela de categorias (420), opacidades dos anéis do fundo (0,11 laranja; 0,06 escuro), raio e passo dos anéis (27 e 35) |
| Alterar | `lib/app/core/components/buttons/app_button_base.dart` | Parâmetro opcional `trailingIcon` (ícone depois do texto, mesma cor, 8 px de vão), decorativo para leitor de tela |
| Alterar | `lib/app/core/components/buttons/primary_button.dart`, `secondary_button.dart` | Repassar `trailingIcon` opcional |
| Criar | `lib/app/features/home/presentation/components/hero/home_hero.dart` | O bloco: fundo, rótulo, título com trecho em acento (`Text.rich`), texto de apoio, botões (`Wrap`) e grade de atalhos por faixa |
| Criar | `lib/app/features/home/presentation/components/hero/hero_background_painter.dart` | `CustomPainter` dos círculos concêntricos com esmaecimento para a base; envolto em `ExcludeSemantics` e `RepaintBoundary` |
| Criar | `lib/app/features/home/presentation/components/hero/hero_shortcut_card.dart` | Cartão de atalho: horizontal (celular e desktop) ou vertical (tablet), hover (borda acento, subida 2 px, sombra `soft`), `AppFocusRing`, `Semantics` (botão ou link) |
| Criar | `lib/app/features/home/presentation/components/hero/area_categories_dialog.dart` | Janela "Categorias de {área}": cabeçalho com `AppIconButton` "Fechar", `NavbarCategoriesMenu` rolável, `Semantics(scopesRoute, namesRoute)` com o título |
| Alterar | `lib/app/features/home/presentation/pages/home_page.dart` | Inserir `HomeHero` como primeiro sliver após a navbar; comentários de bloco com a spec de cada seção |
| Alterar | `docs/arquitetura.md` | Registrar o hero e a janela de categorias na seção da Home/componentes |

## Decisões técnicas
- **Janela via `showDialog` (e não painel ancorado ao cartão).** O `NavbarDropdown` abre por hover e calcula a altura a partir da navbar; num cartão no meio da página ele sairia da tela no celular. `showDialog` resolve foco, Esc, clique fora, rolagem e retorno de foco sem código novo. Mesma janela em todas as faixas (centralizada, largura máxima 420, margem de 16 px no celular). `barrierColor` com `ink` e `scrimOpacity`, como o menu de celular.
- **`NavbarCategoriesMenu` reaproveitado como está.** Ele chama `onSelected` antes de navegar; passamos `Navigator.pop` como `onSelected`. `GoRouter.of(context)` funciona dentro do diálogo (o menu de celular já faz isso). `selectedCategoryKey` fica nulo (na Home nenhuma categoria está ativa).
- **Atalho como `InkWell` em `Material`**, com `Semantics(button: true)` para História/Geografia e `Semantics(link: true)` para Biblioteca, `excludeSemantics` e rótulo composto (título + descrição + "Abre a lista de categorias" nos botões). Subida via `AnimatedSlide`/`Transform` com duração zero quando `MediaQuery.disableAnimationsOf` for verdadeiro.
- **Grade dos atalhos:** celular `Column`; tablet e desktop `Row` com três `Expanded` e `IntrinsicHeight` para alturas iguais. No tablet o cartão é vertical (ícone em cima, título com seta ao lado, descrição abaixo).
- **Rótulo em `accentStrong`** (contraste 6,26:1 sobre a superfície; o `accent` dá 4,48:1). Trecho "em um só lugar." em `accent` (texto grande, 4,48:1 ≥ 3:1). Ícone dos atalhos em `accent` sobre `accentSoft` (4,38:1, gráfico ≥ 3:1).
- **Título como cabeçalho:** `Semantics(header: true)`.
- **Desenho de fundo:** anéis de 1 px com passo de 27 px centrados em (86 %, 18 %) e passo de 35 px em (8 %, 110 %), cores `accent` e `ink` com as opacidades dos tokens, e máscara `ShaderMask`/gradiente de opaco (55 %) para transparente na base. Sem animação.
- **Ícones:** Material (`Icons.hourglass_empty_rounded`, `Icons.public`, `Icons.menu_book_outlined`, `Icons.arrow_forward`), sem pacote novo.
- **Sem `num_extension`** em nenhum arquivo novo; o `app_icon_button.dart` usa `.scale` hoje, mas não é alterado.

## Dependências e geração de código
- Nenhum pacote novo, nenhum asset novo.
- Sem `build_runner` (nenhuma store ou modelo muda).
- Sem mudança em `app_router.dart` nem em `*_setup.dart` (`FetchCategoriesStore` já está registrado e é o mesmo da navbar).

## Riscos e cuidados
- **Botões compartilhados:** o `trailingIcon` é opcional; conferir por amostragem que botões existentes (Home "MANIFESTO", Contato, Biblioteca, 404) continuam iguais.
- **Estado do menu da navbar:** escolher categoria pela janela chama `setSelectedCategory`, igual ao menu; conferir que o item "História"/"Geografia" da navbar fica ativo na página da categoria.
- **Altura dos cartões no tablet:** texto ampliado pode quebrar mais linhas; `IntrinsicHeight` mantém as três alturas iguais sem `overflow`.
- **Fundo desenhado:** `CustomPainter` com muitos anéis em telas largas; limitar o número de anéis ao necessário para cobrir o retângulo e usar `RepaintBoundary`.
- **Transição Home nova ↔ blocos antigos:** o hero (novo) fica acima do carrossel antigo; conferir que não há vão ou fundo desencontrado entre eles.

## Como conferir
- `fvm flutter analyze` numa cópia em caminho ASCII (o caminho com "ó" quebra o analisador) e `fvm flutter build web --release`.
- Servir `build/web` (servidor Python com fallback de SPA) e abrir no navegador embutido em 390, 768 e 1280 px: hero, botões, atalhos, janela de categorias (História e Geografia), navegação por Tab/Enter/Esc, hover, ausência de rolagem horizontal e de `overflow` no console.
- Estados da janela: erro e vazio conferidos por leitura de código (são os mesmos do `NavbarCategoriesMenu`, já verificados na 002) e, se possível, bloqueando o Firestore na aba de rede para ver o erro.
