# Plano da 005. Home: destaques

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-09-26

## Abordagem
O carrossel de [highlights.dart](../../../lib/app/features/home/presentation/components/highlights.dart) é substituído por uma seção nova da feature `home`, dentro de `PageContent`, com o título "Destaques" e uma grade que muda conforme a quantidade (1, 2 ou 3 cartões) e a faixa de largura. O `FetchHighlightsStore` **não muda** (nem modelo, nem datasource, nem repositório, nem `build_runner`): a seção observa `state` e `highlights` e decide o que mostrar. A escolha dos três destaques (ordem por `createdAt` decrescente, nulos no fim, descarte de posts sem `body`/`id`/área, limite de três) fica numa função pura da apresentação, fácil de testar.

Os estados seguem o padrão já usado: esqueleto na mesma disposição do conteúdo (com o `Skeleton` existente, como o `_LoadingRows` da navbar), erro com mensagem e botão "Tentar de novo" (`SecondaryButton.small`), e vazio que esconde a seção inteira. Para o erro e o "Tentar de novo" funcionarem mesmo quando as categorias falham, a `HomePage` passa a disparar a busca também quando a Home abre com as categorias já resolvidas (sucesso ou erro) e o store ainda está no estado inicial; o rótulo e o endereço usam a área da categoria ou, na falta dela, `post.areas.first`.

O cartão é um `InkWell` em `Material` com `AppFocusRing` (raio 16), `Semantics(link: true, onTap: ...)` com rótulo completo e `excludeSemantics`, seguindo a correção da 004 (ação de toque na semântica). A legibilidade do texto sobre qualquer foto vem de um degradê ancorado **no bloco de texto** (e não no cartão todo): atrás do texto a opacidade nunca fica abaixo de 0,72, e acima dele uma faixa curta esmaece até 0. Isso garante ≥ 4,5:1 mesmo com foto branca e deixa a parte de cima da foto limpa, como pede o planejamento ("degradê só sob o título").

