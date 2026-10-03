# 017. Biblioteca: detalhe do documento

- **Status:** implementada
- **Item do planejamento:** Fase 4: detalhe do documento (T-07), metadados e visualizador
- **Protótipo:** aba "Documento"; aba "Estados" para esqueleto e erro (link no CLAUDE.md)
- **Criada em:** 2026-10-02
- **Depende de:** [016-biblioteca-indice-lista](../016-biblioteca-indice-lista/spec.md) (lista que leva ao detalhe, linhas e etiquetas), [010-leitura-manifesto](../010-leitura-manifesto/spec.md) (migalhas), [011-nossa-historia-pessoa](../011-nossa-historia-pessoa/spec.md) (caixa de erro, 404), [012-post-base](../012-post-base/spec.md) (cabeçalho em coluna, esqueleto, estados)

## Objetivo
Quem abre uma tese ou dissertação vê de cara o tipo, o título e a ficha (autor, instituição, ano, categorias), abre o arquivo em outra aba ou folheia as páginas logo abaixo, no desenho novo do site. Documentos com endereço problemático no banco passam a abrir, e os que não existem mostram a 404 em vez de um erro genérico.

## Situação atual
- [library_document_detailed_page.dart](../../../lib/app/features/library/presentation/pages/library_document_detailed_page.dart) (`/biblioteca/:area/documento/:slug`): navbar, botão laranja "Voltar", título grande em laranja, "mês de ano por autor" em cinza claro (data de cadastro), o visualizador e, abaixo, a ficha em duas colunas (centralizada no celular). Usa `num_extension` e o `LibraryStore`, compartilhado com o painel.
- [library_document_viewer.dart](../../../lib/app/features/library/presentation/components/document/library_document_viewer.dart): caixa com a altura da janela; "Baixar Documento" no topo (abre o arquivo em outra aba **e** baixa de novo o arquivo inteiro); página do PDF; "1/148" e setas anterior/próxima. Carregando com círculo; erro com o texto "Error ao carregar o documento" por cima da página. Sem arquivo, busca um endereço vazio.
- Carregando com círculo; erro **e** documento inexistente mostram o mesmo "Erro ao carregar a página", sem tentar de novo. A área da URL é ignorada (`/biblioteca/xyz/documento/...` abre normalmente).
- **Endereço do documento:** a lista (016) e o card do painel montam o endereço com o slug como está gravado, sem codificar. O slug é texto livre no painel; ao menos um documento de Geografia em prod tem o resumo gravado no slug (texto longo, com espaços e pontuação). O detalhe dele mostra "Erro ao carregar a página": `?`, `#` ou `/` no texto cortam ou desviam o endereço, e a busca pelo slug não encontra o documento.
- **Painel:** o card da lista do painel (`LibraryDocumentCard`) leva a este mesmo endereço público. Os componentes do detalhe (`LibraryDocumentContent`, `LibraryDocumentMetadata`, `LibraryDocumentViewer`) só são usados por esta página.

## Comportamento

Navbar, conteúdo e rodapé (na base da janela quando a página é curta). Conteúdo numa coluna centralizada de até 920 px (com as margens), fundo branco, sem a faixa de cabeçalho em superfície (como no protótipo e no post).

### Cabeçalho
1. **Migalhas:** "Início" (Home) › "Biblioteca" (entrada) › área do documento ("Geografia" ou "História", abre a lista da área) › "Documento" (página atual). Quebram linha em tela estreita. Sai o botão "Voltar".
2. **Selo do tipo** ("Tese", "Dissertação"), o mesmo da linha da lista. Some sem tipo.
3. **Título** (`h1`) como está cadastrado, fonte de títulos, cor de tinta (sai o laranja).
4. **Ficha**, entre duas linhas finas, em grade que se ajusta à largura:
   - "AUTOR", "INSTITUIÇÃO", "ANO", "TIPO DE PRODUÇÃO" (rótulo pequeno em caixa alta, cor secundária; valor no tamanho do texto, cor de tinta);
   - "CATEGORIAS" na largura toda, com as etiquetas da linha da lista (todas, quebrando linha).
   - Campo vazio ou ausente não aparece (sem rótulo solto). A instituição aparece como está gravada.
   - Sai a linha "mês de ano por autor" (o ano já está na ficha).
5. **Ação:** botão principal "Abrir documento", com ícone de link externo, que abre o arquivo em outra aba. Some quando o documento não tem arquivo. Sai "Baixar Documento" (o visualizador do navegador, aberto pelo botão, já baixa o arquivo).

