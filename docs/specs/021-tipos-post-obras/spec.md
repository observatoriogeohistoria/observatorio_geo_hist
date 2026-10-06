# 021. Tipos de post: livro, filme, revista, documento e produção acadêmica

- **Status:** implementada
- **Item do planejamento:** Fase 5: T-08 e P-08 (tipos de obra com ficha)
- **Protótipo:** aba "Tipos de post" (Livro, Filme e a tabela dos demais); aba "Documento" para a ficha; aba "Post" para cabeçalho e compartilhar (link no CLAUDE.md)
- **Criada em:** 2026-10-05
- **Depende de:** [012-post-base](../012-post-base/spec.md) (página, estados, Apoio, ponto único por tipo), [013-compartilhamento-post](../013-compartilhamento-post/spec.md) (compartilhar), [017-biblioteca-documento](../017-biblioteca-documento/spec.md) (ficha e selo), [020-estados-especiais](../020-estados-especiais/spec.md) (404, esqueleto)

## Objetivo
Quem abre um livro, filme, revista, documento ou produção acadêmica vê, no desenho novo, o título, a ficha da obra, a imagem com proporção fixa e o botão para acessá-la, e lê a sinopse ou descrição na mesma coluna do artigo. Os cinco tipos passam a compartilhar as mesmas peças, que a 022 reaproveita.

## Situação atual
- [post_type_content.dart](../../../lib/app/features/posts/presentation/components/post/post_type_content.dart) escolhe o conteúdo pelo tipo. Só o artigo usa o layout-base; os cinco tipos desta spec usam o `*_content.dart` antigo em [post_content/](../../../lib/app/features/posts/presentation/components/post_content/).
- Desenho antigo dos cinco: imagem à esquerda (`AppNetworkImage`, com o erro de imagem antigo, sem proporção fixa e sem placeholder quando falta), botão "Acesse" embaixo dela, título em caixa alta laranja, categoria em cinza, linhas "Rótulo: valor" em laranja. Usa `num_extension` e os textos antigos. Sem migalhas e sem compartilhar.
- Já existem: página, estados e Apoio da 012; compartilhar da 013 (`PostShare`); ficha e selo da biblioteca (017, privados da feature `library`).
- Campos (não mudam):
  - **Livro:** título, imagem, categoria (Livro, Ebook), autor, ano (número), editora, sinopse (texto simples), link.
  - **Filme:** título, imagem, categoria (Filme, Documentário, Curta Metragem, Série), ano de lançamento, duração (texto livre), direção, país, sinopse (editor rico), link.
  - **Revista:** título, imagem, categoria (Revista, Dossiê), chamada (opcional), descrição (texto simples), link.
  - **Documento:** título, imagem, categoria (13 valores, de Decreto a Site), descrição (editor rico), link.
  - **Produção acadêmica:** título, imagem, categoria (Artigo, Dissertação, Monografia, Tese), autor, orientador, instituição, cidade e ano (texto livre, ex.: "São Paulo, 2021"), resumo (texto simples), palavras-chave (texto separado por vírgulas), link.
- O Firebase de prod tem livro, filme, revista e documento; nenhum banco tem produção acadêmica (conferência da 012).

## Comportamento

### Estrutura (os cinco tipos)
Navbar, **cabeçalho da obra** (largura de 820 px com as margens, a mesma do cabeçalho do artigo), **texto** na coluna de leitura de 680 px, **Apoio** e rodapé. Sem Leia também (só no artigo).

### Cabeçalho da obra
De cima para baixo:
1. **Migalhas:** "Início" › área (texto sem link) › categoria (abre a categoria) › nome do tipo ("Livro", "Filme", "Revista", "Documento", "Produção acadêmica"), como no artigo.
2. **Bloco da obra**, com a imagem ao lado dos dados ou acima deles (ver "Imagem" e "Responsivo"). Os dados, de cima para baixo:
   - **Selo** com a categoria da obra ("Ebook", "Documentário", "Dossiê", "Decreto", "Tese"), no desenho do selo da biblioteca.
   - **Título** (`h1`) como está cadastrado, fonte de títulos, cor de tinta (sai o laranja em caixa alta).
   - **Chamada** (só revista, se houver), abaixo do título, no estilo do subtítulo do artigo.
   - **Ficha** entre duas linhas finas, no desenho da ficha da biblioteca (rótulo pequeno em caixa alta e cor secundária, valor em cor de tinta, grade que se ajusta à largura). Campo vazio não aparece; sem nenhum campo, a ficha some.
   - **Ação principal:** botão primário com ícone de link externo, que abre o link em outra aba. Some quando o link está vazio.