Para conferir 0, 1, 2, 3 e mais de 3 destaques sem tocar no Firebase, tudo roda numa **cópia do projeto no scratchpad** (a mesma cópia ASCII já usada para o `analyze`): testes de widget temporários com um repositório falso e um ponto de entrada de pré-visualização (`lib/main_destaques_preview.dart` só na cópia) que registra um `FetchHighlightsRepository` falso no GetIt, escolhido por parâmetro de URL. Nada disso é copiado de volta para o repositório.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_colors/app_colors.dart` | Cores do cartão sobre foto: `imageScrim` (#14100E, o `rgba(20,16,14)` do `.feat::before`), `onImageAccent` (#FFC9A6, rótulo `.feat .tag`), `onImageMuted` (#D8D2CA, data; mesmo valor de `footerText`), `imagePlaceholder` (#2B2622, fundo escuro sem imagem) |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | Estilos `featureTitle` (principal: 24/32/35, peso 700, altura 1,12) e `featureTitleSmall` (menores: 18/22/24, peso 700, altura 1,2), a partir dos `clamp()` de `.feat.big h3` e `.feat h3` |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Tokens em `ComponentSizes`: respiro vertical de seção por faixa (48/72/96, `.section`), vão do título até a grade (28, `.section-head`), altura da grade por faixa (tablet 400, desktop 440), alturas no celular (principal 340, demais 220), vão entre cartões (16), proporção das colunas (1,6 : 1), preenchimento interno do texto (24; 20 no celular), vão entre rótulo/título/data (8), largura máxima do título principal (22 em), linhas máximas do título (3), opacidades do degradê (0,88 na base, 0,72 no topo do texto) e altura da faixa de esmaecimento (72), tamanho do ícone "sem imagem" (28) |
| Alterar | `lib/app/core/utils/date/date.dart` | Getter `shortDate` ("12 mar 2026", meses abreviados em minúsculas), aditivo à extensão existente |
| Criar | `lib/app/features/home/presentation/components/highlights/select_highlights.dart` | Função pura `selectHighlights(List<PostModel>)` (ordena, descarta incompletos, limita a 3) e `highlightArea(PostModel)` (área da categoria ou do post) |
| Criar | `lib/app/features/home/presentation/components/highlights/highlight_card.dart` | Cartão: foto `cover` com placeholder escuro (sem URL, carregando e erro), degradê ancorado no texto, rótulo "TIPO · ÁREA", título com `maxLines` e reticências, data opcional, hover com sublinhado, `AppFocusRing`, `Semantics` link com `onTap` |
| Criar | `lib/app/features/home/presentation/components/highlights/highlights_grid.dart` | Disposição por quantidade e faixa (coluna no celular; `Row` com `Expanded` 1,6 : 1 e coluna direita dividida no tablet/desktop), reutilizada pelo esqueleto |
| Criar | `lib/app/features/home/presentation/components/highlights/highlights_section.dart` | A seção: `Observer` no store; vazio → `SizedBox.shrink`; carregando/inicial → título + esqueleto; erro → título + caixa com mensagem e "Tentar de novo"; sucesso → título + grade |
| Apagar | `lib/app/features/home/presentation/components/highlights.dart` | Carrossel antigo, substituído pela seção |
| Alterar | `lib/app/features/home/presentation/pages/home_page.dart` | Sliver de destaques usa a seção nova (continua `deferred`); disparo da busca quando as categorias já estão resolvidas ao abrir a Home; retry com as categorias atuais |
| Alterar | `docs/arquitetura.md` | Seção "Home": destaques (seleção, cartão e estados) |

`highlights_dialog_carousel.dart` e os campos `highlightsDialog*` do store ficam como estão (sem uso, fora do escopo; limpeza na Fase 7).

## Decisões técnicas
- **Store intacto.** Ordenar e limitar na apresentação evita `build_runner` e mudança de contrato; a função pura é testável sem MobX. Alternativa (computed no store) descartada por exigir geração de código sem ganho.
- **Disparo da busca.** Hoje só a `reaction` nas categorias dispara; se a Home abre com categorias já carregadas (voltando de outra página) nada é buscado, e se as categorias falham, a busca nunca acontece. Acrescentar em `initState`: se `FetchCategoriesStore.state` for sucesso ou erro e o store de destaques estiver no estado inicial, buscar com as categorias atuais. A `reaction` continua (ela atualiza as categorias dos posts quando chegam). "Tentar de novo" chama `fetchHighlights` com as categorias atuais.
- **Degradê ancorado no texto.** Coluna posicionada na base do cartão: faixa de esmaecimento (altura do token, `imageScrim` de 0 a 0,72) seguida do bloco de texto com fundo em degradê de 0,72 (topo) a 0,88 (base). Contraste mínimo com foto branca por trás (0,72 sobre branco ≈ #56534F, luminância ≈ 0,087): branco ≈ 7,6:1; `onImageAccent` ≈ 5,2:1; `onImageMuted` ≈ 5,1:1. O `.feat::before` do protótipo (0,55 a 38% da altura) não garante 4,5:1 para texto pequeno em cartões de 220 px.
- **Imagem.** `Image.network` direto (e não `AppNetworkImage`, que usa `num_extension` e esqueleto claro), com `fit: BoxFit.cover`, `frameBuilder` mostrando o placeholder escuro até o primeiro quadro (sem fade com movimento reduzido; 200 ms de fade sem) e `errorBuilder` com o placeholder e o ícone `Icons.image_outlined`. URL nula ou vazia → placeholder direto. Imagem envolta em `ExcludeSemantics`. SVG não é tratado (fotos de post são raster; um SVG cai no `errorBuilder` e mostra o placeholder).
- **Grade.** Celular: `Column` com alturas fixas (principal 340, demais 220). Tablet/desktop: `SizedBox(height: 400/440)` com `Row`: `Expanded(flex: 16)` principal e `Expanded(flex: 10)` com um cartão (2 destaques) ou `Column` de dois `Expanded` (3 destaques); 1 destaque ocupa a largura toda. Alturas fixas por token evitam `IntrinsicHeight` e `overflow`.
- **Texto ampliado.** Título com `maxLines` 3 e `TextOverflow.ellipsis`; o bloco de texto fica num `Flexible`/`ClipRect` para nunca exceder o cartão. A 200% o título pode cortar em menos linhas, mas não há `overflow`.
- **Hover.** `InkWell.onHover` liga o sublinhado do título (`TextDecoration.underline`, afastamento via `decorationThickness`/estilo); sem movimento, então nada muda com movimento reduzido. Sem `splash` escuro sobre a foto (`splashFactory: NoSplash`, `overlayColor` transparente), porque o foco já tem contorno.
- **Nome acessível.** "Título. Tipo, Área. 12 mar 2026" (a vírgula lê melhor que " · "). Título da seção com `Semantics(header: true)`. Esqueleto com `Semantics(label: 'Carregando destaques', excludeSemantics: true)`.
- **Erro.** Caixa com fundo `surface`, borda `line`, raio 16, texto `regular` em `inkSecondary` (6,45:1) e `SecondaryButton.small("Tentar de novo")`. Altura livre (não reserva os 440 px).
- **Tipo do post.** `PostType.portuguese` já existente; área por `PostsAreas.portuguese`; rótulo em `toUpperCase()` (padrão do estilo `label`).
- **Ícones:** Material, sem pacote novo.

## Dependências e geração de código
- Nenhum pacote novo, nenhum asset novo. `carousel_slider` continua (usado pela Equipe).
- Sem `build_runner` (nenhuma store ou modelo muda).
- Sem mudança em `app_router.dart` nem em `home_setup.dart`.

## Riscos e cuidados
- **Por que o bloco não aparecia.** Antes de tudo, conferir no build atual se a busca retorna lista vazia ou erro (aba de rede/console: a consulta `collectionGroup('category_posts')` com dois filtros pode exigir índice/isenção de grupo de coleção). Se for **erro permanente de configuração do Firebase**, o novo estado de erro apareceria para todos os visitantes: nesse caso registrar ressalva em `tasks.md` e na spec e seguir sem mexer no Firebase (o conserto é da pessoa, no console do Firebase). Se for lista vazia, a seção some, como previsto.
- **Contraste sobre foto.** Conferir com imagem branca simulada (teste de widget e pré-visualização) e com uma foto real, se houver.
- **Imagens remotas no build local.** Fotos do Firebase Storage podem ser bloqueadas por CORS no `Image.network` do CanvasKit servido localmente; se acontecer no build local, conferir se ocorre também no site atual (o carrossel usa o mesmo mecanismo) antes de tratar como defeito.
- **Disparo duplo da busca.** A `reaction` e o `initState` podem disparar duas buscas na primeira carga; a condição "store no estado inicial" evita a duplicada.
- **Transição hero ↔ blocos antigos.** A seção nova (fundo branco) fica entre o hero (superfície, com linha na base) e "Quem somos" (antigo): conferir que não sobra vão ou faixa cinza.

## Como conferir
- `fvm flutter analyze` numa cópia em caminho ASCII no scratchpad (rsync sem `build/` e `.dart_tool/`, `fvm flutter pub get`) e `fvm flutter build web --release`.
- **Casos 0, 1, 2, 3 e 5 destaques, erro, carregando, sem imagem, imagem com falha, foto branca e título longo** (sem alterar o Firebase), só na cópia do scratchpad:
  - Testes de widget temporários (`test/highlights_section_test.dart` na cópia) com `FetchHighlightsStore` real e repositório falso, em 390, 768 e 1280 px, texto a 100% e 200%, movimento reduzido ligado e desligado; conferem disposição, quantidade de cartões, textos, `maxLines`, ausência de exceção de `overflow`, ação de toque na semântica e navegação com `GoRouter`.
  - Ponto de entrada de pré-visualização (`lib/main_destaques_preview.dart` na cópia) igual ao `main.dart`, mas que, depois do setup, substitui no GetIt o `FetchHighlightsRepository` por um falso cujo cenário vem de `?destaques=0|1|2|3|5|erro|lento|semimagem|falha|branca|longo`. `fvm flutter build web --release -t lib/main_destaques_preview.dart`, servido por Python com fallback de SPA, no navegador embutido em 390, 768 e 1280 px.
  - Nada disso entra no repositório: `git status` na pasta original deve mostrar só os arquivos listados em "Arquivos".
- Build real (`main.dart`) servido localmente, em 390, 768 e 1280 px, com os dados reais: seção presente ou ausente conforme o banco, `scrollWidth` igual à largura, Tab/Enter nos cartões, clique abre o post. Voltar o navegador ao preset desktop e parar os servidores no fim.
