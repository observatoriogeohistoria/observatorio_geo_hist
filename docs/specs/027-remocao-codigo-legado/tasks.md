# Tarefas da 027. Remoção do código legado

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios da spec, na ordem: 1 arquivos apagados; 2 sem `num_extension`; 3 sem Dosis; 4 sem cores antigas; 5 sem `space`/`radius` e tipografia antiga; 6 sem símbolos removidos; 7 bordas e `white` iguais; 8 `analyze` e formato; 9 build; 10 telas sem mudança visual; 11 `pubspec`, assets, `web/` e gerados intocados.

## Grupo A: estado de antes
- [x] **A1.** Antes de qualquer remoção: build release na cópia ASCII, servir com fallback de SPA e capturar Home, todas as publicações, uma listagem de categoria, um post, biblioteca (índice, lista e um documento), nossa história, uma página de membro da equipe, fale com a gente, colabore, 404 e login em 390, 768 e 1280 px. Guardar no scratchpad. Arquivos: nenhum. Atende: 10. *Nota: capturas por script no Chrome headless (protocolo de depuração), 13 telas × 3 larguras, altura 1600 px.*

## Grupo B: componentes e código sem uso (commit 1)
- [x] **B1.** Apagar `app_rounded_image.dart`, `common_title.dart`, `app_headline.dart`, `app_title.dart`, `app_label.dart`, `app_body.dart`, a pasta `pages_circles/`, `custom_icon_button.dart`, `home/.../components/avatar.dart`, a pasta `home/.../components/dialog/` e a pasta `core/utils/carousel_options/`. Atende: 1, 6.
- [x] **B2.** Apagar `core/models/general_state.dart` e `features/admin/login/login_setup.dart`; tirar `monthName` de `core/utils/date/date.dart`; tirar `login_setup.dart` da árvore em `docs/arquitetura-painel-admin.md`. Atende: 1, 6.
- [x] **B3.** `fvm flutter analyze` (cópia ASCII) limpo e `dart format` em `date.dart`. Commit `refactor: remove componentes e código sem uso`. Atende: 8.

## Grupo C: `num_extension` e tokens antigos (commit 2)
- [x] **C1.** `screen_utils.dart`: tirar `getPageHorizontalPadding`, `isSmallMobile`, `isTablet`, `isLaptop`, `isSmallDesktop` e o import de `num_extension`. Atende: 2, 6.
- [x] **C2.** `app_typography.dart`: tirar os getters Dosis `headline`, `title`, `body`, `label`, a classe `TypographyStyle`, o enum `TypographySize` e o comentário sobre Dosis, mantendo `of(context)`. `app_theme.dart`: tirar os imports de `google_fonts` e `num_extension`. Atende: 3, 5.
- [x] **C3.** Apagar `core/utils/extensions/num_extension.dart` (e a pasta `extensions/` se ficar vazia). Atende: 1, 2.
- [x] **C4.** `app_colors.dart`: tirar `lightOrange`, `orange`, `amber`, `lighterGray`, `lightGray`, `gray`, `darkGray`, `red`, `green` e `blue`; manter `white`. Atende: 4, 7.
- [x] **C5.** `app_dimensions.dart`: tirar `space`, `radius` e `DimensionStyle`; criar `StrokeScale` com `small` 1, `medium` 2, `large` 3 e `huge` 4 e apontar `stroke` para ela. Nenhuma chamada fora do tema muda. Atende: 5, 7.
- [x] **C6.** `fvm flutter analyze` limpo e `dart format` nos `.dart` alterados. Commit `refactor: remove num_extension e tokens antigos do tema`. Atende: 8.

## Grupo D: conferência
- [x] **D1.** Rodar em `lib/` as buscas dos critérios 2 a 6, com `grep -rnE --include='*.dart'`, e confirmar que todas voltam vazias; conferir que `colors.white` e `dimensions.stroke.(small|medium|large|huge)` seguem compilando. `git diff --stat develop...HEAD` sem `pubspec.yaml`, `assets/`, `web/`, `*.g.dart` e `*.freezed.dart`. Atende: 1 a 7, 11. *Nota: todas vazias; o único acerto de `monthName` é `_monthNamesLower`, outro símbolo, que fica.*
- [x] **D2.** Formato do projeto inteiro (`find lib -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart'` com `dart format --set-exit-if-changed`) e `fvm flutter analyze` sem erros nem avisos novos. Atende: 8.
- [x] **D3.** `fvm flutter build web --release` sem erro. Atende: 9.
- [x] **D4.** Servir o build novo e capturar as mesmas telas de A1 em 390, 768 e 1280 px; comparar lado a lado (fonte, cores, bordas, espaçamentos) e confirmar sem `overflow` nem rolagem horizontal. Voltar o navegador ao preset desktop no fim. Atende: 10. *Nota: as 39 capturas saíram idênticas byte a byte às de A1; 375 px no navegador embutido sem rolagem horizontal.*
- [x] **D5.** Rodar em modo debug (`fvm flutter run -d web-server --web-port <porta>` na cópia ASCII), abrir Home, um post, a biblioteca e o login e olhar o console: sem asserções de layout nem erros. Parar os servidores. Painel não conferido na tela (sem credenciais de teste); fica coberto por D2 e D3. Atende: 10. *Nota: Home, post, biblioteca (índice e lista) e login em 390 e 1280 px; console sem `overflow`, exceção nem asserção.*
