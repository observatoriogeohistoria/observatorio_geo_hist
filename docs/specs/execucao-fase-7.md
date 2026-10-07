# Execução da Fase 7

- **Início:** 2026-10-07
- **Branch:** refactor/redesign-fase-7 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 027-remocao-codigo-legado | 7 (arquivos sem uso, `num_extension`, tokens antigos) | feita | feita | feita | verificada |
| 028-assets-sem-uso | 7 (assets, fontes e pacotes sem uso) | feita | feita | feita | verificada |

## Decisões tomadas sem a pessoa
- (geral) Fase 7 dividida em duas specs: código legado primeiro, porque só depois dele sair dá para saber quais assets, fontes e pacotes ficaram sem uso.

- 027: `white` e `stroke` ficam (30 e 31 usos em telas novas); `stroke` vira escala própria com 1 a 4. `ServerFailure` e `spacing.s96` ficam, sem uso, por fazerem parte do contrato e da escala. Família Dosis no pubspec, `google_fonts` e `carousel_slider` passam para a 028.
- 027 (verificação): campos e ações sem uso do diálogo de destaques em `fetch_highlights_store.dart` removidos nesta spec, com o `.g.dart` regerado; critério 11 ajustado.
- 028: além de `google_fonts` e `carousel_slider`, saem outros 5 pacotes sem import (`cached_network_image`, `flutter_staggered_grid_view`, `file_saver`, `flutter_quill_extensions`, `cupertino_icons`) e um arquivo vazio versionado por engano em `packages/`. Pacotes de geração, análise e teste ficam.
- 028 (verificação): nenhuma correção. Depois do merge, builds locais antigos precisam de `flutter clean` (registro de plugins com `file_saver`).

## Ressalvas

## Ocorrências
