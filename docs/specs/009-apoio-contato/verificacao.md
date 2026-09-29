# Verificação da 009. Home: realização e apoio, chamada para contato

- **Data:** 2026-09-29
- **Resultado:** aprovada com ressalvas (uma correção feita; duas ressalvas pré-existentes e fora do escopo)

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | lib sem problemas (avisos só no teste temporário) |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro, antes e depois da correção |
| Build de pré-visualização com destaques e equipe falsos (`?home=cheio\|vazio\|lento\|erro`), só no scratchpad | Home em 390, 768 e 1280 px; `scrollWidth` igual à largura |
| Build do app real (Firebase de testes) | Home, `/biblioteca`, `/colaborar` e post (`/posts/historia/teste/abc`, que mostra o `Support` abaixo do carregando) em 390, 768 e 1280 px |
| Teste de widget temporário, só no scratchpad (18 testes) | todos passaram, também depois da correção |

Todas as tarefas do [tasks.md](tasks.md) estão marcadas. Revisão feita no código de `55f623d..5d15542` (`acccc73` e `5d15542`), não só no relatório da implementação. Nada de teste ou pré-visualização entrou no repositório.

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Realização e apoio e chamada depois da Equipe; blocos antigos fora | passou | `home_page.dart`; `partners.dart` e `contact_us.dart` apagados; tela nos três tamanhos |
| 2 | Título como cabeçalho e 9 logos na ordem | passou | Semântica: `h2` "Realização e apoio" e links na ordem UFU → UNIUBE; enum `Partner` |
| 3 | Grade 6/4/2, 12 px, última linha à esquerda, logo ≤ 150 px | passou | DOM de semântica: 166 px com vão de 12 (1280), 167 px (768), 2 colunas (390); teste de widget |
| 4 | Repouso cinza a 55 %; hover/foco com cor, escala, subida, fundo, borda e sombra | passou | Hover na tela (768 px, com WebGL); foco por Tab no teste de widget |
| 5 | Abre o site em outra aba por clique, Enter e toque do leitor | passou | Clique em `/biblioteca`: `window.open('https://www.gov.br/capes', '', 'noopener,noreferrer')`; Enter e ação semântica no teste de widget. Os 9 sites têm link |
| 6 | Falha do logo mostra a sigla sem deslocar a grade | passou | Teste de widget com `AssetBundle` que falha: "UFU" com a mesma altura |
| 7 | Biblioteca e Colabore com o mesmo bloco, sem `overflow` | passou | App real em 390, 768 e 1280 px; `scrollWidth` igual à largura. Ver ressalva de Colabore |
| 8 | Post: Apoio com redes, título e fundo, 9 logos de ≥ 130 px | passou | App real, post inexistente: redes, "APOIO" e 9 logos (2 colunas a 390); `git diff` do `support.dart` só na grade |
| 9 | Quadro laranja suave, raio 20, textos e botão com seta para `/contato` | passou | Tela; teste de widget navega para `/contato` |
| 10 | Botão ao lado no desktop, abaixo no tablet/celular; respiros e títulos | passou | Semântica: título a 56 px da borda (1280) e a 46 px (768); botão abaixo a 768 e 390; teste de widget |
| 11 | Um só respiro entre Equipe, logos, chamada e rodapé; sem equipe não encosta | passou | Medido: ≈ 96/72/48 px nos três vãos; `?home=vazio` mantém o respiro acima do título |
| 12 | Links com nome completo, foco na ordem, toque ≥ 44 px, cabeçalhos, movimento reduzido | passou | Após a correção abaixo; teste de widget (Tab, altura ≥ 44, `disableAnimations` sem escala nem subida) |
| 13 | Contraste da chamada e do botão | passou | Tokens `ink`, `inkSecondary` (6,3:1) sobre `accentSoft`; botão branco sobre `accent` (4,9:1) |
| 14 | Texto a 200 % sem cortar e sem `overflow` | passou | Teste de widget a 200 % em 390/768/1280 (chamada empilhada e seção de logos) |
| 15 | Home inteira: ordem, fundos, sem rolagem horizontal, sem `overflow` | passou | Ver "Aceite da Fase 1" |
| 16 | Esqueleto e erro com "Tentar de novo" em Destaques e Equipe | passou | `?home=lento` e `?home=erro` a 1280 px |
| 17 | `/contato`, rotas e painel sem mudança | passou | `git diff` sem mudança em `app_router.dart`, `contact_us_page.dart` e `features/admin`; só a constante `AppRoutes.contact` |
| 18 | Só tokens, sem `num_extension`; analyze e build | passou | Diff: números soltos só na matriz de cinza; sem `num_extension` nos arquivos novos |

## Correção
- **Nome acessível dos logos sem aviso de nova aba** (ajuste, corrigido em `08caca7`). Os logos eram lidos só com o nome da instituição, enquanto as redes sociais e os links externos da navbar terminam em ", abre em outra aba". Agora: "Universidade Federal de Uberlândia, abre em outra aba" etc. Conferido na árvore de semântica de `/biblioteca` e no teste de widget.

## Problemas encontrados
- **Faixa lilás embaixo de `/colaborar`** (detalhe, pré-existente, fora do escopo). O `Scaffold` da página não tem cor de fundo; com a janela mais alta que o conteúdo, o `SliverFillRemaining` aparece com a cor padrão do Material abaixo do bloco branco. Não aparece em 390, 768 e 1280 px de largura com altura comum. Fica para o redesenho de Colabore (Fase 5).
- **Links de semântica sem `href`** (detalhe, pré-existente). O padrão do site é `Semantics(link: true)` sem `linkUrl`; o `<a>` gerado não tem `href`. Vale para o site inteiro e não foi mudado aqui.
- **Logos aparecem um instante depois do resto** no primeiro carregamento (asset). A área já tem a proporção reservada, sem deslocar a grade; a spec não prevê esqueleto.

## Aceite da Fase 1
Home conferida com dados simulados (3 destaques, 7 membros) e com o Firebase de testes em 390, 768 e 1280 px: ordem igual à do protótipo (navbar, hero com atalhos, Destaques, Quem somos, Vídeo, Nossa história, Equipe, Realização e apoio, chamada, rodapé); fundos branco → superfície → branco sem linha solta nem vão duplo; respiros de seção de 96/72/48 px; `scrollWidth` igual à largura; esqueleto, erro com "Tentar de novo" e vazio tratados. **Aprovado.** O `overflow` foi conferido pelos testes de widget (o build release não imprime esse aviso no console).

## Não conferido
- Contorno de foco no navegador embutido (a largura emulada desloca as coordenadas); conferido por teste de widget e pelo uso de `AppFocusRing`.
- Post com conteúdo real (o Firebase de testes não tem posts); o `Support` foi visto abaixo do carregando de um post inexistente.
- Painel admin: não se aplica (sem mudança no `git diff`).
