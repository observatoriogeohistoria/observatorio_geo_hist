# 009. Home: realização e apoio, chamada para contato

- **Status:** aprovada
- **Item do planejamento:** Fase 1, seções 1.7 (Realização e apoio, P-03, Q-06) e 1.8 (Chamada para contato). Última spec da Fase 1: inclui a conferência da Home inteira contra o aceite da fase.
- **Protótipo:** aba "Home", blocos "Realização e apoio" (`.logos`) e chamada final (`.cta`), abaixo da Equipe; aba "Post", bloco "Apoio" (`.logos.small`) como referência da lista compartilhada (link no CLAUDE.md)
- **Criada em:** 2026-09-27
- **Depende de:** [001-fundacao](../001-fundacao/spec.md) (tokens, largura máxima), [002-botoes-navbar-rodape](../002-botoes-navbar-rodape/spec.md) (botões, foco), [004-hero-atalhos](../004-hero-atalhos/spec.md) (botão com ícone à direita), [008-equipe](../008-equipe/spec.md) (bloco acima)

## Objetivo
No fim da Home, quem visita reconhece as instituições que realizam e apoiam o Observatório, pelos logos reais, e encontra um convite claro para falar com a equipe. Hoje os logos ficam em cartões antigos sob "PARCEIROS" e a chamada é um bloco cinza com texto branco.

## Situação atual
- [partners.dart](../../../lib/app/features/home/presentation/components/partners.dart) (`Partners`): título "PARCEIROS" em laranja, os 9 logos de `assets/images/partners` em cartões (`AppCard`), 2 ou 3 colunas, sem link, sem hover e sem nome acessível. Usa `num_extension`. Aparece na Home, na Biblioteca (`/biblioteca`) e em Colabore (`/colaborar`).
- [support.dart](../../../lib/app/core/components/support/support.dart) (`Support`): no fim de cada post, redes sociais, título "APOIO" e só 4 logos (UFU, FAPEMIG, CNPq, CAPES). O redesenho do post é de fase posterior (P-07).
- [partners_images.dart](../../../lib/app/core/utils/enums/partners_images.dart): lista dos 9 arquivos de logo (todos 280 × 186 px), sem nome completo nem site.
- [contact_us.dart](../../../lib/app/features/home/presentation/components/contact_us.dart) (`ContactUs`): fundo cinza, texto branco centralizado e botão "FALE COM A GENTE" para `/contato`. Usa `num_extension`. Só a Home usa.
- Na Home, os dois blocos têm um comentário "redesenho na spec 009". Sem membros na equipe, Nossa história encosta direto em Parceiros (verificação da 008).

## Comportamento

### Realização e apoio
Logo abaixo da Equipe, fundo branco, conteúdo na largura máxima do site. Título "Realização e apoio" no estilo de título de seção (o mesmo de "Destaques" e "Equipe"), com o mesmo espaço até os logos.

**Logos.** Os 9 logos reais, nesta ordem (a do protótipo): UFU, FAPEMIG, CNPq, CAPES, FACED, PPGED, PROEXC, PROPP, UNIUBE. Grade de colunas iguais, cada coluna com no mínimo 150 px, quantas couberem (6 em 1280 px, 4 em 768 px, 2 em 390 px), 12 px entre logos, alinhada à esquerda. Cada logo fica numa área de respiro de 12 px com cantos arredondados (14 px), centralizado, na proporção do arquivo, com no máximo 150 px de largura.

**Repouso:** logos em escala de cinza e opacidade reduzida (55 %), sem borda nem fundo.

**Hover e foco por teclado** (mesmo efeito): o logo ganha cor e opacidade total e cresce 5 %; a área sobe 3 px e ganha fundo branco, borda fina e sombra suave. Transição curta (cerca de 0,2 s).

**Link.** Cada logo é um link para o site oficial da instituição, aberto em outra aba:

| Logo | Nome completo (nome acessível) | Site |
|---|---|---|
| UFU | Universidade Federal de Uberlândia | https://ufu.br |
| FAPEMIG | Fundação de Amparo à Pesquisa do Estado de Minas Gerais | https://fapemig.br |
| CNPq | Conselho Nacional de Desenvolvimento Científico e Tecnológico | https://www.gov.br/cnpq |
| CAPES | Coordenação de Aperfeiçoamento de Pessoal de Nível Superior | https://www.gov.br/capes |
| FACED | Faculdade de Educação da UFU | https://faced.ufu.br |
| PPGED | Programa de Pós-Graduação em Educação da UFU | https://ppged.faced.ufu.br |
| PROEXC | Pró-Reitoria de Extensão e Cultura da UFU | https://proexc.ufu.br |
| PROPP | Pró-Reitoria de Pesquisa e Pós-Graduação da UFU | https://propp.ufu.br |
| UNIUBE | Universidade de Uberaba | https://uniube.br |

