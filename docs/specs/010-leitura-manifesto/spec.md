# 010. Layout de leitura compartilhado e Manifesto

- **Status:** implementada
- **Item do planejamento:** Fase 2 (leitura), T-01 Manifesto, e a base de leitura usada depois por T-03, T-02 e T-08
- **Protótipo:** aba "Manifesto"; abas "História", "Membro" e "Post" como referência do que vai reaproveitar o layout (link no CLAUDE.md)
- **Criada em:** 2026-10-01
- **Depende de:** [001-fundacao](../001-fundacao/spec.md) (tokens, tipografia, largura máxima), [002-botoes-navbar-rodape](../002-botoes-navbar-rodape/spec.md) (botões, navbar, rodapé, foco), [007-resumo-nossa-historia](../007-resumo-nossa-historia/spec.md) (cabeçalho de superfície e coluna de 680 px provisórios)

## Objetivo
Quem abre o Manifesto lê um texto confortável, com os cinco compromissos em lista numerada, e termina com um convite para falar com o Observatório. A mesma base de leitura (cabeçalho de página, coluna de texto e blocos) passa a valer para as próximas páginas de texto da Fase 2.

## Situação atual
- [manifest_page.dart](../../../lib/app/features/home/presentation/pages/manifest_page.dart): título "MANIFESTO" em laranja antigo com divisória, sete parágrafos em cinza claro (`gray`, abaixo de 4,5:1) na largura toda, com os compromissos escritos como "1)" a "5)" dentro do texto. Usa `num_extension`. O rodapé fica abaixo de um `SliverFillRemaining` vazio.
- [our_history_page.dart](../../../lib/app/features/home/presentation/pages/our_history_page.dart) (spec 007) já tem um cabeçalho de superfície com título e a coluna de 680 px, montados dentro da própria página, sem migalhas.
- O Manifesto é aberto pelo hero ("Ler o manifesto"), por Quem somos ("Conheça o manifesto") e pelo rodapé, em `/manifesto`. `/manifest` redireciona para `/manifesto`.

## Comportamento

### Layout de leitura (base compartilhada)
Toda página de texto da Fase 2 que o usar tem, de cima para baixo:

1. **Cabeçalho de página:** faixa com fundo de superfície (`#F7F5F2`) e linha fina na base, com o conteúdo alinhado à esquerda dentro da largura máxima do site:
   - **Migalhas** (texto pequeno, cor secundária): "Início" como link, seta pequena, e a página atual em tinta e peso 600, sem link. Aceita um nível intermediário com link (ex.: "Início › Equipe › Nome", para a 011).
   - **Título** da página (fonte de títulos, tamanho de título de página).
   - **Texto de apoio** opcional abaixo do título (o Manifesto não usa; Nossa história, na 011, sim).
2. **Coluna de leitura:** até 680 px, centralizada na largura do site, com respiro acima do texto e antes do rodapé. Dentro dela, os blocos:
   - **Abertura:** parágrafo maior, em tinta (tamanho do texto de apoio do cabeçalho).
   - **Parágrafo:** texto de leitura em tinta, com vão entre parágrafos.
   - **Lista numerada:** cada item com o número dentro de um círculo laranja suave (número em laranja forte, negrito) à esquerda e o texto ao lado, alinhado ao topo da primeira linha; o texto que quebra linha fica alinhado ao texto, não ao número.
   - **Destaque:** frase curta com barra laranja à esquerda, na fonte de títulos, maior que o texto.
   - **Ação final:** um botão primário, alinhado à esquerda da coluna.
3. **Rodapé** do site, colado na base da janela quando a página é curta.

Os blocos de subtítulo e de lista com marcadores (Nossa história) e a forma como o conteúdo dos posts usa a coluna ficam para a 011 e a 012, sobre esta mesma base. Páginas que não usam a faixa de cabeçalho (Pessoa da equipe e post, que têm cabeçalho próprio no protótipo) podem usar só a coluna.

### Manifesto (`/manifesto`)
- **Migalhas:** "Início" (abre a Home) › "Manifesto".
- **Título:** "Manifesto".
- **Abertura:** "O Observatório tem compromisso com a criação e democratização dos conhecimentos científicos, artísticos e pedagógicos. Nosso propósito é acompanhar, selecionar, produzir e disseminar conteúdos, especialmente sobre ensino e aprendizagem em História e Geografia."
- **Parágrafo:** "O trabalho é movido pela inquietação e o desejo de:"
- **Lista numerada (1 a 5, na ordem do texto original):**
  1. "Desenvolver pesquisas de médio e longo prazos e matérias analíticas (artigos, livros, capítulos de livros, coletâneas, trabalhos apresentados e publicados em anais de eventos, teses, dissertações, monografias, vídeos e outros);"
  2. "Levantar, sistematizar e divulgar dados, informações, textos acadêmicos e jornalísticos, vídeos e outros artefatos da cultura, bem como relatos de experiências de ensino;"
  3. "Monitorar e avaliar as políticas públicas, a formação de professores (inicial e continuada), a produção de currículos e materiais didáticos relacionados ao ensino de História e Geografia;"
  4. "Acompanhar, promover e intervir nos debates públicos de questões relacionadas à História e à Geografia no âmbito cultural e educacional;"
  5. "Promover atividades de extensão e formação de professores, gestores de políticas e instituições educativas, pesquisadores e estudantes."
