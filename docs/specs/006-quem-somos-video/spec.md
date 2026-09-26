# 006. Home: Quem somos e vídeo

- **Status:** aprovada
- **Item do planejamento:** Fase 1, seções 1.3 (Quem somos) e 1.4 (Vídeo)
- **Protótipo:** aba "Home", blocos "Quem somos" (fundo de superfície, duas colunas) e vídeo (capa com botão "Assistir"), logo abaixo de "Destaques" (link no CLAUDE.md)
- **Criada em:** 2026-09-26
- **Depende de:** [001-fundacao](../001-fundacao/spec.md) (tokens, tipografia, largura máxima), [002-botoes-navbar-rodape](../002-botoes-navbar-rodape/spec.md) (botões, foco), [004-hero-atalhos](../004-hero-atalhos/spec.md) e [005-destaques](../005-destaques/spec.md) (blocos acima, respiro de seção)

## Objetivo
Depois dos destaques, quem visita a Home entende em poucas linhas qual é a missão do Observatório e para quem ele serve (professores, pesquisadores e estudantes), e pode assistir ao vídeo de apresentação quando quiser. Hoje "Quem somos" é um bloco de tela cheia com foto escurecida e um parágrafo longo centralizado, e o vídeo começa a tocar sozinho, sem som, assim que a Home abre.

## Situação atual
- [who_we_are.dart](../../../lib/app/features/home/presentation/components/who_we_are.dart): foto `who-we-are.webp` escurecida ocupando a altura da tela no desktop, título "QUEM SOMOS", um parágrafo de cerca de 110 palavras em branco, centralizado, e o botão "MANIFESTO" (→ `/manifest`). Usa `num_extension`.
- Vídeo, na [home_page.dart](../../../lib/app/features/home/presentation/pages/home_page.dart): `AppVideoPlayer` com `startPlaying: true` e `startMuted: true` (toca sozinho, mudo) e o MP4 do Firebase Storage (`AppStrings.presentationVideoUrl`; 1 min 20 s, 1920 × 1080, cerca de 14 MB). Enquanto carrega, mostra um indicador laranja; se falhar, o bloco some sem aviso. Não há capa, título nem legenda.
- O [AppVideoPlayer](../../../lib/app/core/components/video_player/app_video_player.dart) também é usado no painel administrativo (visualização de mídia), que não pode mudar.

## Comportamento

### Posição
Os dois blocos continuam onde estão: "Quem somos" logo abaixo de "Destaques" (ou do hero, quando não há destaques) e o vídeo logo abaixo de "Quem somos", antes de "Nossa história". Ambos aparecem junto com a página, sem esperar dados do banco.

### Quem somos
Faixa com fundo de superfície (`#F7F5F2`), conteúdo dentro da largura máxima do site, com o respiro vertical de seção. Duas partes:

**Apresentação** (coluna da esquerda no desktop):
1. **Rótulo** (caixa alta, laranja forte): "Quem somos".
2. **Título** (fonte de títulos): "Um espaço para acessar, compartilhar e produzir conhecimento."
3. **Texto** (cinza escuro): "Nossa missão é divulgar saberes relevantes e fazer circular conhecimentos que contribuam para a formação permanente de quem atua no ensino de História, Geografia e áreas afins."
4. **Link** "Conheça o manifesto" com seta, em laranja forte → abre `/manifest` (substitui o botão "MANIFESTO").

**Públicos** (coluna da direita no desktop): três itens em lista, separados por linhas finas (linha acima de cada um e abaixo do último), cada um com ícone num círculo laranja suave, nome e descrição:

| Público | Ícone | Descrição |
|---|---|---|
| Professores | lápis | "Experiências didáticas e materiais para levar à sala de aula." |
| Pesquisadores | frasco de laboratório | "Teses, dissertações e pesquisas de várias instituições, reunidas." |
| Estudantes | capelo de formatura | "Um ponto de partida para aprofundar práticas e saberes educativos." |

Os públicos não são clicáveis (não há página por público). A foto de fundo antiga deixa de aparecer (o arquivo continua no projeto até a limpeza da Fase 7).

### Vídeo
Faixa com fundo branco (cor da página), conteúdo dentro da largura máxima, com o respiro vertical de seção. Um quadro com cantos arredondados mostra a **capa** do vídeo, sem nenhuma reprodução automática:

- **Capa:** se existir a imagem `assets/images/video-capa.webp` (quadro escolhido pela pessoa, seção 5 do planejamento), ela preenche o quadro recortada, sem distorcer. Enquanto ela não existir (situação de hoje) ou se falhar, aparece uma **capa gerada pelo próprio site**: degradê escuro com anéis concêntricos suaves, no mesmo estilo decorativo do hero. Trocar a capa depois é só colocar o arquivo nesse caminho, sem mudar código.
- **Legenda** no canto inferior esquerdo, em branco, fonte de títulos: "Conheça o Observatório". Um véu escuro só na parte de baixo do quadro garante a leitura sobre qualquer capa.
- **Botão** "Assistir", no centro: pílula branca com um círculo laranja e o ícone de reproduzir. Ao passar o mouse, cresce levemente.

**Ao ativar "Assistir"** (clique, toque, Enter ou Espaço):
1. O botão passa a mostrar "Carregando vídeo" com um indicador girando, e a capa continua no lugar.
2. Quando o vídeo fica pronto, a capa dá lugar ao player **no mesmo quadro** (sem mudar a altura da página): o vídeo aparece inteiro, centralizado sobre fundo escuro (faixas escuras nas laterais quando o quadro for mais largo que o vídeo), e começa a tocar **com som**. Os controles de reproduzir/pausar, som e progresso ficam na base do vídeo, sobre um véu escuro que os deixa legíveis sobre qualquer imagem.
3. O foco do teclado vai para o botão "Pausar vídeo".
4. Se o navegador impedir a reprodução automática com som (por exemplo, quando o carregamento demora), o player aparece pausado, pronto, com o botão "Reproduzir vídeo" em evidência; um clique nele começa a tocar.

O vídeo só é baixado depois de "Assistir": abrir a Home não baixa os 14 MB.

## Estados
- **Carregando:** os dois blocos são estáticos e aparecem de imediato. No vídeo, o carregamento só existe depois de "Assistir": botão com "Carregando vídeo" e indicador (parado, com o texto, se o movimento estiver reduzido), sem salto de layout. O leitor de tela ouve "Carregando vídeo".
- **Vazio:** não se aplica (textos fixos; o vídeo tem endereço fixo).
- **Erro:** se o vídeo não carregar, o quadro continua com a capa e, no lugar do botão, uma caixa branca com "Não foi possível carregar o vídeo." e o botão "Tentar de novo", que refaz o carregamento (voltando a "Carregando vídeo"). O bloco nunca some.
- **Sem imagem / imagem com falha:** a capa gerada (degradê com anéis) substitui a imagem ausente ou com falha, sem mudar o tamanho do quadro.
- **Casos de borda:**
  - Capa escolhida muito clara, muito alta ou muito larga: recortada para preencher o quadro; legenda e botão continuam legíveis (véu na base e botão branco com sombra).
  - Vídeo que termina: o player continua no quadro, parado no fim, com "Reproduzir vídeo" para ver de novo.
  - Sair da Home com o vídeo tocando: o vídeo para (não continua tocando em outra página).
  - Texto ampliado pelo navegador até 200%: sem sobreposição da legenda com o botão e sem `overflow` (o quadro cresce na altura se precisar; a legenda quebra em até 2 linhas e termina em reticências).

## Responsivo
- **Celular (390):** margens de 20 px. Quem somos em **uma coluna**: apresentação e depois os públicos, com cerca de 28 px entre eles; título ≈ 27 px. Quadro do vídeo na proporção 16 : 10 (≈ 350 × 219 px), legenda ≈ 18 px.
- **Tablet (768):** margens de 32 px. Quem somos em **uma coluna** (como o protótipo abaixo de 820 px), com cerca de 44 px entre as partes; título ≈ 36 px. Quadro na proporção 16 : 8 (≈ 704 × 352 px), legenda ≈ 24 px.
- **Desktop (1280):** conteúdo limitado a 1120 px. Quem somos em **duas colunas** (apresentação 1 : públicos 1,15) com cerca de 72 px entre elas, alinhadas pelo topo; título ≈ 40 px. Quadro na proporção 16 : 8 limitado a 460 px de altura (≈ 1056 × 460 px), legenda ≈ 26 px.
- Em todas: sem rolagem horizontal e sem aviso de `overflow`.

## Acessibilidade
- O título "Um espaço para acessar, compartilhar e produzir conhecimento." e a legenda "Conheça o Observatório" são anunciados como cabeçalhos.
- "Conheça o manifesto" é um link alcançável por Tab, com contorno de foco padrão (3 px, laranja, afastado 2 px), ativável por Enter e pelo toque do leitor de tela.
- Ícones dos públicos, seta do link, anéis e imagem da capa são decorativos (ignorados pelo leitor de tela). Cada público é lido como "Professores. Experiências didáticas e materiais para levar à sala de aula."
- Botão "Assistir": nome acessível "Reproduzir vídeo de apresentação", alcançável por Tab, contorno de foco visível em volta da pílula, ativável por Enter, Espaço e toque do leitor de tela. Depois de ativado, o foco vai para "Pausar vídeo".
- Controles do player com nome acessível ("Pausar vídeo"/"Reproduzir vídeo", "Silenciar"/"Ativar som") e foco visível.
- Contraste: rótulo e link em laranja forte `#A33600` sobre a superfície (o laranja normal fica em 4,48:1); texto e descrições em cinza escuro `#5E5852` (≥ 6:1); legenda branca ≥ 4,5:1 sobre o véu mesmo com uma capa branca; texto do botão "Assistir" em tinta sobre branco; ícones dos controles do player ≥ 3:1 sobre o véu.
- Movimento reduzido: sem o crescimento do botão no hover e sem transições entre capa, carregamento e player.
- Sem reprodução automática: nada toca nem faz barulho sem a pessoa pedir.

