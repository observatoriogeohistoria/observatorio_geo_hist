# Tarefas da 001. Fundação visual (tokens, fontes e breakpoints)

Legenda: `- [ ]` a fazer, `- [x]` feita.

Cada tarefa termina com `fvm flutter analyze` limpo. Nenhuma altera valores antigos do tema.

## Grupo A: Fontes embutidas (0.2)
- [x] **A1.** Baixar Bricolage Grotesque e Figtree do repositório `google/fonts` (com os `OFL.txt`) para a pasta temporária e gerar instâncias estáticas com `fonttools varLib.instancer`: Bricolage 600, 700, 800 (`wdth=100`, `opsz` a definir olhando o protótipo) e Figtree 400, 500, 600, 700. Arquivos: `assets/fonts/BricolageGrotesque-{SemiBold,Bold,ExtraBold}.ttf`, `assets/fonts/Figtree-{Regular,Medium,SemiBold,Bold}.ttf`. Conferir: 7 arquivos, cada um com o peso certo (`fc-scan` ou `ttx` mostrando `wght`) e com os caracteres acentuados do português. Atende: critério 5.
  - *Feito:* `opsz` fixado em 36 (meio dos títulos de 20 a 52 px; o protótipo usa `opsz` automático, que o Flutter não faz). Cada arquivo tem cerca de 89 KB (Bricolage) e 39 KB (Figtree).
- [x] **A2.** Copiar as licenças OFL para `assets/fonts/licenses/OFL-BricolageGrotesque.txt` e `OFL-Figtree.txt`. Conferir: arquivos presentes e com o nome do autor da fonte no cabeçalho. Atende: critério 11.
- [x] **A3.** Declarar as duas famílias em `pubspec.yaml` (`BricolageGrotesque` com 600/700/800; `Figtree` com 400/500/600/700), sem mexer no bloco da Dosis. Rodar `fvm flutter pub get`. Conferir: `git diff pubspec.yaml` só acrescenta linhas; app abre igual. Atende: critérios 1 e 5.
  - *Nota:* `fvm flutter analyze` trava na pasta original (o servidor de análise se perde com o "ó" de "Observatório" no caminho). A análise foi feita numa cópia em caminho ASCII: sem problemas.

## Grupo B: Cores (0.1)
- [x] **B1.** Acrescentar em `AppColors` as 14 cores da tabela da spec com nomes por função (`page`, `surface`, `ink`, `inkSecondary`, `line`, `accent`, `accentStrong`, `accentSoft`, `footerBackground`, `footerLine`, `footerText`, `footerHighlight`, `error`, `success`, `successSurface`), como `const Color`. Arquivo: `lib/app/theme/app_colors/app_colors.dart`. Conferir: cada valor hexadecimal bate com a tabela (releitura linha a linha) e os campos antigos não mudaram no `git diff`. Atende: critérios 1, 3 e 2.
  - *Feito:* 15 cores (a tarefa dizia 14, mas lista 15 nomes; todas da tabela). Valores conferidos linha a linha. Campos antigos intactos (diff só com adições).

## Grupo C: Espaçamento, raios, sombras e foco (0.1)
- [x] **C1.** Em `AppDimensions`, acrescentar `spacing` (4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 96), `radii` (6, 8, 10, 12, 14, 16, 18, 20 e `pill`), `shadows` (`soft` e `elevated`, com valores lidos do protótipo) e `focus` (largura 3, afastamento 2, cor de acento). Nomes distintos de `space`/`radius`/`stroke`. Arquivo: `lib/app/theme/app_dimensions/app_dimensions.dart`. Conferir: todos os passos da spec existem; nenhum valor antigo mudou. Atende: critério 4.
  - *Feito:* `spacing` (`s4`…`s96`), `radii` (`r6`…`r20`, `pill`), `shadows.soft/elevated` e `focus`. Sombras a partir do CSS do protótipo (`0 10px 26px` a 8% e `0 14px 36px` a 14% de `#1F1B18`), como aproximação dos usos em cartões e menus.

## Grupo D: Tipografia nova (0.2)
- [x] **D1.** Abrir a aba "Fundamentos" do protótipo e anotar, para cada um dos 7 estilos, altura de linha e espaçamento entre letras (a spec só fixa família, peso e tamanho). Registrar os valores como comentário no topo de `app_text_styles.dart` (criado em D2). Conferir: tabela com 7 linhas preenchida. Atende: critério 6 (base para a comparação).
  - *Feito:* tabela de 7 linhas no topo de `app_text_styles.dart`, lida do CSS do protótipo (h3 usa peso 700; o protótipo mistura 650 e 700 e a fonte estática só tem 600/700/800).
- [x] **D2.** Criar `AppTextStyles` (como `part` do tema) com h1, h2, h3, leitura, padrão, pequeno e rótulo, escolhendo o tamanho pela faixa (função pura recebendo a largura) e usando `fontFamily` das novas famílias, com `fontFamilyFallback` de sistema. Títulos em Bricolage (h1, h2, h3), o resto em Figtree. Sem `google_fonts` nem `num_extension`. Arquivos: `lib/app/theme/app_typography/app_text_styles.dart`, `app_theme.dart` (nova `part`). Conferir: tamanhos batem com a tabela da spec, incluindo rótulo 12,5 / 12,5 / 13. Atende: critério 7.
  - *Feito:* tamanhos conferidos com a tabela da spec. Sem `google_fonts` nem `num_extension` no arquivo.