### Visualizador
Abaixo da ação, na largura da coluna:
- Caixa com borda e cantos arredondados, fundo de superfície.
- **Barra no topo**, em fundo branco: à esquerda, "Página 3 de 148" (antes de saber o total, "Página 1"); à direita, botões "Página anterior" e "Próxima página" (ícones com nome acessível e dica). "Página anterior" desativado na primeira página; "Próxima página" desativado na última.
- **Página** do PDF centralizada no fundo de superfície, com sombra leve, na largura disponível até 560 px e com a proporção da própria página (sem cortar nem distorcer). Uma página por vez; a troca é imediata com movimento reduzido.
- Sem zoom e sem tela cheia: "Abrir documento" cumpre esse papel.

## Estados
- **Carregando (página):** migalhas prontas; esqueleto do selo, de duas linhas de título, da ficha (quatro pares de barras) e do botão; caixa do visualizador vazia. Anunciado "Carregando". Parado (sem animação), como na 016.
- **Não encontrado:** a 404 atual (como na 011 e na 012) quando a área da URL não é `geografia` nem `historia` ou quando nenhum documento corresponde ao endereço. Sem ficar carregando para sempre.
- **Erro (página):** caixa de erro da 011 ("Não foi possível carregar", "Verifique sua conexão e tente novamente.", "Tentar de novo") no lugar do conteúdo, abaixo das migalhas; "Tentar de novo" busca de novo.
- **Carregando (visualizador):** ficha e botão prontos; na caixa, uma folha vazia na proporção A4 com "Carregando documento…" e a barra com "Página 1" e botões desativados.
- **Erro no visualizador** (arquivo não baixa ou não é um PDF legível): na caixa, caixa de estado de erro "Não foi possível exibir o documento" e "Use “Abrir documento” para ver o arquivo em outra aba.", com "Tentar de novo". A ficha e "Abrir documento" continuam.
- **Sem arquivo:** no lugar do visualizador, caixa de estado neutra "Arquivo indisponível" e "O arquivo deste documento ainda não foi enviado."; sem "Abrir documento". Nenhuma requisição a endereço vazio.
- **Casos de borda:** título muito longo (quebra linha, sem reticências); só autor preenchido (ficha com um item); sem categorias (sem a linha "CATEGORIAS"); 1 e muitas categorias; PDF de 1 página (os dois botões desativados) e de 300+ páginas; área da URL diferente da do documento (mostra o documento, migalhas com a área do documento); slug com espaços, acentos, `?`, `#`, `/` ou `%` (ver "Endereço do documento").

## Endereço do documento
Sem mudar a rota nem os dados:
- **Na lista pública (016):** a linha passa a codificar o slug no endereço, para que qualquer caractere chegue inteiro ao detalhe. Quando o slug não serve como endereço (tem espaço ou quebra de linha em qualquer posição, inclusive no fim, tem `/`, ou passa de 200 caracteres), a linha usa o identificador do documento no lugar do slug, no mesmo formato de rota (`/biblioteca/:area/documento/:id`).
- **No detalhe:** procura primeiro pelo slug igual ao trecho do endereço; se não achar, procura um documento com esse identificador. Nenhum dos dois: 404.
- Endereços já compartilhados com slug continuam abrindo como hoje.
- O card do painel não muda (continua montando o endereço com o slug cru).

## Responsivo
- **Celular (390):** margens de 20 px; ficha em uma coluna (pares rótulo/valor um abaixo do outro); "Abrir documento" na largura toda; página do PDF na largura da caixa menos uma folga; barra do visualizador em uma linha ("Página 3 de 148" à esquerda, botões à direita).
- **Tablet (768):** margens de 32 px; ficha em duas ou três colunas; botão no tamanho do texto.
- **Desktop (1280):** coluna de 920 px; ficha em quatro colunas (autor, instituição, ano, tipo) e categorias na linha de baixo; página do PDF com até 560 px.
- Em todas: sem rolagem horizontal, sem `overflow`; rodapé na base com conteúdo curto (ex.: estado de erro).

