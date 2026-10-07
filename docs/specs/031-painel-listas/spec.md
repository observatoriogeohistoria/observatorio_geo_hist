# 031. Listas do painel em linhas, mídias em grade e filtros em linha

- **Status:** aprovada
- **Item do planejamento:** Fase 8, item 8.3 (T-13)
- **Protótipo:** aba "Painel" (link no CLAUDE.md)
- **Criada em:** 2026-10-07

## Objetivo
Cada seção do painel mostra seus itens em linhas compactas, com miniatura, situação em selo e ações à direita, e filtros numa barra única acima da lista. Dá para ver mais itens por tela e achar o que se procura sem abrir painéis de filtro.

## Situação atual
- Publicações (`posts_section.dart`, `post_card.dart` e os 10 `posts_cards/*`): cartões altos com campos rotulados ("Área(s): …", "Categoria: …"), selos e uma coluna de ícones. Filtros em `section_header_actions.dart`: busca e quatro listas suspensas (área, categoria, publicação, destaque), mais "Limpar filtros".
- Categorias, Equipe, Usuários (`crud_section.dart` e cards): cartões com número de ordem e ações. Sem filtros.
- Mídias (`media_section.dart`, `media_card.dart`): cartões em lista, um embaixo do outro, paginados ao rolar.
- Biblioteca: a seção mostra dois blocos laranja (Geografia e História); cada um abre outra página (`library_list_page.dart`) com barra laranja, filtros num painel lateral (`filters.dart`, com "Aplicar Filtros") e "Carregar mais".
- Carregando: círculo girando. Vazio: "Nenhum item cadastrado." Erro: só o aviso flutuante (a lista fica vazia), exceto na biblioteca, que já tem erro com "Tentar de novo".

## Comportamento

### Lista em linhas (todas as seções, exceto Mídias)
Caixa branca com borda e cantos arredondados; uma linha por item, separadas por linha fina, com leve fundo ao passar o mouse. Cada linha tem quatro partes:
1. **Imagem ou ícone** à esquerda.
2. **Título** (até duas linhas, depois reticências) e **meta** em cinza numa linha abaixo.
3. **Selos** de situação, com texto (nunca só cor).
4. **Ações** em botões de ícone com dica (030). Quem só pode ver (`VIEWER`) não vê as ações.

Por seção:
- **Publicações:** miniatura 16:10 da imagem do post (`cover`); meta "Área · Categoria" e, quando o tipo tem, "· Autoria · Data". Selos "Publicado" (verde) ou "Não publicado" (neutro) e "Destaque" com estrela (laranja). Ações: Publicar/Despublicar, Destacar/Tirar dos destaques (estrela preenchida quando ativo), Editar (abre o editor da 033; até lá, o diálogo atual), Excluir.
- **Categorias:** ícone da área (globo para Geografia, ampulheta para História, camadas para as duas); meta "História e Geografia · N publicações · descrição". Selo "Aceita colaboração" quando a opção está ligada. Ações: Editar, Excluir (desabilitado com dica quando tem publicações).
- **Biblioteca:** ícone de documento; meta "Autor · Instituição · Ano · N categorias". Selo com o tipo ("Tese" ou "Dissertação"). Ações: Editar, Excluir.
- **Equipe:** foto redonda do membro (iniciais quando não há foto ou ela falha); meta com a função e "· Currículo Lattes" quando houver. Selo "Com página" (tem descrição) ou "Sem página". Ações: Editar, Excluir.
- **Usuários:** círculo com iniciais; meta com o e-mail. Selo com o papel ("Administração" em laranja; "Edição" e "Leitura" neutros). Ações: Editar, Excluir. Não há selo de ativo/inativo: o dado não existe.

### Mídias em grade
Grade de blocos (largura mínima fixa por bloco, quantos couberem): imagem 4:3 (`cover`), nome do arquivo (uma linha, com reticências e o nome completo na dica) e, embaixo à direita, as ações Ver imagem, Copiar link e Excluir. Continua carregando mais ao rolar; embaixo, "N imagens carregadas · as próximas carregam ao rolar" enquanto houver mais.

### Barra de filtros
Caixa branca acima da lista. Os filtros aplicam ao mudar, sem botão "Aplicar"; a busca espera a pessoa parar de digitar.
- **Publicações:** busca "Buscar por título"; "Todas as áreas"/História/Geografia; "Todas as categorias" (só as da área escolhida; trocar a área limpa a categoria); controle segmentado de situação "Todas", "Publicadas", "Não publicadas"; botão "Destaques" com estrela, que liga e desliga (ligado mostra só destaques). Sai a opção "Sem destaque" de hoje.
- **Categorias:** busca "Buscar categoria" e área. Filtro feito na própria tela, sobre a lista já carregada.
- **Biblioteca:** controle segmentado "Geografia" | "História" no início da barra; busca "Buscar por título"; "Todos os tipos"/Tese/Dissertação; "Categorias" com seleção livre e contagem de marcadas, como no site público; e "Mais filtros", que mostra Autor, Instituição e Ano na linha de baixo. Decidido com a pessoa.
- **Mídias:** busca "Buscar pelo nome do arquivo", sobre as imagens carregadas.
- **Equipe e Usuários:** sem filtros (como hoje).

Com algum filtro ativo, aparece "Limpar filtros" no rodapé da lista.

