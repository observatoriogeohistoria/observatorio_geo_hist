# 020. Estados especiais

- **Status:** aprovada
- **Item do planejamento:** Fase 5, tela T-10 (`PageNotFound`, erro e vazio)
- **Protótipo:** aba "Estados" (link no CLAUDE.md)
- **Criada em:** 2026-10-05
- **Depende de:** [011-nossa-historia-pessoa](../011-nossa-historia-pessoa/spec.md) (caixa de erro), [014-listagem-categoria](../014-listagem-categoria/spec.md) (caixa de estado e esqueletos de cartão), [005-destaques](../005-destaques/spec.md) e [008-equipe](../008-equipe/spec.md) (erro discreto nas seções da Home)

## Objetivo
Quem cai num endereço que não existe vê uma página 404 no desenho novo, com caminhos de volta, e todas as telas públicas mostram carregando, vazio e erro do mesmo jeito. As specs 021 e 022 (demais tipos de post) usam esses mesmos estados.

## Situação atual
- **404** ([page_not_found.dart](../../../lib/app/router/page_not_found.dart)): desenho antigo. "404" e "Página não encontrada" em cinza claro (contraste baixo), botão "HOME" em caixa alta, tamanhos por `num_extension`. Aparece em endereço desconhecido, área ou categoria inválida, post, documento ou membro inexistente e membro sem descrição.
- **Erro e vazio** já no desenho novo: caixa de estado (ícone em círculo, título, texto, ação) nas listagens de posts e da biblioteca, no post, na pessoa da equipe, no documento e no visualizador de PDF. Erro sempre com "Não foi possível carregar", "Verifique sua conexão e tente novamente." e "Tentar de novo".
- **Home:** Destaques e Equipe têm cada um a sua própria faixa de erro ("Não foi possível carregar os destaques." / "… a equipe." com "Tentar de novo"), copiada nos dois arquivos.
- **Esqueletos** em todas as telas novas (Home, post, categoria, todas as publicações, biblioteca, pessoa, menu de categorias). A peça base é um bloco com degradê fixo de cores escritas no código, **sem o brilho que corre** do protótipo.
- **Sobras do desenho antigo, sem uso:** componentes de vazio ("Hmmm, parece que não há nada por aqui") e de erro de página ("Erro ao carregar a página"), que ninguém usa mais.

## Comportamento

### Página 404
Navbar, conteúdo e rodapé (na base da janela, a página é curta). Nenhum item da navbar fica marcado.

No conteúdo, dentro da largura máxima, uma caixa no desenho dos outros estados (borda, cantos arredondados, tudo centralizado):
1. "404" grande, na fonte de títulos, em laranja (acento).
2. Título (`h1`): **"Não encontramos esta página"**.
3. Texto: "O endereço pode ter mudado ou o conteúdo foi removido."
4. Dois botões lado a lado: **"Ir para o início"** (principal, leva a `/`) e **"Explorar a biblioteca"** (secundário, leva a `/biblioteca`). Quando não cabem, um abaixo do outro, centralizados.

Mesma página em todos os casos que hoje mostram a 404. O endereço digitado continua na barra do navegador.

### Erro ao carregar
Sem mudança de texto nem de lugar: "Não foi possível carregar", "Verifique sua conexão e tente novamente." e "Tentar de novo" (principal), que refaz a busca e volta a mostrar o esqueleto. Vale para listagens, post, pessoa da equipe e documento.

Nas seções da Home (Destaques e Equipe), o erro continua discreto, dentro da seção, com o texto de cada uma e "Tentar de novo"; as duas passam a usar a mesma peça, sem mudança visível.

### Lista vazia e sem resultados
Sem mudança de texto: caixa de estado com ícone neutro.
- Sem resultados de busca: "Nenhuma publicação encontrada" / "Tente outro termo ou limpe a busca." / "Limpar busca"; na biblioteca "Nenhum documento encontrado" / "Tente outro termo ou remova algum filtro." / "Limpar filtros".
- Área ou categoria sem itens: os textos atuais de cada tela, sem ação.
- Seções da Home sem itens continuam sumindo (decisão da 005 e da 008).

### Esqueletos de carregamento
Todos os esqueletos do site público ganham o brilho do protótipo: uma faixa clara que corre da esquerda para a direita, em ciclo de cerca de 1,4 s, nas cores quentes do protótipo. Formas e disposição de cada esqueleto não mudam. Com movimento reduzido, o bloco fica parado, em cor única.

### Limpeza
Saem os componentes antigos de vazio e de erro de página que não são usados.

## Estados
- **Carregando:** esqueleto com brilho (parado com movimento reduzido).
- **Vazio:** caixa de estado neutra com os textos atuais; seções da Home somem.
- **Erro:** caixa de erro com "Tentar de novo"; na Home, faixa discreta.
- **Não encontrado:** página 404.
- **Casos de borda:** endereço muito longo ou com caracteres especiais (a 404 não mostra o endereço, não quebra); 404 vinda de um link interno e de um endereço digitado; "Tentar de novo" várias vezes seguidas; erro seguido de sucesso.

## Responsivo
- **Celular (390):** margens de 20 px; botões da 404 um abaixo do outro, centralizados; "404" menor.
- **Tablet (768):** margens de 32 px; botões lado a lado.
- **Desktop (1280):** caixa na largura de conteúdo de até 1120 px, texto limitado como nas outras caixas de estado.
- Em todas: sem rolagem horizontal, sem `overflow`; rodapé na base.

