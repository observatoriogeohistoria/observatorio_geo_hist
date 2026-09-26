# Tarefas da 006. Home: Quem somos e vídeo

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo (rodado na cópia em caminho ASCII do scratchpad). Critérios numerados na ordem da spec (1 = posição, 16 = tokens/analyze/build).

## Grupo A: Tokens e peças compartilhadas
- [x] **A1.** Tokens: cores `videoCoverMid`, `videoCoverEnd`, `videoBackdrop`; estilos `splitTitle`, `sectionLead`, `listTitle`, `videoCaption`; em `ComponentSizes` os tamanhos de Quem somos e do vídeo listados no plano, com comentário de origem no protótipo; constante `AppAssets.videoCover` (`assets/images/video-capa.webp`). Arquivos: `app_colors.dart`, `app_text_styles.dart`, `app_dimensions.dart`, `core/utils/constants/app_assets.dart`. Conferir: valores iguais ao plano. Atende: critérios 10, 12, 14 e 16. Feito; tokens extras: `videoPlayIcon`, `videoLoadingIndicator`, `videoAnimation`, ângulo e posição do meio do degradê, `videoControlsScrimSolidFrom` e `videoControlsInset`. Cada grupo de tokens entrou no commit do seu primeiro uso.
- [x] **A2.** `ArrowLink` (texto em laranja forte + seta decorativa, sem preenchimento, `Semantics(link, onTap)`, `AppFocusRing`, vão da seta 6 → 9 px no hover, sem animação com movimento reduzido). Arquivo: `core/components/buttons/arrow_link.dart`. Conferir: teste temporário de semântica (link com ação de toque) e Enter. Atende: critérios 3, 11 e 12. Feito. Testado (temporário): semântica de link com ação de toque, Enter e toque abrem `/manifest`.
- [x] **A3.** `AppIconButton` ganha `autofocus` opcional (padrão `false`). Arquivo: `core/components/buttons/app_icon_button.dart`. Conferir: nenhuma chamada existente muda (`grep AppIconButton(`). Atende: critérios 7 e 11. Feito com `focusNode` opcional em vez de `autofocus`: o `autofocus` do Flutter é ignorado quando outro elemento já tem o foco (o botão "Assistir"). Nenhuma chamada existente mudou.
- [x] **A4.** `AppVideoPlayer` ganha parâmetros opcionais `onInitialized`, `onError` (falha de `initialize` e `value.hasError` durante a reprodução, só se passado), `loadingPlaceholder`, `shouldStartPlaying` (avaliado depois de pronto; se falso, fica pausado), `autofocusControls` e `showControlsScrim` (degradê `imageScrim` 0 → 0,72 atrás dos controles). Sem esses parâmetros, o código segue o caminho de hoje. Arquivo: `core/components/video_player/app_video_player.dart`. Conferir: leitura de `view_image_dialog.dart` (chamada sem parâmetros novos) e teste temporário com `VideoPlayerPlatform` falso nos dois modos. Atende: critérios 7, 8, 12 e 15. Feito. Também corrigida a ordem em reproduzir/pausar (o estado muda antes de chamar o controller, que avisa os ouvintes dentro de `play()`); com véu, os controles ficam afastados 8 px da borda para o contorno de foco não ser cortado. `view_image_dialog.dart` segue sem parâmetros novos.

## Grupo B: Quem somos
- [x] **B1.** `AudienceItem` (ícone decorativo em círculo `accentSoft`, nome `listTitle`, descrição `regular` em `inkSecondary`, linha acima; `MergeSemantics`). Arquivo: `components/who_we_are/audience_item.dart`. Atende: critérios 2, 11 e 12. Feito; ícone em `accent` (decorativo, como os atalhos do hero).
- [x] **B2.** `WhoWeAreSection`: fundo `surface`, `PageContent`, respiro de seção; rótulo "QUEM SOMOS" em `accentStrong`, título `splitTitle` com `Semantics(header)`, texto de missão (560 px), `ArrowLink` "Conheça o manifesto" → `/manifest`; três públicos com os textos exatos da spec e linha abaixo do último; desktop em `Row` 20 : 23 alinhada ao topo com vão de 72, tablet/celular em `Column` com vão 44/28. Arquivo: `components/who_we_are/who_we_are_section.dart`. Atende: critérios 2, 3, 4, 11, 12 e 14. Feito.

