# Plano da 027. Remoção do código legado

- **Spec:** spec.md
- **Criado em:** 2026-10-07

## Abordagem
Remoção pura, sem trocar nenhuma chamada em tela em uso. A ordem segue a dependência: primeiro saem os componentes antigos (que são os únicos usuários dos textos Dosis, das cores antigas, de `space`/`radius` e da maior parte de `num_extension`); depois o tema e o `num_extension` ficam sem usuários e saem também. Cada grupo deixa o app compilando.

Antes de remover qualquer coisa, tiram-se capturas das telas principais no estado atual, para comparar no fim (critério 10). Como nada visível deveria mudar, a comparação lado a lado é a conferência principal; as buscas (grep) provam a remoção.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Apagar | `lib/app/core/components/image/app_rounded_image.dart` | Sem uso |
| Apagar | `lib/app/core/components/text/common_title.dart` | Sem uso |
| Apagar | `lib/app/core/components/text/app_headline.dart`, `app_title.dart`, `app_label.dart`, `app_body.dart` | Textos Dosis, usados só por arquivos que saem |
| Apagar | `lib/app/core/components/pages_circles/` (pasta) | Sem uso |
| Apagar | `lib/app/core/components/buttons/custom_icon_button.dart` | Usado só pelo carrossel antigo |
| Apagar | `lib/app/features/home/presentation/components/avatar.dart` | Sem uso |
| Apagar | `lib/app/features/home/presentation/components/dialog/` (pasta) | Carrossel antigo de destaques, sem uso |
| Apagar | `lib/app/core/utils/carousel_options/` (pasta) | Usado só pelo carrossel antigo |
| Apagar | `lib/app/core/models/general_state.dart` | Sem uso |
| Apagar | `lib/app/features/admin/login/login_setup.dart` | Nunca chamado; `admin_setup.dart` faz o mesmo registro |
| Apagar | `lib/app/core/utils/extensions/num_extension.dart` | Sem usuários depois dos passos anteriores |
| Alterar | `lib/app/core/utils/screen/screen_utils.dart` | Tirar `getPageHorizontalPadding`, `isSmallMobile`, `isTablet`, `isLaptop`, `isSmallDesktop` e o import de `num_extension` |
| Alterar | `lib/app/core/utils/date/date.dart` | Tirar `monthName` |
| Alterar | `lib/app/theme/app_theme.dart` | Tirar imports de `google_fonts` e `num_extension` |
| Alterar | `lib/app/theme/app_typography/app_typography.dart` | Ficar só com `of(context)`; sair `headline/title/body/label` Dosis, `TypographyStyle`, `TypographySize` e o comentário sobre Dosis |
| Alterar | `lib/app/theme/app_colors/app_colors.dart` | Tirar as 10 cores antigas; `white` fica |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tirar `space`, `radius` e `DimensionStyle`; `stroke` vira escala própria com `small`, `medium`, `large`, `huge` |
| Alterar | `docs/arquitetura-painel-admin.md` | Tirar `login_setup.dart` da árvore de pastas |

## Decisões técnicas
- **`stroke` como escala própria** (`StrokeScale`, no mesmo estilo de `SpacingScale` e `RadiiScale`), com os nomes atuais e os mesmos valores (1, 2, 3, 4). Alternativa: renomear para `s1`…`s4` como `spacing`; descartada porque mexeria em 31 chamadas sem ganho visual e com risco de erro. Os valores 0,5, 5, 6 e 7 não têm uso e saem.
- **`white` fica** em `AppColors` com o mesmo nome: é usado em 30 pontos de telas novas e não existe outro token branco para texto sobre acento ou imagem (`page` é fundo).
- **`AppTypography`** continua como ponto de entrada (`AppTheme.typography.of(context)`); só perde os getters Dosis.
- **`login_setup.dart`**: `AppSetup` chama só `AdminSetup.setup()`, que já registra `FirebaseAuthDatasource`, `AuthRepository` e `AuthStore`. Apagar o arquivo não muda a injeção.
- **Sem tocar** em `pubspec.yaml`: `google_fonts` e `carousel_slider` ficam declarados, sem import, até a 028. O `analyze` não reclama de pacote declarado e não importado.
- **Comentários:** nenhum novo. O único comentário que sai é o de `AppTypography` sobre Dosis.

## Dependências e geração de código
Nenhum pacote novo, nenhuma rota, nenhum `build_runner` (nenhum arquivo removido tem `part '*.g.dart'`). Nenhum `*_setup.dart` em uso muda.

## Riscos e cuidados
- **Tema compartilhado:** `app_dimensions.dart` e `app_colors.dart` são usados por todas as telas. Só saem membros sem uso; o compilador acusa qualquer uso esquecido. A mudança de `stroke` mantém nome e valor.
- **Fonte:** os estilos novos já usam Figtree e Bricolage declaradas no `pubspec`; nenhum depende de `GoogleFonts`. Conferir na tela que a fonte não muda (critério 10).
- **Painel:** não há credenciais de teste; os cards e diálogos do painel ficam garantidos pelo `analyze` e pelo build, não pela tela. O login é conferido na tela.
- **Caminho com acento:** `fvm flutter analyze` falha na pasta original; rodar numa cópia em caminho ASCII.

## Como conferir
- Buscas dos critérios 2 a 6 em `lib/` (comandos em D1).
- `git diff --stat` sem `pubspec.yaml`, `assets/`, `web/`, `*.g.dart` e `*.freezed.dart` (critério 11).
- `fvm flutter analyze` e `fvm dart format` na cópia ASCII.
- `fvm flutter build web --release`, servir `build/web` com fallback de SPA e comparar com as capturas de antes em 390, 768 e 1280 px; uma rodada em modo debug (`fvm flutter run -d web-server`) olhando o console por asserções de layout.

## Commits
Dois commits `refactor:`, cada um compilando (`analyze` limpo e `dart format` nos `.dart` alterados):
1. `refactor: remove componentes e código sem uso` (grupo B): os 11 arquivos de componentes, carrossel, `general_state`, `login_setup`, `monthName` e a linha da árvore em `arquitetura-painel-admin.md`.
2. `refactor: remove num_extension e tokens antigos do tema` (grupo C): `screen_utils`, `num_extension.dart`, tipografia Dosis, cores antigas e `space`/`radius`, com `stroke` em escala própria.

A marcação de `tasks.md` vai junto de cada commit. As capturas de antes e depois ficam no scratchpad, fora do repositório.
