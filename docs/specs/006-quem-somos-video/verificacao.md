# Verificação da 006. Home: Quem somos e vídeo

- **Data:** 2026-09-26
- **Resultado:** aprovada (dois problemas encontrados e corrigidos: vídeo bloqueado pelo navegador caía no estado de erro; título de Quem somos quebrava palavras com texto a 200% no desktop)

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found, antes e depois das correções |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro, antes e depois das correções |
| Build de `main.dart` servido por Python com fallback de SPA + navegador embutido | 1280 px com clique real em "Assistir" (o painel do navegador tem 586 px; a emulação de 1280 px funciona, mas o clique precisou de coordenadas corrigidas pela escala). `scrollWidth` igual à largura |
| Builds de teste só na cópia do scratchpad (`--dart-define`, nada no repositório) | texto a 200% (`TextScaler` 2,0 no `MaterialApp`) em 1280 e 390 px; vídeo atrás de um proxy que demora 8 s (ativação expirada); o mesmo com início automático forçado e `play()` recusado com `NotAllowedError` (simulando o bloqueio de som do Safari); proxy apontando para endereço inválido (erro) |

Todas as tarefas do [tasks.md](tasks.md) estão marcadas. Revisão feita no código dos commits `0ef39fc`, `3439e45` e `3db8d0f`, não só no relatório da implementação.

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Quem somos abaixo de Destaques e vídeo antes de Nossa história; foto de tela cheia, parágrafo longo e "MANIFESTO" sumiram | passou | `home_page.dart` (slivers `WhoWeAreSection` → `PresentationVideoSection`); `components/who_we_are.dart` apagado. Tela a 1280: Destaques (esqueleto) → Quem somos → vídeo → "NOSSA HISTÓRIA" |
| 2 | Textos exatos, rótulo, título, missão, link e três públicos sobre a superfície | passou | `who_we_are_section.dart` (textos iguais à spec); tela a 1280 |
| 3 | "Conheça o manifesto" abre `/manifest` por clique, Enter e leitor de tela | passou | `ArrowLink`: `Semantics(link, onTap)` + `InkWell`; testes temporários da implementação (toque, Enter, semântica) |
| 4 | Duas colunas 1 : 1,15 em 1280; uma coluna em 768 e 390 | passou | `whoWeAreIntroFlex` 20 : `whoWeAreAudienceFlex` 23; tela a 1280 em duas colunas. Com texto a 130% ou mais passa a uma coluna também no desktop (correção 2) |
| 5 | Nada toca nem é baixado ao abrir a Home; capa, legenda e "Assistir" | passou | Nenhum recurso `.mp4` nem `video-capa` em `performance.getEntriesByType('resource')` antes do clique; nenhum `<video>` na página; tela com capa, legenda e botão |
| 6 | Capa gerada sem o arquivo; imagem recortada com ele | passou | Sem requisição à capa (acima); com arquivo, conferido pela implementação numa cópia |
| 7 | "Assistir" → carregando → player no mesmo quadro, com som, foco em "Pausar vídeo"; bloqueio de som deixa pausado | passou (depois da correção 1) | Clique real a 1280: `paused` falso, `muted` falso, `volume` 1, quadro de 1056 × 460 com faixas escuras. Pausar pelo botão do player funciona (`paused` verdadeiro, ícone troca). Ativação expirada (proxy de 8 s): `userActivation.isActive` falso quando o vídeo fica pronto → player pausado com "Reproduzir vídeo"; um clique toca com som. Bloqueio pelo navegador (`NotAllowedError` simulado): antes da correção mostrava "Não foi possível carregar o vídeo."; depois, player pausado e pronto, e o clique em reproduzir toca. Foco em "Pausar vídeo" pelo teclado: conferido pela implementação |
| 8 | Falha → mensagem e "Tentar de novo"; bloco não some | passou | Proxy para endereço inválido: caixa "Não foi possível carregar o vídeo." com "Tentar de novo" sobre a capa (depois da correção 1, o caminho de erro continua igual) |
| 9 | Sair da Home para o vídeo | passou | Vídeo tocando → clique em "Biblioteca": `/biblioteca` e nenhum `<video>` na página |
| 10 | Proporções 16 : 10 / 16 : 8, máximo 460 px, cantos arredondados | passou | 1280: 1056 × ≈ 459 px (medido na tela); `videoAspectRatio` e `videoMaxHeight` no tema; raio `r18`. 390 e 768 pela implementação e pelos testes temporários |
| 11 | Tab na ordem visual, foco visível, nomes acessíveis, cabeçalhos, decorativos ignorados | passou | Código: `AppFocusRing` no link e no botão, `Semantics(header)` no título e na legenda, `ExcludeSemantics` na capa e nos ícones, tooltips dos controles; testes da implementação |
| 12 | Contrastes | passou | `accentStrong` #A33600 e `inkSecondary` #5E5852; medições da implementação (6,26:1, 6,45:1, 7,63:1, ≥ 7,6:1) conferidas contra os tokens usados |
| 13 | Movimento reduzido sem crescimento nem transições | passou | `VideoPlayButton` e `PresentationVideoSection`: `Duration.zero` e sem escala com `disableAnimations`; testes da implementação |
| 14 | 390, 768 e 1280 (e 200%) sem rolagem horizontal, sem sobreposição e sem `overflow` | passou (depois da correção 2) | `scrollWidth` = largura em 1280 e 390 (também a 200%). A 200% em 1280: legenda e botão sem sobreposição. Antes da correção, o título de Quem somos a 200% no desktop quebrava palavras ao meio ("co / mpartilhar", "conhecime / nto"); agora a seção fica em uma coluna e o título quebra só entre palavras |
| 15 | `AppVideoPlayer` igual no painel admin | passou (por leitura de código) | Ver "Painel administrativo" abaixo |
| 16 | Só tokens, sem `num_extension`; analyze e build sem erro | passou | Busca por `Color(0x`, `.scale`, `.fontSize`, `verticalSpacing`, `GestureDetector` e números soltos nos arquivos novos: nada fora dos tokens. Analyze e build acima |