Um site que não abrir na conferência da implementação fica sem link (o logo aparece igual, com o efeito de hover, mas sem cursor de mão, sem foco e sem clique), como prevê o P-03, e isso é registrado.

### A mesma lista em todo o site (Q-06)
A lista acima (logos, ordem, nomes e links) é única no site:
- **Biblioteca e Colabore**, que já mostram os parceiros, passam a mostrar este mesmo bloco novo ("Realização e apoio"), no lugar do antigo "PARCEIROS".
- **Post:** o bloco "Apoio" do fim do post continua como está (fundo, redes sociais, título "APOIO"), mas a grade de 4 cartões dá lugar aos mesmos 9 logos, com o mesmo efeito e os mesmos links, em colunas de no mínimo 130 px (variante menor do protótipo). O restante do redesenho do post (P-07) fica para a fase dele.

### Chamada para contato
Depois de Realização e apoio e antes do rodapé, na largura máxima do site. Um quadro em laranja suave com cantos arredondados (20 px) e respiro interno de 28 px (celular), cerca de 46 px (tablet) e 56 px (desktop), com:
- **Título:** "Feito por e para professores, pesquisadores e estudantes." (fonte de títulos, cerca de 24, 32 e 35 px; largura máxima de cerca de 22 caracteres).
- **Texto:** "Envie suas contribuições, opiniões e sugestões e ajude a construir este espaço." (texto secundário, largura máxima de cerca de 52 caracteres), 8 px abaixo do título.
- **Botão primário** "Fale com a gente" com seta à direita, que abre `/contato`.

No desktop, textos à esquerda e botão à direita, centralizados na vertical, com pelo menos 24 px entre eles. No celular e no tablet, o botão fica abaixo do texto, alinhado à esquerda, 24 px abaixo.

O bloco cinza antigo com "FALE COM A GENTE" sai.

### Espaços entre os blocos finais
Como no protótipo, Realização e apoio e a chamada não somam um segundo respiro entre si e o bloco anterior: entre o último membro da Equipe e o título "Realização e apoio" fica um único respiro de seção (48, 72 e 96 px), o mesmo entre os logos e o quadro da chamada, e entre o quadro e o rodapé. Sem membros na equipe (seção escondida), Realização e apoio mantém esse respiro acima do título, sem encostar em Nossa história.

### Home inteira (aceite da Fase 1)
Com este bloco a Home fica completa, na ordem do protótipo: navbar, hero com atalhos, Destaques, Quem somos (fundo superfície), Vídeo, Nossa história (fundo superfície), Equipe, Realização e apoio, chamada para contato e rodapé. As transições de fundo (branco → superfície → branco) acontecem sem linha solta nem vão duplicado.

## Estados
- **Carregando:** não há. Logos e textos são fixos no site e aparecem com o bloco (o bloco em si é carregado de forma adiada, como hoje, sem esqueleto).
- **Vazio:** não se aplica (a lista é fixa, com 9 itens).
- **Erro:** não há busca de dados.
- **Imagem com falha:** se um arquivo de logo não carregar, a área mostra a sigla da instituição em texto secundário, do mesmo tamanho de área, sem deslocar a grade.
- **Casos de borda:**
  - Última linha incompleta (ex.: 6 + 3 em 1280 px): logos da última linha alinhados à esquerda, com a mesma largura das colunas de cima.
  - Texto ampliado a 200 %: título e textos da chamada quebram linha sem cortar palavra; o botão pode ir para baixo do texto também no desktop.
  - Aparelho sem mouse: os logos ficam em cinza (sem hover) e abrem o site pelo toque.

