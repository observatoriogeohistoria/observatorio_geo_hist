# Plano da 028. Assets, fontes e pacotes sem uso

- **Spec:** spec.md
- **Criado em:** 2026-10-07

## Abordagem
Só remoção: nenhum `.dart` de `lib/` muda. Primeiro capturar as telas de antes; depois, em dois commits que compilam sozinhos, apagar os assets (com a família Dosis do `pubspec.yaml`) e em seguida os pacotes (com o `pubspec.lock` regerado por `fvm flutter pub get`). A conferência compara o build novo com as capturas de antes, olha o conteúdo de `build/web/assets/` e roda o modo debug.

Assets e pacotes ficam em commits separados porque falham de jeitos diferentes: asset faltando só aparece em execução (erro no console ou imagem quebrada), pacote faltando aparece no `analyze`. Separados, um `git revert` desfaz cada lado sem tocar no outro.

`analyze`, `pub get`, `build_runner` e builds rodam na cópia em caminho ASCII no scratchpad (o "ó" do caminho original quebra o `analyze`), sincronizada com `rsync` sem `build/` e `.dart_tool/`. As remoções são feitas no repositório original com `git rm`.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Apagar | `assets/fonts/Dosis-*.ttf` (7) | Família sem uso desde a 027 |
| Apagar | `assets/icons/{email,facebook,instagram,twitter,whatsapp,youtube}.png` | Substituídos pelos `.svg` |
| Apagar | `assets/images/{collaborate,library,logo-white,orange,who-we-are}.webp` | Sem referência |
| Apagar | `packages/observatorio_geo_hist/app/features/home/infra/datasources/fetch_navbuttons_categories_datasource.dart` | Arquivo vazio fora de `lib/` |
| Alterar | `pubspec.yaml` | Tirar a família Dosis (commit 1) e os 7 pacotes (commit 2) |
| Alterar | `pubspec.lock` | Regerado pelo `pub get`, só com remoções (commit 2) |
| Alterar | `docs/specs/028-assets-sem-uso/*`, `docs/redesign/planejamento.md` | Progresso, status e referência no item da Fase 7 |

## Decisões técnicas
- **Commit 1 `chore: remove fontes e imagens sem uso`:** 19 arquivos e a família Dosis no `pubspec.yaml`. O `pubspec.lock` não muda (fontes e assets não entram nele).
- **Commit 2 `chore: remove pacotes sem uso`:** os 7 pacotes no `pubspec.yaml` e o `pubspec.lock`, com as atualizações de `tasks.md`, status da spec e planejamento.
- **`pub get`, não `pub upgrade`:** o `get` mantém as versões travadas dos pacotes que ficam e só tira os que saem e suas dependências exclusivas. Se aparecer mudança de versão, o diff do lock é descartado e o motivo investigado antes do commit.
- **`flutter_quill_extensions` sai:** o editor e a leitura de posts usam só o `flutter_quill` e nenhum construtor de embeds é registrado; a conferência abre um post para garantir.
- **`cupertino_icons` sai:** nenhum `CupertinoIcons` no código; o build deixa de levar a fonte. Os ícones em uso são do Material.
- **`freezed`, `mobx_codegen`, `build_runner`, `flutter_lints` e `flutter_test` ficam** (geração, análise e testes). Mover `freezed` para `dev_dependencies` fica fora (ver spec).

## Dependências e geração de código
Nenhum pacote novo. `build_runner` roda só para confirmar que os gerados não mudam. Rotas e `*_setup.dart` intocados.

## Riscos e cuidados
- **Asset referenciado por string montada:** os caminhos dinâmicos (`${AppAssets.icons}/${name}.svg`, `share_${asset}.svg`, `partners/$name.webp`, `lupa.webp`/`logo.webp`) só apontam para arquivos que ficam. A conferência abre as telas que os usam e olha o console por "Unable to load asset".
- **Pacote usado indiretamente:** se um pacote que sai for dependência de outro, ele continua no lock como transitivo; o critério 4 aceita isso desde que não seja mais direto. O `analyze` acusa qualquer `import` esquecido.
- **Painel:** usa `logo.webp`, `lupa.webp` e nenhum dos pacotes removidos; não dá para abrir na tela sem credenciais de teste, então fica coberto pelo `analyze` e pelo build.
- **Cache do navegador:** comparar sempre num carregamento limpo, para não ver uma fonte em cache.

## Como conferir
- `fvm flutter pub get`, `fvm flutter analyze`, `fvm dart run build_runner build --delete-conflicting-outputs` e `fvm flutter build web --release` na cópia ASCII.
- `git diff pubspec.lock` só com linhas removidas.
- `find build/web/assets` sem `Dosis`, `.png` de ícones, as 5 imagens nem `CupertinoIcons`.
- Servidor Python com fallback de SPA para `index.html` e o navegador embutido em 390, 768 e 1280 px; uma rodada em modo debug (`fvm flutter run -d web-server`).
