# 002. Botões, navbar e rodapé

- **Status:** verificada
- **Item do planejamento:** Fase 0, entregas 0.4, 0.5 e 0.6 (e o logo em SVG, citado nas decisões)
- **Protótipo:** navbar e rodapé de qualquer aba; aba "Fundamentos" para os botões (link no CLAUDE.md)
- **Criada em:** 2026-09-26
- **Depende de:** [001-fundacao](../001-fundacao/spec.md)

## Objetivo
Trocar o "casco" que aparece em todas as páginas (botões, barra de navegação e rodapé) pelo visual do redesign, com foco visível e navegação completa por teclado. As páginas continuam as mesmas, só com a nova roupa nesses componentes.

## Situação atual
- **Botões** ([primary_button.dart](../../../lib/app/core/components/buttons/primary_button.dart), [secondary_button.dart](../../../lib/app/core/components/buttons/secondary_button.dart), [app_text_button.dart](../../../lib/app/core/components/buttons/app_text_button.dart)): três tamanhos (pequeno, médio, grande), laranja `#FF6900`, sem foco visível próprio. O botão de texto usa clique solto, sem foco por teclado. Usados no site público, e no painel admin.
- **Navbar** ([navbar.dart](../../../lib/app/core/components/navbar/navbar.dart), [navbar_menu.dart](../../../lib/app/core/components/navbar/navbar_menu.dart), [navbar_dropdown.dart](../../../lib/app/core/components/navbar/navbar_dropdown.dart), [navbar_mobile_menu.dart](../../../lib/app/core/components/dialog/navbar_mobile_menu.dart)): logo em imagem raster, itens Sobre, História, Geografia e Biblioteca. História e Geografia abrem as categorias reais ao passar o mouse ou tocar. No celular, um painel lateral com sanfonas. Não fica fixa ao rolar. Item ativo com fundo cinza.
- **Rodapé** ([footer.dart](../../../lib/app/core/components/footer/footer.dart)): faixa laranja com endereço, telefones e e-mail em texto, sem links clicáveis e sem redes sociais. O ano (2024) está escrito no texto.
- **Redes sociais** ficam em [social_buttons.dart](../../../lib/app/core/components/buttons/social_buttons.dart) e no bloco de apoio (`Support`), com ícones em PNG.

## Comportamento

### Botões
Três tipos e três tamanhos. Textos e tamanhos vêm da spec 001.

| Tipo | Repouso | Passar o mouse | Uso |
|---|---|---|---|
| **Primário** | Fundo laranja de acento, texto branco | Fundo laranja forte | Ação principal da tela |
| **Secundário** | Sem fundo, borda e texto na cor do texto principal | Fundo na cor do texto principal, texto branco | Ação alternativa |
| **Discreto** | Sem fundo nem borda, texto laranja forte | Fundo laranja suave, texto laranja forte | Ações de baixa ênfase |

- **Tamanhos:** pequeno (texto 14), médio (texto 16) e grande (texto 18). Cantos arredondados (10 px). Altura mínima de 40 px (pequeno) e 44 px (médio e grande).
- **Foco por teclado:** contorno visível de 3 px na cor de acento, afastado 2 px, em qualquer tipo. Enter e Espaço acionam.
- **Desativado:** aparência esmaecida, não recebe clique nem foco, e o leitor de tela informa "desativado".
- **Texto longo:** quebra em mais de uma linha sem cortar; o botão cresce em altura.
- **Onde vale:** todas as telas que usam esses botões, inclusive painel admin.
- Os botões de ícone e de redes sociais também ganham foco visível e nome acessível.

### Logo
- A marca (círculos concêntricos em laranja, do protótipo) passa a existir como **arquivo SVG** no projeto e substitui a imagem atual na navbar e no rodapé.
- Ao lado da marca, o nome **"Observatório"** e, abaixo, "Ensino de História e Geografia". No celular o texto menor some e fica só "Observatório".
- Clicar no logo leva à Home. Nome acessível: "Observatório do Ensino de História e Geografia, início".

### Navbar
**Geral**
- Fica **fixa no topo** ao rolar a página, com fundo branco levemente translúcido e uma linha fina na base. Altura de 68 px.
- Itens, nesta ordem: **Sobre** (Home), **História**, **Geografia**, **Biblioteca**. Sem ícone de busca (a busca é ideia futura).
- **Item ativo:** texto laranja com sublinhado de 2 px. Vale para Sobre e Biblioteca quando a rota é a deles, e para História e Geografia quando a categoria aberta pertence à área.
- **Desktop (≥ 1024):** itens em linha. **Tablet e celular (< 1024):** só a marca e um botão de menu (três traços).

