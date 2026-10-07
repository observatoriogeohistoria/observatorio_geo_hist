# Verificação da 027. Remoção do código legado

- **Data:** 2026-10-07
- **Resultado:** aprovada

Revisão feita sobre o código (`git diff origin/develop..HEAD`, commits `eb92e57`, `d5e1ac0` e `c4ab2a2`), com buscas próprias, e não só sobre as notas da implementação.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas, antes e depois da correção |
| `dart format --set-exit-if-changed` no projeto inteiro | 323 arquivos, nenhum alterado |
| `fvm flutter build web --release` | concluído |
| `fvm dart run build_runner build` | regerou `fetch_highlights_store.g.dart`; só ele foi trazido para o repositório |
| Buscas dos critérios 2 a 6 em `lib/` | todas vazias (o único acerto de `monthName` é `_monthNamesLower`, outro símbolo) |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | 14 arquivos e 3 pastas fora | passou | `git diff --stat` mostra os 14 apagados; `pages_circles/`, `carousel_options/`, `extensions/` e `home/.../components/dialog/` não existem |
| 2 | Sem `num_extension` | passou | buscas vazias |
| 3 | Sem Dosis/`google_fonts` | passou | busca vazia; `carousel_slider` também sem uso em `lib/` (sai na 028) |
| 4 | Sem as 10 cores antigas | passou | busca vazia, inclusive por `AppColors.instance.<cor>`; `app_colors.dart` só com `white` e os tokens novos |
| 5 | Sem `space`/`radius` e tipografia antiga | passou | buscas vazias, inclusive por `.space.`, `.radius.`, `massive`, `immense`, `gigantic` |
| 6 | Sem os símbolos removidos | passou | busca vazia; nenhuma referência por string (`'nome'`), `dart:mirrors`, `Symbol` ou `noSuchMethod` em `lib/` |
| 7 | Bordas 1, 2, 3 e 4 e `white` disponível | passou | `StrokeScale` com `small` 1, `medium` 2, `large` 3 e `huge` 4, os mesmos valores do `DimensionStyle` antigo; usos em `lib/`: 24 `small`, 4 `medium`, 1 `large`, 1 `huge`, nenhum valor removido |
| 8 | `analyze` e formato | passou | ver Comandos |
| 9 | Build release | passou | ver Comandos |
| 10 | Telas sem mudança visual e sem asserção | passou | as 39 capturas (13 telas × 390, 768 e 1280 px, primeiros 1600 px de cada tela) do build final saíram idênticas byte a byte às tiradas antes da remoção; Home rolada até Destaques no navegador embutido em 375, 768 e 1280 px, sem rolagem horizontal; modo debug em Home, post e login, em 375 e 1280 px, sem `overflow` nem asserção (único erro no console é a imagem quebrada de propósito no seed) |
| 11 | `pubspec`, `assets/`, `web/` e gerados intocados | passou | nenhum desses no diff, exceto `fetch_highlights_store.g.dart`, regerado pela correção abaixo (critério ajustado na spec) |

## Problemas encontrados
- Código morto em `fetch_highlights_store.dart`: `highlightsDialogWasShown`, `highlightsDialogIsOpen`, `showHighlights` e `hideHighlights`, usados só pelo carrossel removido (a 005 já previa limpá-los na Fase 7). Ajuste. **Corrigido** em commit próprio, com o `.g.dart` regerado; spec atualizada no histórico e no critério 11.

## Não conferido
- Painel administrativo na tela (sem credenciais de teste). Nada dele foi removido; `analyze` e build cobrem a compilação.
- Trecho das telas abaixo dos primeiros 1600 px na comparação por captura; a remoção só tirou código sem uso, e a Home foi rolada à mão.