## Acessibilidade
- `h1` no título. Migalhas como navegação "Você está em", página atual sem link.
- Ficha lida como pares ("Autor, Nome Sobrenome"); etiquetas de categoria lidas como texto.
- "Abrir documento" anuncia que abre em outra aba ("Abrir documento em outra aba").
- Visualizador como região "Visualizador do documento"; a página lida como "Página 3 de 148 do documento"; a mudança de página anunciada; botões com nome, dica e estado desativado.
- Ordem de Tab: navbar → migalhas → "Abrir documento" → "Página anterior" → "Próxima página" → "Tentar de novo" (se houver) → rodapé. Foco visível em todos.
- Contraste ≥ 4,5:1 em migalhas, selo, rótulos e valores da ficha, etiquetas, "Página X de N" e textos de estado; nada em cinza claro (sai o `gray` da data).
- Movimento reduzido: troca de página sem animação; esqueleto parado.

## Dados e regras de negócio
- Documento da coleção `library`, lido pelo slug e, sem resultado, pelo identificador do documento. Arquivo pelo `documentUrl` (PDF no Storage).
- `LibraryDocumentModel`, enums, coleções, regras e índices do Firebase não mudam; nenhum dado é corrigido (o slug com o resumo continua gravado). A busca por identificador é uma leitura direta do documento e não pede índice.
- Rotas não mudam (`/biblioteca/:area/documento/:slug`): o identificador ocupa o mesmo parâmetro.
- O painel não muda: `LibraryStore`, `LibraryListPage`, `LibraryDocumentCard`, `Filters`, o diálogo e o `FilterDocumentsStore` ficam como estão. O detalhe deixa de usar o `LibraryStore`.