## Grupo C: Vídeo
- [ ] **C1.** `VideoCover`: consulta o `AssetManifest`; com `video-capa.webp`, `Image.asset` em `cover` com `errorBuilder` para a capa gerada; sem ele, `VideoCoverPainter` (degradê 150° `ink → videoCoverMid → videoCoverEnd` e anéis brancos 0,08, passo 31, centro 75 % × 35 %); tudo em `ExcludeSemantics`. Véu na base e legenda "Conheça o Observatório" (`videoCaption`, branco, `Semantics(header)`, 2 linhas com reticências). Arquivo: `components/video/video_cover.dart`. Conferir: sem o arquivo, nenhum 404 no console; com um `video-capa.webp` de teste só na cópia do scratchpad, a imagem aparece recortada. Atende: critérios 5, 6, 11, 12 e 14.
- [ ] **C2.** `VideoPlayButton`: pílula branca com sombra, círculo laranja 46 com `Icons.play_arrow_rounded`, texto "Assistir"; modo carregando com indicador (ícone estático com movimento reduzido) e texto "Carregando vídeo" (anunciado); nome acessível "Reproduzir vídeo de apresentação"; `AppFocusRing` de pílula; Enter/Espaço; escala 1,03 no hover (sem escala com movimento reduzido). Arquivo: `components/video/video_play_button.dart`. Atende: critérios 5, 7, 11 e 13.
- [ ] **C3.** `PresentationVideoSection`: quadro com proporção por faixa (16 : 10 no celular, 16 : 8 no tablet/desktop), altura máxima 460, raio 18, altura mínima em vez de fixa (cresce com texto ampliado); `loadLibrary()` do player no `initState`; estados capa → carregando → tocando | erro; `AppVideoPlayer` montado atrás da capa só depois de "Assistir", com `onInitialized`, `onError`, `loadingPlaceholder` vazio, `shouldStartPlaying` pela `navigator.userActivation.isActive`, `autofocusControls` e `showControlsScrim`; erro com caixa branca "Não foi possível carregar o vídeo." e `SecondaryButton.small("Tentar de novo")` que remonta o player com chave nova; sem `AnimatedSwitcher` com movimento reduzido. Arquivo: `components/video/presentation_video_section.dart`. Atende: critérios 5, 7, 8, 9, 10, 13 e 14.

## Grupo D: Home e documentação
- [ ] **D1.** `HomePage`: sliver de Quem somos com `WhoWeAreSection` e sliver do vídeo com `PresentationVideoSection` (sem `FutureBuilder`, sem `startPlaying`/`startMuted`); apagar `components/who_we_are.dart`; remover imports sem uso. Arquivos: `pages/home_page.dart`, `components/who_we_are.dart` (apagar). Conferir: ordem Destaques → Quem somos → vídeo → Nossa história. Atende: critérios 1 e 5.
- [ ] **D2.** Atualizar a seção "Home" de `docs/arquitetura.md` (Quem somos, vídeo com estados e capa opcional, `ArrowLink`, parâmetros novos do `AppVideoPlayer`). Atende: documentação.

## Grupo E: Conferência
- [ ] **E1.** `fvm flutter analyze` (cópia ASCII) e `fvm flutter build web --release` sem erro; busca por `.scale`, `.fontSize`, `.verticalSpacing`, `Color(0x` e números de tamanho soltos nos arquivos novos sem ocorrências; conferir por leitura que `view_image_dialog.dart` e as demais chamadas de `AppIconButton` e `AppVideoPlayer` não mudaram. Atende: critérios 15 e 16.
- [ ] **E2.** Testes de widget **temporários, só na cópia do scratchpad** (não entram no repositório), com um `VideoPlayerPlatform` falso (pronto, lento, erro, erro durante a reprodução): Quem somos em 390, 768 e 1280 px (uma/duas colunas, textos exatos, link para `/manifest` com `GoRouter` por toque, Enter e semântica); vídeo: nenhum `create` no platform antes de "Assistir", "Carregando vídeo", player pronto com foco em "Pausar vídeo", `shouldStartPlaying` falso deixa pausado, erro e "Tentar de novo", altura do quadro igual antes e depois de tocar, proporções por faixa, texto a 200 % sem exceção de `overflow`, movimento reduzido sem quadros pendentes; `AppVideoPlayer` sem parâmetros novos com o comportamento antigo. Anotar o número de testes. Atende: critérios 2, 3, 4, 5, 7, 8, 10, 11, 13, 14 e 15.
- [ ] **E3.** Rodar o app real (build de `main.dart` servido por Python com fallback de SPA) no navegador embutido em **390, 768 e 1280 px**: Quem somos e vídeo conforme "Responsivo", transições Destaques/hero → Quem somos → vídeo → Nossa história sem vão, aba de rede sem requisição ao MP4 ao abrir a Home, "Assistir" toca com som e sem salto de altura, foco em "Pausar vídeo", navegar para `/manifest` com o vídeo tocando e confirmar que parou, Tab/Enter e contorno de foco no link e no botão, `scrollWidth` igual à largura, console sem `overflow` nem 404 da capa; contraste calculado (rótulo/link, legenda sobre véu com capa branca, ícones dos controles). Erro: só na cópia do scratchpad, build com endereço de vídeo inválido e com um `video-capa.webp` de teste, conferindo "Não foi possível carregar o vídeo.", "Tentar de novo" e a capa com imagem. Voltar o navegador ao preset desktop, parar os servidores e confirmar com `git status` que nada de teste entrou no repositório. Painel admin: não conferido no navegador (sem credenciais de teste). Atende: critérios 1 a 14.

## Critérios × tarefas
| Critério | Tarefas |
|---|---|
| 1 | D1, E3 |
| 2 | B1, B2, E2, E3 |
| 3 | A2, B2, E2, E3 |
| 4 | B2, E2, E3 |
| 5 | C1, C2, C3, D1, E2, E3 |
| 6 | C1, E3 |
| 7 | A3, A4, C2, C3, E2, E3 |
| 8 | A4, C3, E2, E3 |
| 9 | C3, E3 |
| 10 | A1, C3, E2, E3 |
| 11 | A2, A3, B1, B2, C1, C2, E2, E3 |
| 12 | A1, A2, A4, B1, B2, C1, E3 |
| 13 | C2, C3, E2, E3 |
| 14 | A1, B2, C1, C3, E2, E3 |
| 15 | A4, E1, E2 |
| 16 | A1, E1 |