- **Parágrafo:** "O Observatório do Ensino de História e Geografia nasceu para produzir e divulgar conteúdos e experiências de qualidade e, sobretudo, aproximar, criar redes, reconectar quem atua com a História e a Geografia nas escolas e nas universidades."
- **Destaque:** "Faça parte dessa criação!"
- **Ação final:** botão primário "Fale com a gente" com seta, que abre `/contato`.

O título laranja em caixa alta, a divisória, o texto cinza claro e os prefixos "1)" a "5)" deixam de aparecer. A página abre no topo; o voltar do navegador retorna à página anterior.

## Estados
- **Carregando:** não se aplica (texto fixo, aparece junto com a navbar).
- **Vazio:** não se aplica.
- **Erro:** não se aplica (sem dados do banco). Endereço errado continua na 404 atual.
- **Sem imagem / imagem com falha:** não se aplica (sem imagens).
- **Casos de borda:**
  - Texto ampliado até 200%: o círculo do número cresce junto com o número (o número não vaza do círculo), itens, destaque, migalhas e botão quebram linha sem sobreposição nem `overflow`.
  - Migalhas que não cabem numa linha quebram, mantendo a seta junto do item seguinte.
  - Acesso direto a `/manifesto` (atualizar ou link colado) e por `/manifest` (redireciona) abre a página.
  - Janela alta: o rodapé fica na base da janela, sem vão em branco abaixo dele.

## Responsivo
- **Celular (390):** margens de 20 px; título ≈ 32 px; abertura 17 px; texto e itens 17 px; destaque ≈ 20 px; coluna na largura útil (350 px).
- **Tablet (768):** margens de 32 px; título ≈ 40 px; abertura 20 px; texto 18 px; destaque ≈ 22 px; coluna de 680 px centralizada.
- **Desktop (1280):** conteúdo limitado a 1120 px; título ≈ 52 px; mesmos tamanhos do tablet; coluna de 680 px centralizada, cabeçalho alinhado à esquerda da largura máxima.
- Em todas: sem rolagem horizontal e sem aviso de `overflow`.

## Acessibilidade
- O título da página é anunciado como cabeçalho.
- As migalhas formam um grupo de navegação com nome "Você está em"; "Início" é um link alcançável por Tab, com foco visível (contorno de 3 px, laranja, afastado 2 px) e ativável por Enter; o item atual não é focável e é anunciado como página atual; as setas são decorativas.
- Cada item da lista é lido com o seu número ("1. Desenvolver pesquisas…"), na ordem visual; o círculo não é lido separado.
- O botão "Fale com a gente" é alcançável por Tab depois das migalhas e antes do rodapé, com foco visível; a seta é decorativa.
- A barra do destaque é decorativa.
- Contraste: migalhas em cor secundária `#5E5852` sobre a superfície (≥ 6:1); hover das migalhas em laranja forte `#A33600` (6,3:1); número `#A33600` sobre laranja suave `#FFF0E6` (6,1:1); título, abertura, parágrafos, itens e destaque em tinta (≥ 15:1).
- Movimento reduzido: nada anima nesta página além dos estados de hover já existentes do botão.

## Dados e regras de negócio
- Texto fixo no código, sem dados do Firebase.
- O texto é o do site atual com a revisão do protótipo aprovado: o primeiro parágrafo é dividido em abertura + "O trabalho é movido…"; os prefixos numéricos viram a lista; "Faça parte dessa criação!" vira o destaque; espaços duplos e a vírgula em "especialmente, sobre" saem; "extensão/formação" vira "extensão e formação" e "pesquisadores, estudantes" vira "pesquisadores e estudantes". Nenhuma frase é apagada.
- Rotas: nenhuma muda. `/manifesto` continua a mesma e `/manifest` continua redirecionando.
- A navbar não marca item ativo em `/manifesto` (como hoje).