### Painel administrativo (critério 15)
Única chamada: `view_image_dialog.dart` com `AppVideoPlayer(url: ...)`, sem nenhum parâmetro novo. Com os padrões:
- `_followsController` é falso (sem `onError` nem `onAutoplayBlocked`): nenhum ouvinte novo no controller;
- `shouldStartPlaying` nulo: nada toca sozinho e `_autoStartPending` nunca liga; `onInitialized` nulo; `autofocusControls` falso (o `AppIconButton` recebe `focusNode: null`, como antes); `showControlsScrim` falso (sem véu e com `EdgeInsets.zero`, o mesmo layout);
- erro de `initialize` continua em `_error = true` (agora por `_handleError`, que só acrescenta `onError?.call()`);
- a troca de ordem em `_togglePlayPause` (estado antes de `play()`/`pause()`) acontece dentro do mesmo `setState`; sem ouvinte, o resultado final é idêntico ao de antes.

Não conferido no navegador (sem credenciais de teste).

### Import condicional (`core/utils/browser/user_activation*.dart`)
`export 'user_activation_stub.dart' if (dart.library.js_interop) 'user_activation_web.dart'`: na web (JS e Wasm) usa `navigator.userActivation.isActive` do pacote `web` (já dependência do projeto); fora dela devolve `true`. A leitura fica em `try/catch`, e navegador sem a API devolve `false` (o vídeo fica pausado esperando o clique, em vez de falhar). Compila na web (build acima) e o analyze não aponta nada. Comportamento real conferido: a ativação expira em cerca de 2 s no navegador embutido, e o vídeo que fica pronto depois disso aparece pausado.

## Problemas encontrados
1. **Bloqueio do som pelo navegador levava ao estado de erro** (bloqueava o critério 7). O `video_player_web` transforma a recusa de `play()` em erro do controller; com `onError` ligado, a seção mostrava "Não foi possível carregar o vídeo.", e "Tentar de novo" repetiria o bloqueio. Acontece quando a ativação ainda vale mas o navegador recusa o som (Safari, Firefox com "bloquear áudio"). No Chromium do painel não acontece, porque a ativação persistente basta; reproduzido recusando `play()` com `NotAllowedError`. **Corrigido** (commit `c597903`): o `AppVideoPlayer` ganhou o aviso opcional `onAutoplayBlocked` (erro depois do início automático e antes de o vídeo avançar), e a seção monta o player de novo sem início automático, pausado e pronto. Conferido de novo: player pausado com "Reproduzir vídeo"; o clique toca com som; o erro de carregamento continua indo para "Tentar de novo". Painel admin sem mudança (parâmetro desligado por padrão).
2. **Título de Quem somos quebrando palavras com texto a 200% no desktop** (ajuste, critério 14). **Corrigido** (commit `5fe28e6`): a partir de 130% de ampliação a seção fica em uma coluna, como os atalhos do hero (token `whoWeAreStackTextScale`). Conferido de novo a 1280 e 200%: uma coluna, sem palavra partida. Em 100% continua em duas colunas.

## Observações (detalhes, fora dos critérios)
- A 390 px com texto a 200%, "conhecimento." (54 px) não cabe na linha e ainda quebra no meio. Só se resolveria limitando a ampliação do título, o que vai contra o texto ampliável. Não corrigido.
- A seta do "Conheça o manifesto" não acompanha a ampliação do texto (ícone decorativo, tamanho do tema).

## Não conferido
- Painel administrativo no navegador (sem credenciais de teste); conferido por leitura de código (acima).
- Bloqueio real de som no Safari ou no Firefox (não há esses navegadores aqui): o caminho foi exercitado recusando `play()` com o mesmo erro (`NotAllowedError`) que eles lançam.
- 390 e 768 px com o build final: a correção 2 só muda o layout com texto ampliado no desktop; 390 e 768 a 100% foram conferidos pela implementação e 390 a 200% nesta verificação.
