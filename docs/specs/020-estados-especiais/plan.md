# Plano da 020. Estados especiais

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-05

## Abordagem
Três frentes, todas em `core`, para que as telas atuais e as specs 021/022 usem as mesmas peças.

1. **404.** A `PageNotFound` é reescrita sobre o `ReadingPageScaffold` (navbar, corpo, rodapé na base), com o corpo num `PageContent` e respiros de leitura. O conteúdo é a `StateMessageBox` de sempre, que ganha duas opções: `leading` (um widget no lugar do ícone em círculo, aqui o "404") e `titleHeadingLevel` (título marcado como `h1`). As ações vão num `Wrap` centralizado, que empilha os dois botões quando não cabem. Os sete pontos que constroem `const PageNotFound()` não mudam.
2. **Esqueleto com brilho.** O `Skeleton` passa a ter um `AnimationController` em repetição (1,4 s) que desliza um `LinearGradient` de três paradas (base, claro, base) por um `GradientTransform` de translação, como o `background-position` do protótipo. Com `MediaQuery.disableAnimationsOf`, o controlador para e o bloco fica na cor base. Cores e duração saem do tema. A assinatura (`width`, `height`) não muda, então todos os esqueletos atuais herdam o brilho sem tocar neles.
3. **Erro discreto da Home.** As duas cópias de `_Error` (Destaques e Equipe) viram um `StateErrorInline(message:, onRetry:)` em `core/components/error_content/`, com o mesmo desenho de hoje (superfície, borda, raio 16, texto `inkSecondary` e `SecondaryButton.small` "Tentar de novo" num `Wrap`).