### Biblioteca dentro do painel
A seção Biblioteca passa a mostrar direto a lista de Geografia, sem os dois blocos e sem página à parte com barra laranja: fica dentro da moldura do painel (menu e barra superior da 030). Trocar a área no controle segmentado muda o endereço para `/admin/painel/biblioteca/:area`. `/admin/painel/biblioteca` abre Geografia. "Carregar mais" continua como hoje, no rodapé da lista.

## Estados
- **Carregando:** esqueleto de 4 linhas (miniatura e duas barras de texto) ao abrir a seção ou trocar de filtro, em vez do círculo; na grade de mídias, blocos-esqueleto. Ao carregar mais, indicador no fim da lista. Sem animação do brilho com movimento reduzido.
- **Vazio (nada cadastrado):** caixa com ícone, título e texto, e o botão de criar para quem pode:
  - Tipo de publicação: "Nada em Revistas ainda" / "Crie a primeira e ela aparece aqui. Só vai para o site quando você publicar." (concordância pelo gênero do tipo).
  - Demais: "Nenhuma categoria ainda", "Nenhum documento em Geografia ainda", "Nenhuma imagem ainda", "Ninguém na equipe ainda", "Nenhum usuário ainda", com texto curto equivalente.
- **Vazio (filtro sem resultado):** "Nada encontrado com esses filtros" / "Tente outro termo ou limpe os filtros." e botão "Limpar filtros".
- **Erro:** caixa de erro com a mensagem e "Tentar de novo", no lugar da lista. Acesso negado continua saindo do painel.
- **Sem imagem / imagem com falha:** miniatura com fundo `accentSoft` e ícone de imagem, nome acessível "Sem imagem"; mesma coisa quando a imagem não carrega. Imagens muito altas ou muito largas são cortadas pela proporção fixa.
- **Casos de borda:** 1 item; centenas de itens com rolagem; título muito longo (duas linhas e reticências); categoria com nome e descrição longos (meta numa linha com reticências); usuário com e-mail longo.

## Responsivo
- **390:** linha vira cartão: miniatura (menor) e título lado a lado, selos abaixo do título, ações numa faixa embaixo, alinhadas à direita, separadas por linha tracejada. Busca ocupa a largura; os outros filtros quebram em linhas. Grade de mídias com 2 colunas.
- **768:** linhas completas; filtros em uma ou duas linhas; grade com 3 a 4 colunas.
- **1280:** linhas completas; filtros em uma linha (exceto "Mais filtros" da biblioteca); grade com 5 a 6 colunas.

## Acessibilidade
- Cada linha é lida como item (título, meta e selos); as ações têm nome que inclui o item quando preciso ("Excluir" com a dica e o título no anúncio).
- Ordem de Tab: filtros, depois cada linha da esquerda para a direita, depois "Limpar filtros" e "Carregar mais".
- Após publicar, despublicar ou destacar, o foco continua no mesmo botão da mesma linha.
- Controle segmentado e "Destaques" anunciam o estado de pressionado.
- Selos e meta com contraste ≥ 4,5:1; miniaturas são decorativas quando há título.

## Dados e regras de negócio
- Mesmas consultas, paginação e filtros de hoje para publicações e biblioteca; categorias e mídias filtram na tela, sem consulta nova.
- Nenhum modelo muda. Publicar e destacar pela lista continuam salvando como hoje.
- Rotas: `/admin/painel/:tab`, `?tipo=`, `/admin/painel/biblioteca/:area` mantidas.

## Critérios de aceite
- [ ] As seis seções reproduzem a aba "Painel" do protótipo em 390, 768 e 1280 px, sem `overflow` nem rolagem horizontal.
- [ ] Publicações em linhas com miniatura 16:10, meta, selos e as quatro ações; placeholder quando falta ou falha a imagem.
- [ ] Filtros de publicações: busca, área, categoria dependente da área, situação e destaques funcionam e combinam; "Limpar filtros" zera todos.
- [ ] Categorias com ícone da área, contagem, selo de colaboração e filtros de busca e área.
- [ ] Biblioteca dentro da moldura do painel, com troca de área no segmentado (endereço muda), busca, tipo, categorias, "Mais filtros" (autor, instituição, ano) e "Carregar mais".
- [ ] Mídias em grade, com busca e carregamento ao rolar.
- [ ] Equipe com selo "Com página"/"Sem página"; Usuários com selo de papel.
- [ ] Esqueleto ao carregar; estado vazio com botão de criar; filtro sem resultado com "Limpar filtros"; erro com "Tentar de novo".
- [ ] `VIEWER` vê as listas sem ações.
- [ ] Publicar, destacar, editar e excluir funcionam como antes em cada seção.
- [ ] Navegação completa por teclado nos filtros e nas linhas, com foco visível.
- [ ] Contraste ≥ 4,5:1 em meta, selos e ícones informativos.
- [ ] Sem cor, fonte ou espaçamento solto; o que faltar vira token.
- [ ] `fvm flutter analyze` sem erros novos.

## Fora do escopo
- Formulários (032) e editor de publicação (033).
- Status ativo/inativo de usuário e envio de várias imagens.
- Busca da biblioteca em vários campos ao mesmo tempo (título, autor ou instituição juntos): pediria outra consulta.
- Página pública da biblioteca: não muda.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-07: criada. Decidido com a pessoa: filtros da biblioteca em linha com "Mais filtros" para autor, instituição e ano.
- 2026-10-07: aprovada.