## Dados e regras de negócio
- Textos fixos no código (acima). O parágrafo longo de hoje é resumido no título e no texto de missão, como no protótipo aprovado.
- Vídeo: o mesmo endereço de hoje (`AppStrings.presentationVideoUrl`). Capa: `assets/images/video-capa.webp`, opcional; a pasta `assets/images/` já está declarada no projeto.
- O `AppVideoPlayer` continua funcionando como hoje no painel administrativo (qualquer ajuste nele é opcional e desligado por padrão).
- Nada muda em modelos de dados, coleções, regras do Firebase ou rotas. Destino do link: `/manifest` (já existe).

## Critérios de aceite
1. [ ] Na Home, "Quem somos" aparece logo abaixo de "Destaques" (ou do hero, sem destaques) e o vídeo logo abaixo dele, antes de "Nossa história"; a foto de tela cheia, o parágrafo longo centralizado e o botão "MANIFESTO" não aparecem mais.
2. [ ] "Quem somos" mostra, com os textos exatos desta spec, rótulo, título, texto de missão, link "Conheça o manifesto" e os três públicos com ícone, nome e descrição, sobre o fundo de superfície.
3. [ ] "Conheça o manifesto" abre `/manifest` por clique, Enter e toque do leitor de tela.
4. [ ] Em 1280 px, "Quem somos" fica em duas colunas (1 : 1,15) dentro de 1120 px; em 768 e 390 px, em uma coluna (apresentação e depois públicos).
5. [ ] Ao abrir a Home, o vídeo não toca, não faz som e não é baixado (nenhuma requisição ao MP4 antes de "Assistir"); aparecem a capa, a legenda "Conheça o Observatório" e o botão "Assistir".
6. [ ] Sem o arquivo `assets/images/video-capa.webp` (hoje), a capa gerada (degradê com anéis) aparece sem erro no console; com o arquivo presente, a imagem preenche o quadro recortada.
7. [ ] Ativar "Assistir" mostra "Carregando vídeo" e, quando pronto, o player no mesmo quadro, tocando com som, com o vídeo inteiro centralizado sobre fundo escuro; a altura da página não muda; o foco vai para "Pausar vídeo". Se o navegador bloquear o som automático, o player fica pausado com "Reproduzir vídeo" e um clique começa a tocar.
8. [ ] Com falha no carregamento do vídeo, aparecem "Não foi possível carregar o vídeo." e "Tentar de novo", que refaz o carregamento; o bloco não some.
9. [ ] Sair da Home com o vídeo tocando para o vídeo.
10. [ ] Quadro do vídeo em 16 : 10 no celular (390) e 16 : 8 no tablet (768) e no desktop (1280, limitado a 460 px de altura), com cantos arredondados.
11. [ ] "Conheça o manifesto", "Assistir" e os controles do player são alcançáveis por Tab na ordem visual, com contorno de foco visível e nome acessível; o título de Quem somos e a legenda do vídeo são cabeçalhos; ícones, anéis e capa são ignorados pelo leitor de tela.
12. [ ] Contraste: rótulo e link ≥ 4,5:1 sobre a superfície (laranja forte), texto e descrições ≥ 4,5:1, legenda ≥ 4,5:1 sobre o véu com uma capa branca, ícones dos controles ≥ 3:1 sobre o véu.
13. [ ] Com movimento reduzido, o botão "Assistir" não cresce no hover e não há transições entre capa, carregamento e player.
14. [ ] Em 390, 768 e 1280 px (e com texto a 200%), sem rolagem horizontal, sem sobreposição da legenda com o botão e sem `overflow`; tamanhos conforme "Responsivo".
15. [ ] O `AppVideoPlayer` continua com o mesmo comportamento no painel administrativo (padrões inalterados).
16. [ ] O código novo usa só tokens de `lib/app/theme/` (nenhuma cor, tamanho de fonte ou espaçamento solto) e não usa `num_extension`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Escolher o quadro da capa e gerar `assets/images/video-capa.webp` (decisão da pessoa; seção 5 do planejamento).
- Legendas (closed captions) ou transcrição do vídeo: o arquivo não tem legendas. Registrado como ideia futura.
- Redesenhar os controles do player (barra de progresso operável por teclado, tela cheia, velocidade): continua o controle atual do `AppVideoPlayer`.
- Apagar `who-we-are.webp` e outros arquivos sem uso (Fase 7).
- Redesenho de Nossa história, Equipe, Realização e apoio e Chamada para contato (specs 007 a 009).
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Capa enquanto a escolhida não existe.** Decidido no modo autônomo: capa gerada pelo próprio site com tokens do tema (degradê escuro e anéis concêntricos, como o hero), e `assets/images/video-capa.webp` já previsto e usado automaticamente quando existir, porque a seção 5 do planejamento deixa a escolha do quadro com a pessoa e o protótipo usa uma capa de exemplo sem imagem.
  - **Legenda do vídeo.** Decidido no modo autônomo: "Conheça o Observatório", sem "em 2 minutos", porque o vídeo tem 1 min 20 s e uma duração escrita no texto ficaria errada se o vídeo for trocado.
  - **Proporção do quadro e do vídeo.** Decidido no modo autônomo: manter o quadro do protótipo (16 : 8 até 460 px de altura; 16 : 10 no celular) e, ao tocar, mostrar o vídeo (16 : 9) inteiro dentro do mesmo quadro sobre fundo escuro, porque assim a página não pula ao trocar capa por player e nada do vídeo é cortado.
  - **Som ao tocar.** Decidido no modo autônomo: tocar com som, porque a pessoa pediu para assistir (o autoplay mudo de hoje sai, conforme "sem autoplay" do planejamento); se o navegador bloquear, o player fica pausado pronto para um clique.
  - **Estado de erro do vídeo.** Decidido no modo autônomo: mensagem com "Tentar de novo" sobre a capa, em vez de sumir como hoje, porque o CLAUDE.md exige estado de erro e o padrão "Tentar de novo" já existe (002, 004, 005).
  - **Uso do `AppVideoPlayer`.** Decidido no modo autônomo: reaproveitá-lo, com ajustes só aditivos e desligados por padrão (avisar quando pronto ou com erro, véu atrás dos controles, foco inicial), porque ele também serve ao painel administrativo, que está fora do escopo.
  - **Textos de Quem somos.** Decidido no modo autônomo: os do protótipo aprovado, trocando "Teses, dissertações e artigos" por "Teses, dissertações e pesquisas" na descrição de Pesquisadores, porque a biblioteca só tem Tese e Dissertação (P-10) e "Pesquisa" é um tipo de post real.
  - **Tablet de Quem somos.** Decidido no modo autônomo: uma coluna em 600–1023 px, porque o protótipo só usa duas colunas acima de 820 px de conteúdo e em 768 px a coluna dos públicos ficaria estreita demais para as descrições.
  - **Cor do rótulo e do link.** Decidido no modo autônomo: laranja forte `#A33600`, porque o laranja de acento sobre a superfície dá 4,48:1 (mesma regra da 002 e da 004).
  - **Públicos clicáveis.** Decidido no modo autônomo: não, porque não existe página por público e criar rota está fora do que esta spec pode decidir.

