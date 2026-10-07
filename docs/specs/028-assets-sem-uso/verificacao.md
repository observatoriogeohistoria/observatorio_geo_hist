# Verificação da 028. Assets, fontes e pacotes sem uso

- **Data:** 2026-10-07
- **Resultado:** aprovada

Revisão feita sobre o código (`git diff dcab857..HEAD`, commits `da8572d` e `68b43fc`), com buscas próprias.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas |
| `dart format --set-exit-if-changed` no projeto inteiro | 323 arquivos, nenhum alterado |
| `fvm flutter pub get` | `pubspec.lock` sem mudança |
| `git diff origin/develop -- pubspec.lock` | nenhuma linha adicionada, 288 removidas: nenhuma versão mudou |
| `fvm dart run build_runner build --delete-conflicting-outputs` | sem diferença de conteúdo nos gerados (no máximo quebra de linha em `library_document_store.g.dart`, já registrada na spec) |
| `fvm flutter build web --release` | concluído depois de `flutter clean` (ver Problemas) |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | 19 arquivos e `packages/` fora | passou | `git diff --stat` com os 19 apagados; `git ls-files packages` vazio |
| 2 | Sem Dosis nem `.png` em `lib/`; só Bricolage e Figtree no pubspec | passou | buscas vazias em `lib/`, `web/`, `tool/`, `pubspec.yaml` e `.github/` por `Dosis` e pelo nome de cada arquivo removido; o único `.png` em `web/` é o `og-image.png`, que fica |
| 3 | Sem os 7 pacotes | passou | busca pelos nomes e classes vazia em `lib/`, `tool/`, `web/` e `pubspec.yaml` |
| 4 | Lock só com remoções | passou | ver Comandos |
| 5 | Assets que ficam referenciados; licenças | passou | nomes montados em string conferidos: redes (`instagram`, `facebook`, `youtube` `.svg`), `share_*` (6 `.svg`), parceiros (`.webp` do enum), `logo.svg`, `our-history.webp`, `video-capa.webp`, `lupa.webp`/`logo.webp`; `OFL-BricolageGrotesque.txt` e `OFL-Figtree.txt` presentes |
| 6 | `analyze` e gerados | passou | ver Comandos |
| 7 | Build sem os assets removidos | passou | `build/web/assets/` com 2,6 MB, sem Dosis, PNG, as 5 imagens nem `CupertinoIcons`; todas as fontes do `FontManifest.json` existem |
| 8 | Telas sem mudança e sem erro de asset | passou | release: Home (375, 768, 1280), post com texto rico (375, 1280) e nossa história; todas as requisições a `assets/` com 200 e console sem "Unable to load asset". Debug (`flutter run -d web-server`): Home e post sem `overflow`, asserção ou erro no terminal e no console. Único erro de console é a imagem externa quebrada de propósito na semente. Demais telas e capturas antes/depois conferidas na implementação |

Post com Quill: o editor de leitura usa só `flutter_quill` e o próprio `_ImageEmbedBuilder`; o artigo da semente abriu com títulos, negrito, itálico, link, listas, citação e imagem embutida, em release e em debug.

## Problemas encontrados
- Em uma cópia já usada antes da remoção, o build falha porque o registro de plugins em `.dart_tool` ainda importa `file_saver`. `fvm flutter clean` resolve. Não afeta o CI (começa sem `.dart_tool`). Gravidade: detalhe; quem for rodar localmente depois do merge precisa de um `flutter clean`.

## Não conferido
- Painel administrativo na tela (sem credenciais de teste); coberto por `analyze` e build.
