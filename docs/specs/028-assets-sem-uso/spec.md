# 028. Assets, fontes e pacotes sem uso

- **Status:** implementada
- **Item do planejamento:** Fase 7 (Limpeza), parte 2: assets, fontes e pacotes. Continua a [027](../027-remocao-codigo-legado/spec.md), que deixou para cá a família Dosis, `google_fonts` e `carousel_slider`.
- **Protótipo:** não se aplica (limpeza sem mudança visual).
- **Criada em:** 2026-10-07

## Objetivo
Tirar do repositório e do build os arquivos e pacotes que nada usa depois do redesign. O site e o login continuam iguais; o ganho é um build menor (a Dosis e o `CupertinoIcons` deixam de ir para o navegador) e menos dependências para manter.

## Situação atual
Levantamento por busca em `lib/`, `web/`, `tool/`, `pubspec.yaml`, `analysis_options.yaml` e `.github/` (2026-10-07), inclusive nomes montados em string (`'${AppAssets.icons}/${name}.svg'`, `share_${asset}.svg`, `'${AppAssets.partners}/$name.webp'`, `lupa.webp`/`logo.webp`).

**Assets que saem (19 arquivos):**

| Arquivo | Por que sai |
|---|---|
| `assets/fonts/Dosis-{ExtraLight,Light,Medium,Regular,SemiBold,Bold,ExtraBold}.ttf` (7) | Nenhum estilo usa a família desde a 027; só a declaração no `pubspec.yaml` os referencia |
| `assets/icons/{email,facebook,instagram,twitter,whatsapp,youtube}.png` (6) | Redes e compartilhamento usam os `.svg`; nenhuma referência a `.png` em `lib/` |
| `assets/images/collaborate.webp`, `library.webp`, `logo-white.webp`, `orange.webp`, `who-we-are.webp` (5) | Nenhuma referência por nome nem por string montada |
| `packages/observatorio_geo_hist/app/features/home/infra/datasources/fetch_navbuttons_categories_datasource.dart` (1) | Arquivo vazio (0 bytes), versionado fora de `lib/` por engano; nada o importa |

**Pacotes que saem (7, todos em `dependencies`, sem nenhum `import` em `lib/` nem `tool/`, inclusive em arquivos gerados):** `carousel_slider`, `google_fonts`, `cached_network_image`, `flutter_staggered_grid_view`, `file_saver`, `flutter_quill_extensions`, `cupertino_icons` (nenhum `CupertinoIcons` no código).

**O que fica:**
- Fontes Bricolage Grotesque (3) e Figtree (4), com as licenças `assets/fonts/licenses/OFL-BricolageGrotesque.txt` e `OFL-Figtree.txt`. Não há licença da Dosis no repositório.
- Ícones `instagram.svg`, `facebook.svg`, `youtube.svg` (redes sociais) e os 6 `share_*.svg` (compartilhamento do post).
- Imagens `logo.svg` (logo do site; também é a origem de `tool/web_icons/gerar.sh`), `logo.webp` e `lupa.webp` (barra lateral do painel), `our-history.webp`, `video-capa.webp` e os 9 logos de `partners/`.
- Tudo em `web/` (favicons, ícones do manifest, `og-image.png`) e `tool/` (usa as fontes Bricolage e Figtree e o `logo.svg`).
- As três entradas de `assets:` no `pubspec.yaml`: `assets/images/partners/` precisa da própria linha porque a de `assets/images/` não inclui subpastas.
- Pacotes com `import` em `lib/`: os demais de `dependencies`. `freezed` não tem `import`, mas gera `auth_state.freezed.dart` pelo `build_runner`; `mobx_codegen` e `build_runner` também ficam pela geração; `flutter_lints` é usado por `analysis_options.yaml`; `flutter_test` fica para os testes futuros.
- `.DS_Store`: nenhum está versionado (o `.gitignore` já os ignora); os que existem só no disco não entram no repositório.

## Comportamento
Nenhuma mudança visível. Títulos continuam em Bricolage Grotesque, texto em Figtree, e os ícones de redes, compartilhamento, logo, parceiros e capa do vídeo aparecem como hoje. Nenhum texto de interface muda.

## Estados
Sem mudança: carregando, vazio, erro e falha de imagem continuam como estão em cada tela.