3. **Compartilhar** (o mesmo `PostShare` do artigo), numa linha logo abaixo do bloco, entre duas linhas finas, alinhado à esquerda.

### Por tipo
| Tipo | Imagem | Ficha | Ação | Texto |
|---|---|---|---|---|
| Livro | Capa 2:3 | Autoria, Ano, Editora | "Acessar livro" | Sinopse |
| Revista | Capa 2:3 | (nenhuma) | "Acessar revista" | Descrição |
| Filme | Cartaz 16:9 com "Assistir" | Direção, País, Ano, Duração | "Assistir" no cartaz | Sinopse |
| Documento | Sem imagem | (nenhuma) | "Acessar documento" | Descrição |
| Produção acadêmica | Sem imagem | Autoria, Orientação, Instituição, Cidade e ano; Palavras-chave na largura toda | "Acessar produção" | Resumo |

- **Ano** do livro e do filme: aparece só se for maior que zero.
- **Palavras-chave:** o texto é dividido nas vírgulas e nos pontos e vírgulas; cada termo (sem espaços nem ponto final nas pontas, vazios descartados) vira uma etiqueta no desenho das categorias da biblioteca.
- **Filme:** o cartaz traz, centralizado, o botão em pílula "Assistir" com ícone de reproduzir (o do protótipo), que abre o link em outra aba. Sem link, o cartaz fica sem botão. Não há player embutido.
- **Documento e produção acadêmica** não mostram imagem na página (como a ficha da biblioteca, no protótipo); a imagem continua nos cards da listagem.

### Imagem
- Proporção fixa, preenchida sem distorcer (recorte centralizado), cantos arredondados, fundo de superfície enquanto carrega.
- **Capa 2:3** (livro, revista): 180 px de largura, à esquerda dos dados no tablet e no desktop; no celular, acima dos dados, com 180 px, alinhada à esquerda. Sombra leve, como no protótipo.
- **Cartaz 16:9** (filme): no desktop e no tablet, duas colunas (cartaz um pouco mais largo que os dados); no celular, na largura toda, acima dos dados.
- **Sem imagem ou com falha:** placeholder na mesma proporção, laranja suave com ícone decorativo (o do post). No filme, "Assistir" continua sobre o placeholder.

### Texto
Na coluna de leitura de 680 px, abaixo do cabeçalho, com o espaço de topo do artigo:
- Começa com um subtítulo de leitura (nível 2): "Sinopse" (livro, filme), "Descrição" (revista, documento) ou "Resumo" (produção acadêmica).
- **Editor rico** (sinopse do filme, descrição do documento): mesmo tratamento do texto do artigo (012). Se o campo não for um delta válido (texto simples gravado antes do editor), aparece como texto simples, sem quebrar.
- **Texto simples** (sinopse do livro, descrição da revista, resumo): parágrafos no estilo de leitura; cada quebra de linha do texto separa parágrafos; linhas em branco seguidas não somam espaço.
- Texto vazio: o subtítulo e o texto somem.

### O que sai
O desenho antigo desses cinco tipos sai da página: os cinco `*_content.dart` correspondentes são apagados, e eles deixam de usar o erro de imagem antigo. O erro de imagem antigo continua existindo para quem ainda o usa (tipos da 022, Home e painel).

## Estados
- **Carregando, não encontrado e erro:** os da 012 e da 020, sem mudança (esqueleto do post, 404, caixa de erro com "Tentar de novo"). O esqueleto continua no formato do artigo, porque o tipo só se sabe quando o post chega.
- **Sem imagem / imagem com falha:** placeholder (ver "Imagem").
- **Casos de borda:** título muito longo e nomes longos quebram linha sem cortar; categoria com nome longo nas migalhas e no selo ("Documento Normativo", "Curta Metragem"); ficha com 1 campo e com todos; palavras-chave com 1, muitas, vírgulas sobrando ou termo longo (quebra dentro da etiqueta); duração ou "cidade e ano" em formato livre (aparece como veio); revista sem chamada; link vazio (sem botão; no filme, sem "Assistir"); texto vazio; texto simples com várias linhas; imagem muito alta ou muito larga (recorte).

## Responsivo
- **Celular (390):** margens de 20 px; imagem acima dos dados (capa com 180 px; cartaz na largura toda); ficha em uma coluna; botão principal na largura toda; compartilhar no formato de celular da 013.
- **Tablet (768):** margens de 32 px; capa à esquerda dos dados; cartaz e dados em duas colunas; ficha em duas colunas ou mais, conforme a largura.
- **Desktop (1280):** cabeçalho em ~756 px centralizado; mesmo arranjo do tablet com mais largura; texto na coluna de 680 px.
- Em todas: sem rolagem horizontal, sem sobreposição e sem `overflow`.

