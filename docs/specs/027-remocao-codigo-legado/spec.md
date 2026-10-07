# 027. Remoção do código legado

- **Status:** implementada
- **Item do planejamento:** Fase 7 (Limpeza), parte 1: código. Lista de arquivos sem uso na Fase 6.
- **Protótipo:** não se aplica (limpeza sem mudança visual).
- **Criada em:** 2026-10-07

## Objetivo
Tirar do projeto o código que ficou sem uso depois do redesign: componentes antigos, a escala proporcional à tela (`num_extension`) e os tokens antigos do tema. O site e o login continuam exatamente iguais; o ganho é um código menor, sem duas formas de fazer a mesma coisa.

## Situação atual
Levantamento por busca em `lib/` (2026-10-07). Nenhuma tela em uso depende do que sai; os poucos usos encontrados estão dentro dos próprios arquivos que saem.

**Arquivos inteiros sem uso (14):**

| Arquivo | Quem usa hoje |
|---|---|
| `core/components/image/app_rounded_image.dart` | ninguém |
| `core/components/text/common_title.dart` | ninguém |
| `core/components/text/app_headline.dart` | só `common_title` e `highlights_dialog_carousel` |
| `core/components/text/app_title.dart` | ninguém |
| `core/components/text/app_label.dart` | ninguém |
| `core/components/text/app_body.dart` | só `common_title` e `highlights_dialog_carousel` |
| `core/components/pages_circles/pages_circles.dart` | ninguém |
| `core/components/buttons/custom_icon_button.dart` | só `highlights_dialog_carousel` |
| `features/home/presentation/components/avatar.dart` | ninguém (a equipe usa `member_avatar.dart`) |
| `features/home/presentation/components/dialog/highlights_dialog_carousel.dart` | ninguém |
| `core/utils/carousel_options/carousel_options.dart` | só `highlights_dialog_carousel` |
| `core/utils/extensions/num_extension.dart` | `theme/app_theme.dart`, `screen_utils.dart` e os arquivos acima |
| `core/models/general_state.dart` | ninguém (achado na busca de código morto) |
| `features/admin/login/login_setup.dart` | ninguém; duplica o registro que `admin_setup.dart` já faz (achado na busca) |

**Trechos sem uso em arquivos que ficam:**
- `core/utils/screen/screen_utils.dart`: `getPageHorizontalPadding` (único uso de `num_extension` fora dos arquivos acima) e `isSmallMobile`, `isTablet`, `isLaptop`, `isSmallDesktop`, usados só por ele ou por ninguém. `isMobile`, `isDesktop`, `breakpointOf`, `contentMargin` e `contentMaxWidth` seguem em uso.
- `theme/app_colors`: as 10 cores antigas `lightOrange`, `orange`, `amber`, `lighterGray`, `lightGray`, `gray`, `darkGray`, `red`, `green` e `blue`, usadas só pelos arquivos que saem.
- `theme/app_typography`: os quatro estilos Dosis (`headline`, `title`, `body`, `label` com tamanhos `small/medium/big`), seu tipo de apoio e o enum de tamanho, usados só pelos componentes de texto que saem. É o único uso do pacote `google_fonts`.
- `theme/app_dimensions`: as escalas antigas `space` e `radius` (com `mini`…`gigantic`), usadas só por `getPageHorizontalPadding` e pelos arquivos que saem.
- `core/utils/date/date.dart`: o getter `monthName`, sem uso (achado na busca). `shortDate` e `formatMonthYear` seguem em uso.

**O que parecia legado mas segue em uso (fica):**
- Cor `white`: 30 usos em telas novas (texto sobre acento e sobre imagem). Fica como token.
- Escala `stroke` (espessura de bordas): 31 usos em telas novas, só com os valores 1, 2, 3 e 4 (`small`, `medium`, `large`, `huge`). Fica, só com esses quatro valores e sem depender do tipo antigo compartilhado com `space` e `radius`. As chamadas não mudam.
- `typography.label` nos cards do painel é o estilo novo (`AppTheme.typography.of(context).label`), não o Dosis.
- `MediaQuery.textScalerOf(context).scale(...)` é do Flutter, não de `num_extension`.

## Comportamento
Nenhuma mudança visível. Todas as telas do site e o login ficam iguais em layout, fonte, cor e espaçamento. Nenhum texto de interface muda.

## Estados
Sem mudança: carregando, vazio, erro e falha de imagem continuam como estão em cada tela.

## Responsivo
Sem mudança em 390, 768 e 1280 px.

## Acessibilidade
Sem mudança. Nenhum componente com foco ou nome acessível em uso é removido.