## Histórico de mudanças
- 2026-09-26: criada e aprovada no modo autônomo (execução da Fase 1).
- 2026-09-26: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-09-26: ajustes na implementação (modo autônomo, sem mudar o comportamento descrito acima):
  - **Foco depois de "Assistir".** O foco vai para "Pausar vídeo" só quando "Assistir" foi ativado pelo teclado (estava com o foco). Com clique do mouse, o foco fica onde está: o Flutter trata o mouse como modo de destaque "tradicional" e o contorno de foco apareceria sem a pessoa ter usado o teclado. Por isso o `AppIconButton` ganhou `focusNode` opcional (no lugar do `autofocus` do plano, que não vale quando outro elemento já tem o foco).
  - **Controles do player afastados da borda.** Com o véu ligado, os controles ficam 8 px afastados da borda esquerda e da base, para o contorno de foco não ser cortado pelos cantos arredondados do quadro.
  - **Ativação do usuário em arquivo próprio.** A consulta a `navigator.userActivation` fica em `core/utils/browser/user_activation.dart`, com import condicional (fora da web devolve `true`), para o código continuar compilando fora do navegador.
  - **Correção no `AppVideoPlayer`.** Reproduzir/pausar agora muda o estado interno antes de chamar o controller (que avisa os ouvintes ainda dentro de `play()`); sem os parâmetros novos, o comportamento é o mesmo de antes.