- [x] **D3.** Expor `AppTheme.typography.of(context)` devolvendo `AppTextStyles`. Arquivo: `lib/app/theme/app_typography/app_typography.dart`. Conferir: os getters antigos (`headline`, `title`, `body`, `label`) seguem iguais no `git diff`. Atende: critérios 2 e 7.

## Grupo E: Breakpoints e largura de conteúdo (0.3)
- [x] **E1.** Em `screen_utils.dart`, acrescentar `enum Breakpoint { mobile, tablet, desktop }`, `Breakpoint.fromWidth(double)` (< 600, 600–1023, ≥ 1024), `ScreenUtils.breakpointOf(context)`, constantes `contentMaxWidth = 1120` e `contentMargin(Breakpoint)` (20 no celular, 32 do tablet para cima). Não alterar métodos existentes. Conferir: `Breakpoint.fromWidth` retorna o esperado em 390, 599, 600, 768, 1023, 1024 e 1280 (conferido na tela de teste, tarefa F1). Atende: critérios 8 e 9.
  - *Feito fora de ordem:* antes de D2, porque `AppTextStyles` escolhe o tamanho por `Breakpoint`. Conferência nas 7 larguras fica para a tela de teste (F1).
- [x] **E2.** Criar `PageContent` (centraliza, limita a 1120 px e aplica a margem por faixa). Arquivo: `lib/app/core/components/page_content/page_content.dart`. Conferir: acima de 1120 px o conteúdo fica centralizado e as margens crescem; abaixo, ocupa a largura menos as margens. Atende: critério 9.

## Grupo F: Verificação e limpeza
- [x] **F1.** Criar a tela de teste temporária com: cada estilo de texto (nome e tamanho), amostras das cores da tabela, faixa atual e larguras, dentro de `PageContent`. Rota provisória em `app_router.dart`. Arquivos: `lib/app/dev/foundation_preview_page.dart`, `lib/app/router/app_router.dart`. Conferir: em 390, 768 e 1280 px os tamanhos batem com a tabela, sem rolagem horizontal nem `overflow`, e os pesos 400/500/600/700 e 600/700/800 são visivelmente distintos. Atende: critérios 6, 7, 8 e 9.
- [x] **F2.** Teste offline: com o cache desativado e a rede offline no DevTools, recarregar a tela de teste. Conferir: as duas fontes renderizam e nenhuma requisição vai a `fonts.gstatic.com` a partir dos estilos novos. Atende: critério 5.
  - *Feito:* conferido pela pessoa no Chrome (offline, sem cache).
- [x] **F3.** Script de contraste na pasta temporária (fora do projeto) calculando a razão WCAG dos pares da spec: principal, secundário e acento sobre `#FFFFFF`; secundário e acento sobre `#F7F5F2`; rodapé texto e destaque sobre `#1C1917`; erro sobre branco; sucesso sobre `#E4F3E8`. Conferir: todos ≥ 4,5:1. Se algum falhar, propor ajuste e registrar na spec (Histórico de mudanças) antes de alterar a cor. Guardar os valores para o `verificacao.md`. Atende: critério 10.
  - *Feito:* razões (script na pasta temporária): principal/branco 17,10; secundário/branco 7,01; acento/branco 4,87; secundário/superfície 6,45; **acento/superfície 4,48 (falha)**; rodapé texto 11,65; rodapé destaque 8,37; erro 6,54; sucesso 5,71; branco/acento 4,87; branco/acento forte 6,81; **acento/acento suave 4,38 (falha)**; acento forte/acento suave 6,11. Decisão: manter o acento e usar o acento forte nesses fundos (spec atualizada).
- [x] **F4.** Regressão nas telas antigas: abrir home, lista e detalhe de post, biblioteca, contato, manifesto e painel admin (login e uma aba) em 390, 768 e 1280 px e comparar com a `main` (fonte Dosis, cores e espaçamentos idênticos). Conferir também que `git diff` não altera valores antigos de tema nem de `ScreenUtils`. Atende: critério 2.
  - *Feito:* conferido pela pessoa; telas antigas e painel idênticos.
- [x] **F5.** Remover a tela de teste e a rota provisória. Rodar `fvm flutter analyze` e `git status`. Conferir: nenhum arquivo de `lib/app/dev/` nem trecho de rota provisória no diff; analyze sem novos avisos. Atende: critérios 1 e 6 (tela temporária, não commitada).
  - *Feito:* `lib/app/dev/` e a rota provisória removidos.

## Cobertura dos critérios de aceite
| # | Critério | Tarefas |
|---|---|---|
| 1 | Compila, `analyze` sem novos avisos | A3, B1, F5 |
| 2 | Telas atuais e painel idênticos | B1, D3, F4 |
| 3 | Cores da tabela no tema | B1 |
| 4 | Espaçamentos, raios, sombras e foco no tema | C1 |
| 5 | Fontes em `assets/fonts`, declaradas, offline | A1, A3, F2 |
| 6 | Tela de teste temporária, não commitada | D1, F1, F5 |
| 7 | Estilos novos sem `google_fonts`/`num_extension` | D2, D3, F1 |
| 8 | Faixas corretas nas 7 larguras | E1, F1 |
| 9 | Largura máxima 1120 e margens 20/32 | E1, E2, F1 |
| 10 | Contraste ≥ 4,5:1 | F3 |
| 11 | Licenças OFL no repositório | A2 |