**Menus de História e Geografia (desktop)**
- Abrem ao **passar o mouse** ou ao **clicar/tocar/Enter/Espaço** no item. Fecham ao tirar o mouse, ao clicar fora, ao pressionar Esc ou ao escolher uma opção.
- Listam as **categorias reais** de cada área, na ordem atual, sem agrupar. A categoria em que a pessoa está aparece marcada.
- **Geografia** mostra primeiro **Expogeo** e **Geoensine** (com o ícone de link externo, abrem em outra aba), depois um divisor, depois as categorias.
- Teclado: Tab chega ao item; Enter/Espaço/seta para baixo abre e leva ao primeiro item; setas sobem e descem; Esc fecha e devolve o foco ao item; Tab sai do menu e o fecha.
- O item que abre um menu informa "expandido" ou "recolhido" ao leitor de tela.

**Menu de celular e tablet**
- O botão abre um painel sobre a página com: Sobre, História (sanfona), Geografia (sanfona) e Biblioteca.
- Cada sanfona lista as categorias da área. Na de Geografia, Expogeo e Geoensine vêm primeiro, com o divisor.
- Escolher uma opção fecha o painel e navega. Há botão "Fechar menu"; Esc e toque fora também fecham. Com o painel aberto, o foco do teclado fica dentro dele e volta ao botão de menu ao fechar.
- Nome acessível do botão: "Abrir menu" / "Fechar menu", informando se está expandido.

## Rodapé
Fundo escuro em colunas, no fim de todas as páginas do site público que já o usam, e também na página 404.

| Coluna | Conteúdo |
|---|---|
| Marca | Logo com nome; endereço: "Faculdade de Educação, sala 1G156 · UFU / Av. João Naves de Ávila, 2121 · Santa Mônica / Uberlândia/MG"; ícones de **Instagram, Facebook e YouTube** |
| Explorar | Sobre, Biblioteca |
| Institucional | Manifesto, Equipe (leva à Home), Fale com a gente |
| Contato | `contato@observatoriogeohistoria.net.br` (abre o programa de e-mail), `34 3239-4163` e `34 3239-4212` (tocáveis para ligar no celular) |

- Faixa inferior: "© *ano atual* Observatório do Ensino de História e Geografia" e "Conteúdo sob licença Creative Commons 4.0 Internacional". O **ano é o do dia em que a página é aberta**.
- **Sem "Colabore"** no rodapé. **Sem "Nossa história"** por enquanto: entra quando a página existir (Fase 2).
- Redes sociais abrem em outra aba, com nome acessível ("Instagram", "Facebook", "YouTube").
- Todos os links mostram foco visível (contorno na cor de destaque do rodapé) e mudam de cor ao passar o mouse.

## Estados
- **Carregando:** enquanto as categorias não chegam, os menus de História e Geografia mostram linhas de esqueleto. Em Geografia, Expogeo e Geoensine aparecem desde já. A navbar não "pula" quando os dados chegam.
- **Vazio:** área sem categorias mostra "Nenhuma categoria por enquanto" (desativado, sem foco).
- **Erro:** falha ao buscar categorias mostra "Não foi possível carregar as categorias" e o botão "Tentar de novo" dentro do menu. Sobre, Biblioteca e o resto da navbar seguem funcionando.
- **Sem imagem / imagem com falha:** o SVG do logo é local, então não falha. Nenhum outro componente aqui usa imagem de autor.
- **Casos de borda:**
  - Muitas categorias: o menu ganha rolagem interna em vez de sair da tela.
  - Nome de categoria muito longo: quebra em duas linhas, sem cortar.
  - Menu perto da borda direita: alinha à direita para não sair da tela.
  - Nome da área ativa quando não há categoria selecionada: nenhum item de área ativo.

## Responsivo
- **390:** navbar com marca e botão de menu; painel do menu ocupa a largura; rodapé em **1 coluna**; botões podem ocupar a largura toda dentro dos blocos que os usam.
- **768:** mesma navbar do celular (menu em painel); rodapé em **2 colunas**.
- **1280:** navbar em linha com menus; rodapé em **4 colunas**; conteúdo limitado a 1120 px e centralizado.
- Sem rolagem horizontal nem `overflow` em nenhuma das larguras.

## Acessibilidade
- Foco visível em botões, itens da navbar, opções dos menus e links do rodapé; ordem de Tab segue a ordem visual.
- Navegação completa da navbar por teclado, como descrito acima.
- Contraste ≥ 4,5:1: texto branco no botão primário (repouso e hover), texto do item ativo, texto e links do rodapé sobre o fundo escuro, ícones informativos.
- Ícones sozinhos (redes, menu, fechar) têm nome acessível.
- Links externos informam que abrem em outra aba.
- Movimento reduzido: sem animação de abertura de menu quando a pessoa pediu para reduzir movimento.