Por fim, saem `EmptyContent` e `PageErrorContent`, sem uso.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_colors/app_colors.dart` | `skeletonBase` (#EEEAE4) e `skeletonHighlight` (#F8F6F3), do protótipo |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | `skeletonShimmer` (1,4 s); tokens da 404: `notFoundActionsGap` (12), `notFoundCodeGap` (respiro entre "404" e título) |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `notFoundCode`: Bricolage 800, altura 1, espaçamento −0,04 em, 64/92/112 px por faixa (o `clamp(4rem,12cqi,7rem)` do protótipo) |
| Alterar | `lib/app/core/components/skeleton/skeleton.dart` | Brilho animado com tokens; parado com movimento reduzido |
| Alterar | `lib/app/core/components/error_content/state_message_box.dart` | `leading` opcional (substitui o ícone; `icon` passa a opcional, com assert de um dos dois) e `titleHeadingLevel` opcional (`Semantics(header: true, headingLevel:)`) |
| Criar | `lib/app/core/components/error_content/state_error_inline.dart` | Faixa de erro discreta das seções da Home |
| Alterar | `lib/app/features/home/presentation/components/highlights/highlights_section.dart` | Trocar `_Error` por `StateErrorInline` |
| Alterar | `lib/app/features/home/presentation/components/team/team_section.dart` | Trocar `_Error` por `StateErrorInline` |
| Alterar (reescrever) | `lib/app/router/page_not_found.dart` | 404 nova (ver "Abordagem"); sem `num_extension` |
| Remover | `lib/app/core/components/error_content/empty_content.dart` | Sem uso, desenho antigo |
| Remover | `lib/app/core/components/error_content/page_error_content.dart` | Sem uso, desenho antigo |
| Alterar | `docs/arquitetura.md` | `error_content` (inclui `StateErrorInline`, opções novas da `StateMessageBox`), `skeleton` com brilho, 404 em `router/` |

Não mudam: `app_router.dart`, `app_routes.dart`, páginas que retornam `PageNotFound`, `StateErrorBox`, textos de vazio e erro das listagens, `image_error_content.dart`, `app_network_image.dart`, `app_rounded_image.dart`, `loading/*`, `loading_content.dart`, painel.

## Decisões técnicas
- **Estender a `StateMessageBox` em vez de criar uma caixa só para a 404.** Mantém borda, raio, padding e largura do texto num lugar só. Alternativa: extrair a moldura e criar `NotFoundBox`; mais arquivos para um uso.
- **Título como `h1` por parâmetro**, e não sempre: nas listagens a caixa fica abaixo do `h1` da página e não deve competir com ele.
- **"404" lido como texto** (sem `ExcludeSemantics`), antes do `h1`, conforme a spec.
- **Um controlador por esqueleto.** Simples e já é o que o `State` com `SingleTickerProviderStateMixin` prevê. As telas têm no máximo algumas dezenas de blocos; o custo é de repintura, sem layout. Os blocos de uma mesma tela começam juntos, então o brilho fica sincronizado. Alternativa (um ticker global por `InheritedWidget`) só se a conferência mostrar descompasso visível.
- **Faixa que corre:** gradiente com paradas 0,25 / 0,37 / 0,63 e translação de +1 a −1 largura do bloco, imitando `background-size:400%` e `background-position` de 100 % a 0 %. `RepaintBoundary` em volta para não repintar vizinhos.
- **Botões da 404 em `.medium`**, como os do hero e do cabeçalho de categoria; `Wrap` com `alignment: center`, `spacing`/`runSpacing` de `notFoundActionsGap`. Rotas por `AppRoutes.root` e `AppRoutes.library`, navegando com `GoRouter.go`.
- **404 no alto do corpo**, com respiro de topo `listingStatePaddingTop` e de baixo `readingPaddingBottom(breakpoint)`, como as outras caixas de estado em página.

## Dependências e geração de código
- Sem pacote novo, sem asset novo, sem `build_runner`.
- Sem rota nova nem mudança em `app_router.dart`; nada em `*_setup.dart`.

## Riscos e cuidados
- **`StateMessageBox` é usada em listagens, visualizador de PDF e na `StateErrorBox`.** Os parâmetros novos são opcionais e o padrão mantém o desenho; conferir categoria vazia, busca sem resultado, lista da biblioteca sem resultado e erro.
- **`Skeleton` está em todas as telas novas** e no menu de categorias. Conferir carregando na Home (destaques, equipe), menu, categoria, todas as publicações, post, pessoa, biblioteca (índice e lista) e documento, nas três larguras, em debug: o `Container` com `width`/`height` nulos dentro de `AspectRatio`/`Expanded` não pode mudar de tamanho.
- **Movimento reduzido no Flutter Web:** outros componentes já usam `MediaQuery.disableAnimationsOf`; conferir com `prefers-reduced-motion: reduce` emulado no CDP. Se o Flutter não repassar, registrar como ressalva (afeta também os componentes atuais), sem gambiarra.
- **Esqueleto rápido demais para ver:** com rede local o carregamento some logo; usar limitação de rede do CDP (ex.: "Slow 3G") para observar o brilho.
- **Erro difícil de provocar:** o Firestore offline pode servir cache ou esperar em vez de falhar. Tentar bloquear `firestore.googleapis.com` por CDP (`Network.setBlockedURLs`); se não cair no erro, conferir Destaques e Equipe pelo código e registrar.
- **404 com navbar:** em categoria inexistente de uma área válida, a navbar pode marcar a área; a spec só exige "nenhum item marcado" no endereço desconhecido.
- **Remoção de componentes:** conferir com `grep` que `EmptyContent` e `PageErrorContent` não têm uso (painel inclusive) antes de apagar.

## Como conferir
- `fvm dart format` nos `.dart` alterados e `fvm flutter analyze` numa cópia em caminho ASCII.
- `fvm flutter build web --release`, servir `build/web` com fallback de SPA e abrir no navegador embutido (ou Chrome headless por CDP) em 390, 768 e 1280: `/nao-existe`, `/publicacoes/xyz/abc`, categoria, post, documento e membro inexistentes; telas com esqueleto sob rede lenta; erro com o Firestore bloqueado.
- `fvm flutter run -d web-server --web-port <porta>` na cópia ASCII (modo debug), sem `overflow` nem asserção no console.
- `git diff` sem mudança em rotas, modelos e painel.