## Acessibilidade
- Título como `h1`; "Sinopse", "Descrição" e "Resumo" como nível 2. Migalhas como na 012.
- Imagem com nome "Capa de [título]" (livro, revista) ou "Cartaz de [título]" (filme); placeholder decorativo.
- Ficha lida como pares ("Direção, Nome Sobrenome"); palavras-chave lidas como "Palavras-chave, termo 1, termo 2".
- Botões anunciam que abrem em outra aba ("Acessar livro em outra aba", "Assistir a [título] em outra aba").
- Selo lido como texto.
- Ordem de Tab: navbar → migalhas → ação principal ("Assistir" no filme) → compartilhar → rodapé do Apoio e rodapé. Foco visível em todos.
- Contraste ≥ 4,5:1 em migalhas, selo, rótulos e valores da ficha, etiquetas, chamada e texto; "Assistir" legível sobre qualquer imagem (pílula de fundo claro opaco, como no protótipo).
- Movimento reduzido: nenhum movimento novo.

## Dados e regras de negócio
- Mesmos dados e estados da página do post (012). Modelos (`PostModel`, `BookModel`, `FilmModel`, `MagazineModel`, `DocumentModel`, `AcademicProductionModel`), enums, coleções, regras e índices do Firebase não mudam. Nenhum dado é corrigido.
- Rotas não mudam. O painel não muda.
- Podcast, música, evento e pesquisa continuam com o conteúdo antigo (spec 022).

## Critérios de aceite
1. [ ] Livro, filme, revista, documento e produção acadêmica mostram, nesta ordem: navbar, migalhas "Início › [Área] › [Categoria] › [Tipo]", bloco da obra, linha de compartilhar, texto na coluna de 680 px, Apoio e rodapé; sem Leia também.
2. [ ] Bloco da obra com selo da categoria, título `h1` em cor de tinta (sem caixa alta forçada) e, na revista com chamada, a chamada abaixo do título.
3. [ ] Ficha de cada tipo com os rótulos da tabela "Por tipo", no desenho da ficha da biblioteca; campos vazios (e ano 0) omitidos; sem campos, sem ficha.
4. [ ] Produção acadêmica: palavras-chave separadas nas vírgulas e nos pontos e vírgulas, como etiquetas na largura toda, sem etiqueta vazia.
5. [ ] Botão principal com o texto da tabela abre o link em outra aba por clique e Enter; com link vazio, some. No filme, "Assistir" sobre o cartaz faz o mesmo e some sem link.
6. [ ] Capa 2:3 (livro, revista) e cartaz 16:9 (filme) preenchidos sem distorcer, com cantos arredondados; documento e produção acadêmica sem imagem.
7. [ ] Sem imagem e com falha forçada, placeholder na mesma proporção; o filme mantém "Assistir" sobre ele.
8. [ ] Texto com o subtítulo do tipo; editor rico com o estilo do artigo, e texto não-delta mostrado como texto simples; texto simples com parágrafos nas quebras de linha; texto vazio sem subtítulo.
9. [ ] Compartilhar é o mesmo do artigo (opções e destinos da 013), com foco visível e nome acessível.
10. [ ] Esqueleto, 404 e caixa de erro continuam como na 012/020 para esses tipos.
11. [ ] Acessibilidade conforme a seção: `h1` e nível 2, nomes das imagens, ficha em pares, botões "em outra aba", ordem de Tab, contraste ≥ 4,5:1.
12. [ ] Em 390, 768 e 1280 px conforme "Responsivo": sem rolagem horizontal, sobreposição ou `overflow` (inclusive em modo debug); título, nomes, selo e migalhas longos quebram linha.
13. [ ] Podcast, música, evento, pesquisa e artigo continuam abrindo como antes, sem erro no console.
14. [ ] A biblioteca (detalhe do documento e linhas da lista) continua igual depois de a ficha, o selo e as etiquetas passarem a ser compartilhados.
15. [ ] Código novo só com tokens de `lib/app/theme/`, sem `num_extension` e sem `GestureDetector` solto; os cinco `*_content.dart` antigos apagados, sem `AppNetworkImage` nesses tipos; `docs/arquitetura.md` atualizado; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro; nenhum modelo, rota, regra do Firebase ou arquivo do painel alterado.