## Dados e regras de negócio
- As categorias do menu vêm do mesmo lugar de hoje e seguem sem agrupamento.
- Rotas existentes não mudam. Navegar por uma categoria mantém o comportamento atual (a categoria escolhida continua marcada).
- O e-mail, os telefones e as redes usam as constantes já existentes do projeto quando houver; o e-mail é `contato@observatoriogeohistoria.net.br`.
- O endereço do rodapé segue o texto do protótipo (sem CEP).
- Nenhum dado nem modelo muda.

## Critérios de aceite
- [ ] Botões primário, secundário e discreto, nos três tamanhos, com repouso, hover, foco, desativado e texto longo iguais ao descrito.
- [ ] Enter e Espaço acionam qualquer botão; o botão discreto tem foco por teclado.
- [ ] Painel admin e site público abrem sem erro com os botões novos.
- [ ] O logo em SVG existe no projeto e aparece na navbar e no rodapé, nítido em 1× e 2×.
- [ ] Navbar fixa: continua visível ao rolar em Home, categoria, post, biblioteca, contato, manifesto, membro e 404.
- [ ] Item ativo em laranja com sublinhado em Sobre, Biblioteca, História e Geografia conforme a rota.
- [ ] Em ≥ 1024, os menus abrem por hover e por teclado, listam as categorias reais e fecham com Esc, clique fora e ao escolher.
- [ ] Geografia mostra Expogeo e Geoensine primeiro, com divisor, e ambos abrem em outra aba.
- [ ] Em < 1024, o menu em painel tem sanfonas, fecha por botão, Esc e toque fora, e devolve o foco ao botão.
- [ ] Estados carregando (esqueleto), vazio e erro com "Tentar de novo" existem no menu de categorias.
- [ ] Rodapé com 4, 2 e 1 colunas em 1280, 768 e 390 px, com as redes sociais, e-mail e telefones clicáveis, sem "Colabore" e sem "Nossa história".
- [ ] O ano do rodapé é o ano atual, sem valor escrito no código.
- [ ] Todo elemento clicável tem foco visível e nome acessível.
- [ ] Contraste ≥ 4,5:1 nos pares listados, com os valores anotados no `verificacao.md`.
- [ ] Nenhuma cor, tamanho ou espaçamento solto: só tokens do tema. Sem `num_extension` nos componentes novos.
- [ ] Sem rolagem horizontal nem `overflow` em 390, 768 e 1280 px.
- [ ] `fvm flutter analyze` sem novos avisos.

## Fora do escopo
- Busca na navbar (ideia futura).
- Página "Nossa história" e link no rodapé (Fase 2).
- Redesenho das telas (só a navbar, o rodapé e os botões mudam).
- O bloco de apoio (`Support`) e a lista de parceiros (Fase 1, item 1.7, e post).
- Novas rotas.
- Modo escuro.

## Perguntas em aberto
- Nenhuma. (Respondidas: botões novos em todo o app, incluindo admin e Geoensine; e-mail `observatoriogeohistoria.net.br`; "Nossa história" fora do rodapé por enquanto; coluna Explorar só com Sobre e Biblioteca.)

## Histórico de mudanças
- 2026-09-26: criada.
- 2026-09-26: aprovada.
- 2026-09-26: pontos do plano aprovados. 404 ganha navbar e rodapé; (a seção interna do Geoensine foi removida do projeto em 2026-09-26; ficou só o link externo no menu de Geografia); `LibraryNavbar` substituída pela navbar nova; `tooltip` obrigatório nos botões de ícone; Biblioteca ativa em subrotas; "Equipe" leva à Home.
- 2026-09-26: por causa do contraste (ver 001), o botão discreto no hover usa o acento forte para o texto, sobre o fundo laranja suave. Vale também para texto laranja sobre a superfície `#F7F5F2`.

- 2026-09-26: implementada. Divergências pequenas: a 404 usa `NavbarSliver` (e não `Navbar` solta); o item ativo vem da rota, não do `selectedCategory`.
- 2026-09-26: (verificação) o botão discreto usa o acento forte também em repouso, para passar de 4,5:1 sobre a superfície `#F7F5F2`.
- 2026-09-26: (verificação, 2ª rodada) corrigidos: abrir o menu por Enter, Espaço ou seta leva o foco à primeira opção; Tab com o menu aberto fecha e segue para o próximo item da navbar; a faixa inferior do rodapé ganhou a linha da licença Creative Commons; no desktop, as colunas Explorar e Institucional do rodapé ocupam só a largura dos links, e marca e contato dividem o resto (4:3), para o endereço e o e-mail não quebrarem.
- 2026-09-26: verificada (aprovada com ressalvas; ver `verificacao.md`).