## Critérios de aceite
1. [ ] O detalhe mostra navbar, migalhas "Início › Biblioteca › [Área] › Documento" (com "Biblioteca" e a área levando à entrada e à lista), selo do tipo, `h1` com o título em cor de tinta, ficha, "Abrir documento", visualizador e rodapé, numa coluna de até 920 px; sem "Voltar", sem a linha "mês de ano por autor" e sem "Baixar Documento".
2. [ ] Ficha com rótulos em caixa alta e valores; campos vazios omitidos; categorias como etiquetas na largura toda, todas visíveis; sem tipo, sem selo.
3. [ ] "Abrir documento" abre o arquivo em outra aba (clique e Enter), com foco visível e nome que diz que abre em outra aba; some sem arquivo.
4. [ ] Visualizador: barra com "Página X de N", "Página anterior" e "Próxima página" (desativados nas pontas), página do PDF inteira na proporção dela, até 560 px; troca de página por clique e teclado, anunciada; sem animação com movimento reduzido.
5. [ ] Estados do visualizador: folha "Carregando documento…" enquanto baixa; erro com "Não foi possível exibir o documento" e "Tentar de novo" (que tenta de novo), mantendo ficha e botão; sem arquivo, "Arquivo indisponível" sem requisição a endereço vazio.
6. [ ] Carregando a página: esqueleto parado do selo, título, ficha e botão, anunciado "Carregando".
7. [ ] Erro na página: caixa de erro com "Tentar de novo" que busca de novo; nunca carrega para sempre.
8. [ ] Não encontrado: área inválida na URL e endereço sem documento mostram a 404 atual.
9. [ ] Endereço: a linha da lista codifica o slug; slug com espaço, quebra de linha, `/` ou mais de 200 caracteres leva pelo identificador; o detalhe acha pelo slug e, sem resultado, pelo identificador. O documento de Geografia com o resumo no slug abre o detalhe a partir da lista (conferido em prod, só leitura); um slug comum continua com o mesmo endereço de antes.
10. [ ] Área da URL diferente da do documento: o documento aparece, com a área dele nas migalhas.
11. [ ] Painel sem mudança: `LibraryStore`, `LibraryListPage`, `LibraryDocumentCard` e o diálogo sem diff (conferido no código; no app, se houver acesso de teste).
12. [ ] Contraste ≥ 4,5:1 nos textos listados em "Acessibilidade"; ordem de Tab conforme "Acessibilidade", com foco visível; ficha lida como pares; visualizador como região com a página anunciada.
13. [ ] Em 390, 768 e 1280 px conforme "Responsivo", com documento real, estado de erro e sem arquivo: sem rolagem horizontal, sem sobreposição e sem `overflow`, em release e em debug; rodapé na base com conteúdo curto.
14. [ ] Código novo usa só tokens de `lib/app/theme/`, não usa `num_extension` nem `GestureDetector` solto; rotas só por `AppRoutes`; nenhum pacote novo; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- "Copiar citação" (Q-08, ideia futura 9.2).
- Compartilhar o documento (o protótipo não tem), zoom, tela cheia, miniaturas e busca dentro do PDF.
- Resumo do documento: não existe campo para isso; o texto gravado no slug não é exibido.
- Corrigir os dados (slug com o resumo, registros em maiúsculas), validar o slug no painel ou mudar o card do painel (ajustes do painel).
- Título da aba do navegador; documentos relacionados; seção de parceiros/Apoio (o protótipo não tem e a 016 tirou da biblioteca).
- Apagar `LibraryStore.fetchDocumentBySlug`, os componentes antigos do detalhe ou o pacote `file_saver` (limpeza da Fase 7).
- Mudar modelos, regras, índices, rotas ou o painel. Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Botão "← Geografia".** Decidido no modo autônomo: não entra (sai também o "Voltar"), porque as migalhas ao lado já levam à área, como na 011 ("← Equipe"); o "Voltar" com `pop` não guarda os filtros da lista (016 não os guarda).
  - **Migalhas com "Início".** Decidido no modo autônomo: "Início › Biblioteca › [Área] › Documento", porque todas as migalhas do site (010, 012, 016) começam em "Início"; o protótipo omite só nesta tela.
  - **Ação "Abrir documento" sem "Baixar".** Decidido no modo autônomo: só "Abrir documento", como no protótipo; o "Baixar Documento" atual já abre o arquivo em outra aba e ainda baixa tudo de novo pelo site, e o leitor de PDF do navegador tem o próprio botão de baixar.
  - **Visualizador sem zoom e tela cheia.** Decidido no modo autônomo: barra com página e anterior/próxima (o que o site já faz), porque o protótipo diz "sem novidades além do layout" e "Abrir documento" já dá a tela cheia do navegador; zoom pediria rolagem dentro da página do PDF.
  - **Coluna de 920 px sem faixa de cabeçalho.** Decidido no modo autônomo: como no protótipo (coluna mais larga que a do post para caber a ficha em quatro colunas e a página do PDF).
  - **Ficha acima do visualizador e "Tipo de produção" mantido.** Decidido no modo autônomo: ordem e campos do protótipo; o selo repete o tipo, mas é o mesmo da lista e ajuda a reconhecer o documento.
  - **Data de cadastro.** Decidido no modo autônomo: sai, porque o protótipo não tem e "mês de ano por autor" confunde o cadastro com a defesa; o ano fica na ficha.
  - **Documento inexistente.** Decidido no modo autônomo: a 404 atual, como na 011 e na 012 (redesenho da 404 na Fase 5).
  - **Área da URL.** Decidido no modo autônomo: área inválida dá 404 (como a lista da 016); área válida diferente da do documento mostra o documento com a área dele, porque o endereço pode ter sido montado errado em links antigos e o documento existe.
  - **Slug com o resumo (dado de prod).** Decidido no modo autônomo: tratar no site sem mexer no dado: a lista codifica o slug e, quando ele não serve como endereço, usa o identificador do documento no mesmo parâmetro; o detalhe tenta slug e depois identificador. Mantém os endereços bons, não muda rota nem modelo, e o painel (que monta o endereço cru) segue como está.
  - **Limite de 200 caracteres.** Decidido no modo autônomo: slugs gerados a partir de títulos longos ficam abaixo disso; um resumo passa com folga.
  - **Store próprio do detalhe.** Decidido no modo autônomo: o detalhe deixa o `LibraryStore`, porque ele é do painel e o painel não pode mudar (mesmo caminho da 016).
  - **Sem compartilhar.** Decidido no modo autônomo: o protótipo não tem compartilhar no documento e a 013 é do post; fica fora.

## Histórico de mudanças
- 2026-10-02: criada e aprovada no modo autônomo (execução da Fase 4).
- 2026-10-02: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-10-02: diagnóstico em prod (só leitura): são 12 documentos com o resumo no slug (Geografia e História), todos terminando em espaço; a lista aparava o slug e a busca não achava, além do `/` em 5 deles. A regra do identificador vale para o slug como está gravado (espaço em qualquer posição, inclusive no fim). Sem mudança de comportamento.
- 2026-10-02: implementação: o visualizador desenha as páginas direto com o `pdfx`, sem o `PdfView` (que traz zoom e animação); o botão principal ganhou a opção de ocupar a largura toda. Sem mudança de comportamento.
- 2026-10-02: implementada (modo autônomo). Sem arquivo, o aviso ocupa o lugar do visualizador, sem a moldura.