## Responsivo
Sem mudança em 390, 768 e 1280 px.

## Acessibilidade
Sem mudança.

## Dados e regras de negócio
Não mudam modelos, coleções e regras do Firebase, rotas, o painel nem os ícones e metadados de `web/`. Remover `flutter_quill_extensions` não muda a leitura de posts: nenhum construtor de embeds dele está registrado hoje.

## Critérios de aceite
- [x] 1. Os 19 arquivos da tabela não existem mais no repositório, e a pasta `packages/` saiu.
- [x] 2. Busca vazia em `lib/`, `web/`, `tool/`, `pubspec.yaml` e `.github/` por `[Dd]osis` e por `\.png['"]` em `lib/`; o `pubspec.yaml` declara só as famílias `BricolageGrotesque` e `Figtree`.
- [x] 3. Busca vazia em `lib/` e `tool/` por `carousel_slider|google_fonts|GoogleFonts|cached_network_image|CachedNetworkImage|flutter_staggered_grid_view|file_saver|FileSaver|flutter_quill_extensions|FlutterQuillEmbeds|cupertino_icons|CupertinoIcons`, e nenhum desses 7 pacotes aparece no `pubspec.yaml`.
- [x] 4. Depois de `fvm flutter pub get`, o `pubspec.lock` não lista nenhum dos 7 pacotes e só perde entradas: nenhum pacote que fica muda de versão nem entra pacote novo.
- [x] 5. Todo asset que fica tem referência no código, em `web/` ou em `tool/` (conferido com a lista de "O que fica"), e as licenças OFL da Bricolage Grotesque e da Figtree continuam em `assets/fonts/licenses/`.
- [x] 6. `fvm flutter analyze` sem erros nem avisos e `fvm dart run build_runner build --delete-conflicting-outputs` sem diferença de conteúdo nos arquivos gerados (diferença só de formatação, que já existia, é aceita).
- [x] 7. `fvm flutter build web --release` termina sem erro, e `build/web/assets/` não tem `Dosis`, os PNG nem as 5 imagens removidas, nem a fonte `CupertinoIcons`.
- [x] 8. Home (logo, capa do vídeo, parceiros, redes no rodapé), um post (ícones de compartilhamento), nossa história (imagem), biblioteca, fale com a gente, colabore, 404 e login sem mudança visual em 390, 768 e 1280 px, com títulos em Bricolage Grotesque e texto em Figtree, comparando com capturas tiradas antes; sem `overflow` nem asserção de layout no modo debug e sem erro de asset no console.

## Fora do escopo
- Mover `freezed` para `dev_dependencies` ou atualizar versões de pacotes: mexe no `pubspec.lock` além da remoção e não é limpeza de algo sem uso.
- Assets em `web/` e scripts de `tool/`: estão em uso.
- Barra lateral do painel (`logo.webp`, `lupa.webp`): fica como está.
- Seção `scripts:` e `description` do `pubspec.yaml`.
- Atualizar a regra de `num_extension` no `CLAUDE.md`: fica para a pessoa, como na 027.

## Perguntas em aberto
- Nenhuma.

## Decisões tomadas sem a pessoa (modo autônomo)
- Além dos dois pacotes herdados da 027, saem outros cinco sem nenhum `import` (`cached_network_image`, `flutter_staggered_grid_view`, `file_saver`, `flutter_quill_extensions`, `cupertino_icons`), porque o item pede "outros pacotes sem referência encontrados por busca".
- O arquivo vazio em `packages/` sai: não tem conteúdo e fica fora de `lib/`.
- `freezed`, `mobx_codegen`, `build_runner`, `flutter_lints` e `flutter_test` ficam, mesmo sem `import` em `lib/`, por serem usados na geração de código, na análise ou nos testes.
- Spec aprovada sem parada, conforme o modo autônomo.

## Histórico de mudanças
- 2026-10-07: criada e aprovada (modo autônomo).
- 2026-10-07: critério 6 ajustado. O `build_runner` regera `library_document_store.g.dart` com quebras de linha diferentes das versionadas (o arquivo foi formatado com largura 100). Acontece igual antes da remoção dos pacotes, então não vem desta spec; o arquivo versionado fica como está e o critério passa a aceitar diferença só de formatação.