## Dados e regras de negócio
Não mudam modelos de dados, coleções e regras do Firebase, rotas nem a injeção de dependências em uso (`admin_setup.dart` segue registrando o login).

## Critérios de aceite
- [x] 1. Os 14 arquivos da tabela não existem mais, e as pastas `pages_circles/`, `carousel_options/` e `home/presentation/components/dialog/` ficaram vazias e saíram.
- [x] 2. Busca vazia em `lib/` por `num_extension|NumExtension|horizontalSpacing|verticalSpacing` e por `[0-9)]\.fontSize\(` e `\.scale\b[^(]` (o `scale(...)` do `TextScaler` do Flutter não conta).
- [x] 3. Busca vazia em `lib/` por `[Dd]osis|GoogleFonts|google_fonts`.
- [x] 4. Busca vazia em `lib/` por `colors\.(lightOrange|orange|amber|lighterGray|lightGray|gray|darkGray|red|green|blue)\b` e nenhuma dessas 10 cores declarada em `app_colors.dart`.
- [x] 5. Busca vazia em `lib/` por `dimensions\.(space|radius)\b|DimensionStyle|TypographyStyle|TypographySize` e por `AppTheme\.typography\.(headline|title|body|label)\b|typography\.(headline|title|body)\b` (o `label` dos cards do painel vem de `typography.of(context)` e é o estilo novo).
- [x] 6. Busca vazia em `lib/` pelos símbolos removidos: `getPageHorizontalPadding|isSmallMobile|isTablet|isLaptop|isSmallDesktop|GeneralState|LoginSetup|carouselOptions|monthName|CommonTitle|AppHeadline|AppTitle\b|AppLabel\b|AppBody\b|PagesCircles|CustomIconButton|AppRoundedImage|HighlightsCarousel|\bAvatar\b`.
- [x] 7. As bordas continuam com as mesmas espessuras (1, 2, 3 e 4) sem mudar nenhuma chamada fora do tema; `white` continua disponível.
- [x] 8. `fvm flutter analyze` sem erros nem avisos novos e `dart format` sem diferenças nos arquivos alterados.
- [x] 9. `fvm flutter build web --release` termina sem erro.
- [x] 10. Home, todas as publicações, listagem de categoria, um post, biblioteca (índice, lista e documento), nossa história, equipe, fale com a gente, colabore, 404 e login sem mudança visual em 390, 768 e 1280 px, comparando com capturas tiradas antes da remoção, e sem `overflow` nem asserção de layout no modo debug.
- [x] 11. `pubspec.yaml`, `assets/`, `web/` e os arquivos gerados (`*.g.dart`, `*.freezed.dart`) sem alteração.

## Fora do escopo
- Assets sem uso (imagens, ícones PNG antigos), os arquivos de fonte Dosis em `assets/fonts/` e a **declaração da família Dosis no `pubspec.yaml`**: vão para a spec 028-assets-sem-uso.
- Pacotes que ficam sem uso depois desta spec (`google_fonts` e `carousel_slider`, conferidos por busca): saem na 028, que também confere os demais.
- Atualizar a regra de `num_extension` no `CLAUDE.md` (linha "Não use `num_extension`…"): fica para a pessoa, porque o `CLAUDE.md` não é alterado em modo autônomo.
- `ServerFailure` (`core/errors/failures.dart`), sem uso hoje: faz parte do contrato de erros da arquitetura e pode voltar a ser usado; fica.
- Token `spacing.s96`, sem uso: faz parte da escala nova; fica.
- Painel administrativo: nada dele é removido. Os cards e diálogos só deixam de ter o código antigo disponível, e o `analyze` garante que compilam.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-07: criada e aprovada em modo autônomo (a pessoa pré-aprovou o fluxo). Decisões tomadas sem a pessoa:
  - `white` e a escala `stroke` ficam, porque têm uso real em telas novas; `stroke` perde os valores sem uso (0,5, 5, 6 e 7) e deixa de depender do tipo antigo.
  - Entram como código morto achado na busca: `general_state.dart`, `login_setup.dart` (duplicado, nunca chamado), `carousel_options.dart`, `monthName` e os quatro testes de largura sem uso em `ScreenUtils`.
  - `ServerFailure` e `spacing.s96` ficam (contrato de erros e escala nova).
  - Dosis no `pubspec.yaml`, arquivos de fonte e pacotes sem uso ficam para a 028.
- 2026-10-07 (implementação): sem divergência. Ficou de fora, por não estar na spec, os campos `highlightsDialog*` e as ações `showHighlights`/`hideHighlights` de `fetch_highlights_store.dart`, sem uso desde a remoção do carrossel (exige `build_runner`).