## Responsivo
- **Celular (390):** margens de 20 px. Logos em 2 colunas. Chamada com título ≈ 24 px, respiro interno de 28 px e botão abaixo do texto.
- **Tablet (768):** margens de 32 px. Logos em 4 colunas. Chamada com título ≈ 32 px, respiro ≈ 46 px e botão abaixo do texto.
- **Desktop (1280):** conteúdo limitado a 1120 px. Logos em 6 colunas (6 + 3). Chamada com título ≈ 35 px, respiro de 56 px e botão à direita.
- Em todas: sem rolagem horizontal e sem aviso de `overflow`, também em `/biblioteca`, `/colaborar` e num post.

## Acessibilidade
- "Realização e apoio" e o título da chamada são anunciados como cabeçalhos.
- Cada logo com link é um único link com o nome completo da instituição (tabela acima), alcançável por Tab na ordem da grade, com o contorno de foco padrão (3 px, laranja, afastado 2 px) e o mesmo efeito do hover; Enter e o toque do leitor de tela abrem o site.
- Logo sem link (site que não abriu): lido como imagem com o nome completo, fora da ordem de Tab.
- Área de toque de cada logo com pelo menos 44 px de altura.
- Logos são marcas: em repouso ficam em cinza com opacidade reduzida, como no protótipo; o nome da instituição chega ao leitor de tela pelo nome acessível. Texto da chamada: `#5E5852` sobre `#FFF0E6` (≈ 6,3:1); título em tinta (≥ 13:1); botão branco sobre `#C94400` (4,9:1).
- Movimento reduzido: sem subir nem crescer; a troca de cor e o fundo continuam.

## Dados e regras de negócio
- Nenhum dado do Firebase. A lista de parceiros (arquivo, sigla, nome completo e site) fica no próprio site; nenhum arquivo de logo novo.
- `/contato` e a página Fale com a gente não mudam. Nenhuma rota nova nem alterada.
- Modelos, coleções, regras do Firebase e painel admin não mudam.