## Fora do escopo
- Podcast, música, evento e pesquisa (spec 022, que reaproveita o bloco da obra, a ficha, a imagem com placeholder, a linha de compartilhar e o texto desta spec).
- Leia também nos tipos que não são artigo.
- Player de vídeo embutido no filme.
- Esqueleto por tipo.
- Apagar o erro de imagem antigo (`ImageErrorContent`, `AppNetworkImage`), `ArticleContent`, `ViewQuill` ou `SocialIcons` (outros ainda usam ou ficam para a Fase 7).
- Mudar modelos, painel, rotas, regras do Firebase; criar conteúdo de teste pelo painel.
- Painel administrativo, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Divisão 021/022.** Decidido no modo autônomo: mantida (obras com ficha aqui; podcast, música, evento e pesquisa na 022), porque as peças compartilhadas (bloco, ficha, imagem, compartilhar, texto) nascem aqui com cinco tipos que as exercitam e a 022 só acrescenta o player, a caixa de data e a pílula de situação.
  - **Cabeçalho comum.** Decidido no modo autônomo: migalhas, bloco da obra e linha de compartilhar, com o texto na coluna de leitura abaixo, porque o protótipo diz que todos os tipos compartilham cabeçalho, coluna e ações; a sinopse curta do protótipo dentro do bloco não cabe bem em resumos longos.
  - **Categoria da obra.** Decidido no modo autônomo: selo acima do título (desenho da biblioteca), também no filme (o protótipo a põe na ficha), para os cinco tipos terem o mesmo lugar; no livro de categoria "Livro" o selo repete o tipo das migalhas, o que foi aceito.
  - **Documento e produção acadêmica sem imagem.** Decidido no modo autônomo: seguem a tabela do protótipo ("ficha simples" e "mesma ficha do documento da biblioteca"), que não tem imagem; ela continua nos cards.
  - **Filme.** Decidido no modo autônomo: "Assistir" sobre o cartaz, sem botão duplicado nem player embutido, como no protótipo; o link é externo e não se sabe se é vídeo.
  - **Rótulos.** Decidido no modo autônomo: "Autoria" e "Orientação" (neutros, como "Orientação" da pesquisa no protótipo) e "Cidade e ano" (o campo é livre); textos dos botões "Acessar livro/revista/documento/produção".
  - **Subtítulo do texto.** Decidido no modo autônomo: "Sinopse", "Descrição" ou "Resumo" como nível 2, porque o texto fica separado do bloco e o leitor de tela precisa saber o que é.
  - **Texto que não é delta.** Decidido no modo autônomo: mostrado como texto simples, porque o `ReadingRichText` esconderia campos antigos gravados sem o editor.
  - **Componentes antigos.** Decidido no modo autônomo: apagar os cinco `*_content.dart` que esta spec substitui (como a 020 fez com os que ficaram sem uso); o erro de imagem antigo fica, porque a 022, a Home e o painel ainda o usam.
  - **Ficha e selo da biblioteca.** Decidido no modo autônomo: passam a ser componentes compartilhados, sem mudar o desenho da biblioteca, para não duplicar o código.
  - **Conferência.** Decidido no modo autônomo: livro, filme, revista e documento num build de prod só leitura; produção acadêmica, sem post em nenhum banco, por dados injetados num build temporário fora do repositório ou, se não der, registrada como não conferida. Nada é criado pelo painel.

## Histórico de mudanças
- 2026-10-05: criada e aprovada no modo autônomo (execução da Fase 5).
- 2026-10-05: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-10-05 (implementação, modo autônomo): o prod já tem produções acadêmicas, e a real separa as palavras-chave com ponto e vírgula e termina com ponto ("Educação online; Curadoria digital; Tecnologias educacionais."). Divididas só nas vírgulas, viravam uma etiqueta única. Decidido: dividir também em `;` e tirar o ponto final de cada termo.
- 2026-10-05 (implementação, modo autônomo): quando a ficha é o último item do bloco (filme, ou livro sem link) e o bloco está empilhado (celular, ou tipo sem imagem), a linha de compartilhar não repete a linha de cima: a de baixo da ficha já a separa, e duas linhas seguidas pareciam uma faixa vazia.
- 2026-10-06: implementada (`fd293ca`, `18aa574`). Conferida num Chrome sem janela por CDP, com build `APP_ENV=prod` só leitura (livro, filme, revista, documento e produção acadêmica reais; artigo, podcast, música, evento e pesquisa sem mudança; detalhe e lista da biblioteca; vídeo da Home) e um build temporário com dados injetados fora do repositório (imagem vazia e quebrada, link vazio, ano 0, sinopse não-delta, texto em várias linhas, palavras-chave irregulares, título longo, erro de rede). Debug sem `overflow`. Sem conferir: painel (sem diff e sem credenciais de teste), leitor de tela real (só a árvore semântica) e contraste medido (usa tokens já conferidos). Dado observado: a descrição de um documento do prod tem quebras de linha no meio das frases (texto colado de PDF); aparece como foi gravada.