## Critérios de aceite
1. [ ] `/manifesto` mostra navbar, cabeçalho de superfície com linha na base, migalhas "Início › Manifesto", título "Manifesto" e, abaixo, a coluna de leitura e o rodapé.
2. [ ] O texto da página é exatamente o desta spec, na ordem: abertura, "O trabalho é movido…", lista de 1 a 5, parágrafo final, destaque e botão; nenhuma frase do texto atual falta.
3. [ ] Os cinco compromissos aparecem como lista numerada de 1 a 5, com o número num círculo laranja suave à esquerda e o texto quebrado alinhado ao texto (não ao número); os prefixos "1)" a "5)" não aparecem.
4. [ ] O destaque "Faça parte dessa criação!" tem barra laranja à esquerda e fonte de títulos maior que o texto; o botão primário "Fale com a gente" abre `/contato` por clique e por Enter.
5. [ ] "Início" nas migalhas abre a Home por clique e Enter; o item "Manifesto" não é link.
6. [ ] `/manifesto` funciona por acesso direto (atualizar) e `/manifest` redireciona para ela; o hero, Quem somos e o rodapé continuam abrindo a página; o voltar do navegador retorna à página anterior.
7. [ ] Nenhuma rota muda (`/`, `/manifesto`, `/manifest`, `/nossa-historia`, `/membro/:id`, `/contato`, `/colaborar`, posts, biblioteca e admin abrem como antes).
8. [ ] Em 1280 px, cabeçalho alinhado à esquerda dentro de 1120 px e coluna de 680 px centralizada; em 768 e 390 px, conforme "Responsivo".
9. [ ] Com a janela alta, o rodapé fica na base da janela, sem vão em branco abaixo dele.
10. [ ] Título anunciado como cabeçalho; migalhas como navegação "Você está em", com o item atual marcado; cada item da lista lido com seu número; setas, círculos e barra do destaque não lidos separados; ordem de Tab: migalhas → botão → rodapé, com contorno de foco visível.
11. [ ] Contraste ≥ 4,5:1 em migalhas (repouso e hover), número sobre o círculo, título, abertura, parágrafos, itens e destaque; nenhum texto em cinza claro.
12. [ ] Em 390, 768 e 1280 px (e com texto a 200%): sem rolagem horizontal, sem sobreposição, sem `overflow`; o número não vaza do círculo.
13. [ ] A base de leitura é única e reaproveitável: aceita migalhas de dois ou três níveis e texto de apoio opcional no cabeçalho, e a coluna pode ser usada sem a faixa de cabeçalho (conferido no código e descrito em `docs/arquitetura.md`).
14. [ ] O código novo usa só tokens de `lib/app/theme/` (nenhuma cor, tamanho de fonte ou espaçamento solto) e não usa `num_extension`; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Redesenho de Nossa história (foto, selo, subtítulos, lista com marcadores) e da Pessoa da equipe: spec 011, que reaproveita esta base. A página provisória `/nossa-historia` fica como está nesta entrega.
- Layout do post, conteúdo vindo do editor (Quill) e compartilhamento: specs 012 e 013.
- Item ativo da navbar e título da aba do navegador por página.
- Apagar componentes antigos (`AppHeadline`, `AppBody`, `AppDivider`) ou `num_extension` (Fase 7).
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Texto do Manifesto.** Decidido no modo autônomo: usar o texto do protótipo, que é o texto atual com a estrutura de abertura, lista e destaque e pequenas correções (espaços, vírgula, "extensão e formação", "pesquisadores e estudantes"), porque o protótipo aprovado diz "Texto real do site atual" e nenhuma frase é removida.
  - **Migalhas.** Decidido no modo autônomo: entram no cabeçalho de página desta base, porque todas as páginas de texto do protótipo (Manifesto, História, Contato) as têm e a 007 já adiou as migalhas para a Fase 2.
  - **Chamada final.** Decidido no modo autônomo: destaque "Faça parte dessa criação!" e botão primário "Fale com a gente" para `/contato`, porque é o que o protótipo mostra e a rota já existe.
  - **Alcance da base nesta spec.** Decidido no modo autônomo: só os blocos que o Manifesto usa (abertura, parágrafo, lista numerada, destaque, ação final), mais migalhas de três níveis e texto de apoio opcional no cabeçalho, porque cada bloco precisa ser conferível numa tela real; subtítulo e lista com marcadores entram na 011, que tem onde mostrá-los.
  - **Nossa história provisória.** Decidido no modo autônomo: não migrar nesta spec, porque a 011 redesenha a página inteira sobre esta base e mexer agora seria retrabalho.
  - **Cabeçalho de página.** Decidido no modo autônomo: respiro do protótipo (`.page-head .wrap`: 28 px acima das migalhas e 32/46/56 px abaixo do título por faixa, título 22 px abaixo das migalhas), porque o cabeçalho provisório da 007 tinha respiro igual em cima e embaixo por não ter migalhas.
  - **Círculo do número com texto ampliado.** Decidido no modo autônomo: o círculo cresce com o número, porque um círculo fixo de 30 px corta o número a 200%.
  - **Item ativo da navbar.** Decidido no modo autônomo: nenhum, como hoje, porque mudar a navbar está fora do item (mesma decisão da 007).

## Histórico de mudanças
- 2026-10-01: criada e aprovada no modo autônomo (execução da Fase 2).
- 2026-10-01: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-10-01: implementada. Ajuste na implementação: o título da página sai como cabeçalho de nível 1 (`h1`), não só "cabeçalho", por ser o título da página.