## Critérios de aceite
1. [ ] Na Home, depois da Equipe e antes do rodapé, aparecem Realização e apoio e a chamada para contato, nesta ordem; "PARCEIROS" com cartões e o bloco cinza "FALE COM A GENTE" não aparecem mais.
2. [ ] Realização e apoio: título "Realização e apoio" como cabeçalho de seção e os 9 logos reais na ordem UFU, FAPEMIG, CNPq, CAPES, FACED, PPGED, PROEXC, PROPP, UNIUBE.
3. [ ] Grade de logos com colunas iguais de no mínimo 150 px: 6 colunas em 1280 px, 4 em 768 px e 2 em 390 px, 12 px entre logos, última linha alinhada à esquerda; logos sem distorção, no máximo 150 px de largura.
4. [ ] Em repouso, logos em cinza com opacidade de 55 %; no hover e no foco por teclado, ganham cor e opacidade total, crescem 5 %, e a área sobe 3 px com fundo branco, borda e sombra.
5. [ ] Cada logo abre o site oficial da tabela em outra aba, por clique, Enter e toque do leitor de tela, com cursor de mão; um site que não abriu na conferência fica sem link e isso está registrado.
6. [ ] Logo com falha de carregamento mostra a sigla no lugar, sem deslocar a grade.
7. [ ] Biblioteca (`/biblioteca`) e Colabore (`/colaborar`) mostram o mesmo bloco Realização e apoio (mesma lista, ordem, efeito e links), sem `overflow` em 390, 768 e 1280 px.
8. [ ] No post, o bloco "Apoio" mantém redes sociais, título e fundo, e mostra os mesmos 9 logos (colunas de no mínimo 130 px) com o mesmo efeito e links; o restante do post não muda.
9. [ ] Chamada: quadro laranja suave com cantos de 20 px, título "Feito por e para professores, pesquisadores e estudantes.", texto "Envie suas contribuições, opiniões e sugestões e ajude a construir este espaço." e botão primário "Fale com a gente" com seta, que abre `/contato`.
10. [ ] Chamada no desktop com o botão à direita dos textos, centralizado na vertical; no tablet e no celular, botão abaixo do texto, alinhado à esquerda; respiro interno de 28, ≈ 46 e 56 px e título ≈ 24, 32 e 35 px (390, 768, 1280).
11. [ ] Espaços: um único respiro de seção entre a Equipe e "Realização e apoio", entre os logos e o quadro da chamada e entre o quadro e o rodapé; com a equipe escondida (0 membros), Realização e apoio não encosta em Nossa história.
12. [ ] Acessibilidade: logos com link são links com o nome completo, com contorno de foco visível na ordem da grade e área de toque ≥ 44 px; títulos anunciados como cabeçalhos; com movimento reduzido, sem subir nem crescer.
13. [ ] Contraste: título e texto da chamada ≥ 4,5:1 sobre o laranja suave; texto do botão ≥ 4,5:1.
14. [ ] Com texto a 200 %, títulos e textos quebram sem partir palavras e sem `overflow`.
15. [ ] Home inteira em 390, 768 e 1280 px: ordem das seções igual à do protótipo (navbar, hero, Destaques, Quem somos, Vídeo, Nossa história, Equipe, Realização e apoio, chamada, rodapé), transições de fundo sem linha solta nem vão duplicado, sem rolagem horizontal e console sem `overflow`.
16. [ ] Estados da Home tratados no app rodando: Destaques e Equipe com esqueleto ao carregar e com mensagem e "Tentar de novo" no erro (como nas specs 005 e 008), sem regressão.
17. [ ] `/contato`, as rotas e o painel admin não mudam.
18. [ ] O código novo usa só tokens de `lib/app/theme/` (nenhuma cor, tamanho de fonte ou espaçamento solto) e não usa `num_extension`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Redesenho do bloco "Apoio" do post (redes sociais em pílulas, "Acompanhe", duas colunas do protótipo) e do post em geral: fase do post (P-07, P-08).
- Redesenho da Biblioteca e de Colabore (Fases 4 e 5): só o bloco de parceiros muda nelas.
- Página Fale com a gente (validação e tela de confirmação): Fase 5.
- Link "Ver todas as publicações" dos Destaques (decisão da 005) e rolagem do link "Equipe" do rodapé até o bloco (008).
- Logos novos ou trocados, logos em SVG.
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Parceiros no post (Q-06 sem regredir o post).** Decidido no modo autônomo: o bloco "Apoio" do post fica como está e só troca os 4 cartões pelos 9 logos compartilhados (variante menor), porque a Q-06 já está decidida, a troca só acrescenta logos e o redesenho do bloco (P-07) é da fase do post.
  - **Biblioteca e Colabore.** Decidido no modo autônomo: mostram o bloco novo, porque já usam o mesmo componente de parceiros e o princípio 1 do planejamento diz que componentes compartilhados mudam todas as páginas de uma vez.
  - **Links dos logos.** Decidido no modo autônomo: cada logo aponta para o site oficial da instituição, porque o protótipo mostra todos os logos como links e o P-03 prevê logo clicável com foco; hoje não há links, então os endereços públicos são conferidos na implementação e o que não abrir fica sem link.
  - **Nome acessível.** Decidido no modo autônomo: o nome completo da instituição, porque a sigla sozinha ("PROPP", "FACED") não diz nada a quem usa leitor de tela.
  - **Ordem dos logos.** Decidido no modo autônomo: a do protótipo (UFU, FAPEMIG, CNPq, CAPES, depois as unidades da UFU e a UNIUBE), porque é a referência visual e põe primeiro quem realiza e financia.
  - **Quanto o logo sobe.** Decidido no modo autônomo: 3 px, como no protótipo (o P-03 falava em 2 px como proposta; o protótipo v5, posterior, usa 3 px).
  - **Cinza com opacidade de 55 %.** Decidido no modo autônomo: mantido como no protótipo e no P-03, porque logotipos são exceção de contraste e o nome chega pelo nome acessível; registrado como risco para aparelhos sem mouse, que não veem a cor.
  - **Título da seção.** Decidido no modo autônomo: "Realização e apoio", como no protótipo e no planejamento, também na Biblioteca e em Colabore.
  - **Textos da chamada.** Decidido no modo autônomo: os do protótipo, que resumem o texto atual ("criado por e para professores, pesquisadores e estudantes... Envie suas contribuições, opiniões e sugestões") sem mudar o sentido.
  - **Espaço entre Nossa história e Realização e apoio sem equipe.** Decidido no modo autônomo: o respiro de seção fica acima de Realização e apoio (em vez de abaixo da Equipe), porque assim o espaço é o mesmo do protótipo com a equipe e não some quando ela está escondida, o problema visto na verificação da 008.

## Histórico de mudanças
- 2026-09-27: criada e aprovada no modo autônomo (execução da Fase 1).
- 2026-09-27: plano e tarefas criados (`plan.md`, `tasks.md`).