## Acessibilidade
- "Não encontramos esta página" é o `h1` da 404; o "404" é lido como texto antes dele.
- Os dois botões com foco visível e nome igual ao texto; ordem de Tab: navbar → "Ir para o início" → "Explorar a biblioteca" → rodapé.
- Contraste ≥ 4,5:1 em "404", título, texto e botões (nada mais em cinza claro).
- Títulos das caixas de estado continuam anunciados ao aparecer.
- Esqueletos fora da árvore de leitura de tela (como hoje) e sem animação com movimento reduzido.

## Dados e regras de negócio
- Nenhum dado novo. As regras de quando mostrar a 404 não mudam (incluindo membro sem descrição e área errada em link antigo de documento).
- Rotas, redirecionamentos de endereços antigos e textos de vazio e erro já verificados não mudam.
- O navegador recebe a página do site normalmente (o Flutter Web não devolve código HTTP 404); fica como está.

## Critérios de aceite
1. [ ] Um endereço desconhecido (ex.: `/nao-existe`) mostra navbar, a caixa com "404" em acento, `h1` "Não encontramos esta página", "O endereço pode ter mudado ou o conteúdo foi removido.", "Ir para o início" e "Explorar a biblioteca", e o rodapé na base; nenhum item da navbar marcado; sem "HOME" em caixa alta nem cinza claro.
2. [ ] "Ir para o início" leva a `/` e "Explorar a biblioteca" leva a `/biblioteca`, por clique e por teclado.
3. [ ] A mesma 404 aparece para área inválida (`/publicacoes/xyz/abc`), categoria inexistente, post inexistente, documento inexistente, membro inexistente e membro sem descrição.
4. [ ] 404 em 390, 768 e 1280 px conforme "Responsivo" (botões empilhados só no celular), sem rolagem horizontal e sem `overflow`, em release e em debug.
5. [ ] Acessibilidade da 404: `h1` no título, ordem de Tab e foco visível conforme "Acessibilidade", contraste ≥ 4,5:1.
6. [ ] Todos os esqueletos do site público (Home, menu de categorias, categoria, todas as publicações, post, pessoa, biblioteca, documento) mostram o brilho correndo, com cores vindas do tema; com movimento reduzido, ficam parados.
7. [ ] Formas e disposição dos esqueletos iguais às de antes nas três larguras, sem `overflow`.
8. [ ] Destaques e Equipe com erro mostram a faixa discreta com o texto de cada seção e "Tentar de novo", sem mudança visível; as duas usam a mesma peça compartilhada.
9. [ ] Caixas de erro, vazio e sem resultados das listagens, do post, da pessoa, do documento e do visualizador continuam com os textos e ações de hoje.
10. [ ] Os componentes antigos de vazio e de erro de página sem uso foram removidos; nenhuma tela pública usa o círculo girando como estado de carregamento de dados.
11. [ ] Rotas, `AppRoutes`, redirecionamentos, modelos, painel e Geoensine sem mudança.
12. [ ] Código novo usa só tokens de `lib/app/theme/` (cores do esqueleto inclusive), sem `num_extension` nem `GestureDetector` solto; nenhum pacote novo; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Código HTTP 404 de verdade no servidor (depende da hospedagem).
- Erro e placeholder de imagem do desenho antigo, usados só pelos tipos de post antigos e pelo painel; os tipos de post saem nas specs 021 e 022.
- Indicadores de progresso do painel administrativo e do vídeo da Home (botão de reproduzir).
- Mudar textos de vazio e erro já verificados, ou mostrar mensagem de vazio nas seções da Home.
- Busca na 404, modo escuro, Geoensine, painel.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Moldura da 404.** Decidido no modo autônomo: a caixa com borda do protótipo, a mesma das outras caixas de estado (a 011 já trocou a borda tracejada por sólida). Fica no alto do conteúdo, como as outras páginas, e não centralizada na altura da janela.
  - **Segundo botão.** Decidido no modo autônomo: "Explorar a biblioteca", como no protótipo.
  - **"404" para leitor de tela.** Decidido no modo autônomo: lido como texto, antes do `h1`, para quem usa leitor de tela também saber que é uma 404.
  - **Brilho dos esqueletos.** Decidido no modo autônomo: segue o protótipo (faixa correndo, cerca de 1,4 s) e para com movimento reduzido. Muda todos os esqueletos de uma vez, sem mexer nas formas.
  - **Erro nas seções da Home.** Decidido no modo autônomo: continua discreto (decisão da 005/008, já verificada), só passa a ser uma peça compartilhada. Trocar pela caixa grande de erro faria a Home pesar com duas caixas quando a rede cai.
  - **Erro de imagem antigo.** Decidido no modo autônomo: fica fora. Só os tipos de post antigos e o painel usam; as specs 021 e 022 trocam os tipos de post.
  - **Componentes antigos sem uso.** Decidido no modo autônomo: removidos, porque ninguém os usa e mantê-los convida a reaproveitar o desenho antigo.

## Histórico de mudanças
- 2026-10-05: criada e aprovada no modo autônomo (execução da Fase 5).
- 2026-10-05: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-10-05: direção do brilho corrigida para "da esquerda para a direita", que é o que o protótipo faz (decidido no modo autônomo, na implementação).
