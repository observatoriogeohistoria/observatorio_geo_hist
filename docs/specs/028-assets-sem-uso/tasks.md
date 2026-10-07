# Tarefas da 028. Assets, fontes e pacotes sem uso

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios da spec, na ordem: 1 arquivos apagados; 2 sem Dosis e sem `.png` em `lib/`; 3 sem os 7 pacotes; 4 `pubspec.lock` só com remoções; 5 assets que ficam referenciados e licenças; 6 `analyze` e gerados; 7 build e conteúdo de `build/web/assets/`; 8 telas sem mudança visual.

## Grupo A: estado de antes
- [ ] **A1.** Antes de qualquer remoção: sincronizar a cópia ASCII, `fvm flutter pub get`, build release, servir com fallback de SPA e capturar Home, um post, nossa história, biblioteca (índice, lista e um documento), fale com a gente, colabore, 404 e login em 390, 768 e 1280 px. Guardar no scratchpad e anotar o tamanho de `build/web/assets/`. Arquivos: nenhum. Atende: 8.

## Grupo B: fontes e imagens (commit 1)
- [ ] **B1.** `git rm` dos 7 `Dosis-*.ttf`, dos 6 `.png` de `assets/icons/`, das 5 imagens (`collaborate`, `library`, `logo-white`, `orange`, `who-we-are`) e do arquivo vazio em `packages/`. Atende: 1.
- [ ] **B2.** Junto com B1, para o build não procurar fonte apagada: `pubspec.yaml` sem o bloco `family: Dosis`, mantendo `BricolageGrotesque`, `Figtree` e as três linhas de `assets:`. Atende: 2.
- [ ] **B3.** Na cópia ASCII: `fvm flutter pub get` (o lock não deve mudar), `fvm flutter analyze` limpo e `fvm flutter build web --release` sem erro. Commit `chore: remove fontes e imagens sem uso`. Atende: 6, 7.

## Grupo C: pacotes (commit 2)
- [ ] **C1.** `pubspec.yaml`: tirar `carousel_slider`, `google_fonts`, `cached_network_image`, `flutter_staggered_grid_view`, `file_saver`, `flutter_quill_extensions` e `cupertino_icons` de `dependencies`. Atende: 3.
- [ ] **C2.** Na cópia ASCII: `fvm flutter pub get` e trazer o `pubspec.lock` de volta ao repositório; `git diff pubspec.lock` só com remoções e sem nenhum dos 7 como pacote. Atende: 4.
- [ ] **C3.** `fvm flutter analyze` limpo e `fvm dart run build_runner build --delete-conflicting-outputs` sem diferença em `*.g.dart` e `*.freezed.dart`. Atende: 6.

## Grupo D: conferência
- [ ] **D1.** Rodar as buscas dos critérios 2 e 3 (`grep -rnE`) em `lib/`, `web/`, `tool/`, `pubspec.yaml` e `.github/`, e confirmar que voltam vazias. Conferir com `git ls-files assets packages` que os 19 arquivos saíram e que cada asset restante está na lista "O que fica" com sua referência; licenças OFL da Bricolage e da Figtree presentes. Atende: 1, 2, 3, 5.
- [ ] **D2.** Formato do projeto inteiro (comando do `CLAUDE.md`) sem diferenças e `fvm flutter build web --release` sem erro; `find build/web/assets` sem `Dosis`, `email.png`/`twitter.png` etc., as 5 imagens nem `CupertinoIcons`; anotar o tamanho novo de `build/web/assets/`. Atende: 6, 7.
- [ ] **D3.** Servir o build novo e capturar as mesmas telas de A1 em 390, 768 e 1280 px; comparar com as de antes (fontes Bricolage e Figtree, logo, capa do vídeo, parceiros, redes no rodapé, ícones de compartilhamento do post, imagem de nossa história) e confirmar sem rolagem horizontal. Voltar o navegador ao preset desktop. Atende: 8.
- [ ] **D4.** Rodar em modo debug (`fvm flutter run -d web-server --web-port <porta>` na cópia ASCII), abrir Home, um post, nossa história e o login e olhar o console: sem asserção de layout, `overflow` nem "Unable to load asset". Parar os servidores. Painel não conferido na tela (sem credenciais de teste); coberto por C3 e D2. Atende: 8.
- [ ] **D5.** Marcar as tarefas e os critérios, mudar o status da spec para `implementada`, acrescentar ao item 7 de `docs/redesign/planejamento.md` a referência `→ specs/028-assets-sem-uso`. Commit `chore: remove pacotes sem uso` com o `pubspec.yaml`, o `pubspec.lock` e os docs. Atende: todos (registro).
