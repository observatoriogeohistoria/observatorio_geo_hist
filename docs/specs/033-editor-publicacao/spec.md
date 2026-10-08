# 033. Editor de publicação em página própria

- **Status:** aprovada
- **Item do planejamento:** Fase 8, item 8.5 (T-14)
- **Protótipo:** aba "Editor" (link no CLAUDE.md)
- **Criada em:** 2026-10-07

## Objetivo
Criar e editar uma publicação passa a ser feito numa página própria, com o texto à esquerda e situação, onde aparece, imagem e autoria à direita. Publicar, salvar e despublicar ficam numa barra sempre visível, e um resumo diz o que falta antes de salvar.

## Situação atual
- "Criar" e "Editar" de publicações abrem `create_or_update_post_dialog.dart`, um diálogo com área (interruptores História/Geografia) e categoria. "Criar"/"Atualizar" fecha esse diálogo e abre um segundo, em tela cheia, com os campos do tipo (`create_or_update_posts_dialogs/*`, base em `post_form_dialog.dart`).
- Publicação nova nasce despublicada e sem destaque; publicar e destacar só pela lista.
- Faltando texto ou imagem, aparece um aviso flutuante ("Preencha o conteúdo do post"). Os demais erros ficam nos campos, que podem estar fora da tela.
- Campos do artigo: título, subtítulo, imagem, legenda da imagem, data (MM/AAAA), autores (adicionar e remover o último), conteúdo e observação (os dois no editor de texto Quill). Todos obrigatórios, menos a observação.
- No Quill, o Tab faz recuo e prende o foco do teclado.

## Comportamento

### Endereços
Decididos com a pessoa, em português:
- Nova: `/admin/painel/publicacoes/nova?tipo=artigos` (os 10 valores de `tipo` de hoje).
- Editar: `/admin/painel/publicacoes/:categoria/:id/editar`.
- O botão "Novo …" da seção e o "Editar" da linha (031) abrem essas páginas. O endereço pode ser recarregado ou aberto direto: a página carrega a publicação. Publicação inexistente mostra o estado de erro com "Voltar para {tipo}". Quem não pode editar (`VIEWER`) que abrir o endereço vai para a lista do tipo.

### Barra fixa no topo
Fica visível ao rolar (abaixo da faixa de ambiente, sem a barra do painel):
- "← Artigos" (nome do tipo no plural): volta à lista do tipo.
- Título da página: "Novo artigo" / "Editar artigo" (e os equivalentes por tipo, com o gênero certo: "Nova revista", "Editar produção acadêmica").
- Selo de situação: "Publicado" (verde) ou "Não publicado".
- Texto em cinza: "Salvo pela última vez em 12 mar 2026" (data da última alteração) ou "Ainda não salvo".
- Ações à direita, conforme a situação:
  - Não publicada (ou nova): "Salvar rascunho" (secundário) e "Publicar" (principal).
  - Publicada: "Despublicar" (secundário) e "Salvar alterações" (principal).

Cada botão salva o formulário inteiro com a situação correspondente: "Publicar" salva e publica; "Salvar rascunho" salva sem publicar; "Salvar alterações" salva e mantém publicada; "Despublicar" salva e tira do site. Os quatro exigem os mesmos campos obrigatórios de hoje (decidido com a pessoa; o rascunho não aceita campos vazios). Depois de salvar, a página continua aberta, o selo e as ações se atualizam e aparece o aviso curto (030): "Publicado. Já aparece no site.", "Rascunho salvo. Não aparece no site.", "Alterações salvas.", "Despublicado. Continua salvo aqui no painel." Uma publicação nova salva passa ao endereço de edição.

### Coluna principal (artigo)
Em cartões brancos:
1. "Título" em fonte grande de título; "Subtítulo"; "Texto" no editor com barra de formatação acima. A barra mantém os mesmos recursos de hoje, para não perder formatação de textos já salvos, no visual do protótipo (botões de ícone com dica, agrupados).
2. "Observação" opcional, no editor de texto, com a dica "Aparece no bloco “Nota”, ao fim do texto."

Rótulo "opcional" só nos campos que hoje não são obrigatórios. Subtítulo e legenda continuam obrigatórios (o protótipo os marca como opcionais; vale a regra de hoje).

### Coluna lateral
1. **Situação:** "No site" com o selo; interruptor "Destaque na Home", dica "Entra entre os destaques da página inicial." O valor é salvo junto com o botão escolhido.
2. **Onde aparece:** "Área" com caixas História e Geografia; "Categoria" em lista suspensa, só com as categorias das áreas marcadas ("Escolha a categoria" quando vazia). Desmarcar a área da categoria escolhida limpa a categoria. Trocar a categoria de uma publicação existente a move, como hoje.
3. **Imagem:** área 16:10 com "Escolher imagem" / "JPG ou PNG, de preferência na horizontal"; com imagem, mostra a imagem com `cover`, "Cortada em 16:10 nos cards" e "Remover". "Legenda" logo abaixo, nos tipos que têm legenda.
4. **Autoria** (artigo): um campo por autor, botão "×" para remover cada um (só com mais de um), "+ Adicionar autor" (o novo campo recebe o foco) e "Data" (MM/AAAA).

### Outros 9 tipos
A página e a coluna lateral são as mesmas (Situação, Onde aparece, Imagem com legenda quando o tipo tem). A coluna principal troca para os campos do tipo, com os mesmos rótulos e regras de hoje, agrupados em cartões:
- **Livro:** título, autor(a), ano de publicação, editora, chamada/sinopse, link.
- **Filme:** título, ano de lançamento, duração, direção, país, sinopse (editor de texto), link.
- **Revista:** título, chamada, descrição, link.
- **Música:** nome da música, nome do artista, descrição, letra (editor de texto), link.
- **Podcast:** título, descrição, link.
- **Documento:** título, descrição (editor de texto), link.
- **Evento:** título/nome do evento, link, local, data, horário, detalhes.
- **Produção acadêmica:** título, autor, orientador, instituição, cidade e ano, resumo, palavras-chave, link da pesquisa.
- **Pesquisa:** título, legenda da imagem, coordenador(a), pesquisador(a), orientador(a), coorientador(a), descrição, integrantes, financiador.

O cartão Autoria só aparece no artigo. A ordem de entrega é artigo primeiro, depois os outros tipos.

### Resumo do que falta
Ao tentar salvar com campos inválidos, aparece no topo da coluna principal um aviso vermelho "Para publicar, falta preencher:" (ou "Para salvar, falta preencher:") com a lista dos campos, cada um como link que leva o foco e a rolagem ao campo. O foco vai para o aviso. Cada campo também mostra sua mensagem ("Dê um título à publicação.", "Escreva o texto da publicação.", "Marque pelo menos uma área.", "Escolha a categoria.", "Escolha uma imagem. Ela aparece no card e no topo do post.", e as atuais para data, ano e link). Sai o aviso flutuante.

### Sair com alterações não salvas
Decidido com a pessoa: se algo mudou desde a última gravação, "← Voltar", o menu do navegador ou outro link do painel pedem confirmação: "Sair sem salvar?" / "As alterações feitas desde a última vez que você salvou serão perdidas." com "Continuar editando" (foco inicial) e "Sair sem salvar". Fechar ou recarregar a aba usa o aviso padrão do navegador.

### Teclado no editor de texto
Decidido com a pessoa: Tab e Shift+Tab saem do editor de texto para o próximo e o anterior controle. Recuo de lista fica nos botões da barra de formatação.

## Estados
- **Carregando:** ao abrir uma publicação existente, esqueleto das duas colunas. Salvando: botão clicado com "Salvando…", os quatro desabilitados.
- **Vazio:** nova publicação abre com os campos em branco, um campo de autor, área e categoria vazias.
- **Erro:** ao carregar, caixa de erro com "Tentar de novo" e "Voltar para {tipo}"; ao salvar, aviso de erro (030) e os dados ficam na tela.
- **Sem imagem / imagem com falha:** área de escolha com ícone; imagem atual que não carrega mostra o placeholder com "Trocar imagem".
- **Casos de borda:** título muito longo quebra linha na barra (encurta com reticências no celular); 10 autores; texto longo com rolagem da página (a barra fica fixa); nenhuma categoria nas áreas marcadas mostra a lista vazia com "Nenhuma categoria nesta área".

## Responsivo
- **390:** uma coluna (principal e depois a lateral). Na barra, as ações ocupam uma linha inteira, divididas ao meio; some o "Salvo pela última vez".
- **768:** uma coluna; barra com título e ações na mesma linha quando couber.
- **1280:** duas colunas (principal flexível e lateral de largura fixa), largura máxima centralizada.

## Acessibilidade
- Ao abrir, o foco vai para o título da publicação.
- Ordem de Tab: barra (voltar, ações), coluna principal, coluna lateral. Nada prende o foco.
- Botões da barra de formatação com nome e dica; agrupados como barra de ferramentas.
- Interruptor de destaque e caixas de área com nome; erros ligados aos campos; resumo anunciado.
- Contraste ≥ 4,5:1 em rótulos, "opcional", dicas e "Salvo pela última vez".

## Dados e regras de negócio
- Mesmo modelo de publicação, mesmos campos, obrigatoriedades e validações de cada tipo.
- Mudam só: publicar e destacar também podem ser feitos no editor (decidido com a pessoa); a publicação nova pode já nascer publicada.
- Mover de categoria funciona como hoje. As ações da lista (publicar, destacar, excluir) continuam.
- Rotas novas em `AppRoutes`; a lista continua em `/admin/painel/publicacoes?tipo=`.

## Critérios de aceite
- [ ] "Novo artigo" abre `/admin/painel/publicacoes/nova?tipo=artigos`; "Editar" abre `/admin/painel/publicacoes/:categoria/:id/editar`; recarregar a página mantém a publicação.
- [ ] A página reproduz a aba "Editor" do protótipo em 390, 768 e 1280 px, sem `overflow` nem rolagem horizontal; a barra fica fixa ao rolar.
- [ ] Ações certas por situação; cada uma salva o formulário com a situação certa e mostra o aviso curto.
- [ ] Destaque marcado no editor aparece nos destaques da Home depois de salvar.
- [ ] Salvar com campo faltando mostra o resumo com links que levam a cada campo; nenhum aviso flutuante.
- [ ] Categoria lista só as das áreas marcadas; trocar a categoria de uma publicação existente a move.
- [ ] Autores: adicionar, remover cada um e o mínimo de um funcionam.
- [ ] Imagem: escolher, trocar, remover e placeholder em falha funcionam.
- [ ] Os 10 tipos abrem no editor, com os campos de hoje, e criam e editam como antes.
- [ ] Sair com alteração não salva pede confirmação; sem alteração, sai direto.
- [ ] Tab sai do editor de texto; navegação completa por teclado na página.
- [ ] `VIEWER` não abre o editor.
- [ ] Os diálogos antigos de publicação deixam de ser usados.
- [ ] Contraste ≥ 4,5:1; sem cor, fonte ou espaçamento solto.
- [ ] `fvm flutter analyze` sem erros novos.

## Fora do escopo
- Novos campos, novos tipos ou regras de obrigatoriedade.
- Salvamento automático e pré-visualização do post.
- Inserir imagem de Mídias pelo botão do editor de texto (o protótipo só sugere).

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-07: criada. Decidido com a pessoa: seguir o protótipo em Publicar/Salvar rascunho e destaque no editor, mesma validação para todos os botões, rotas `/nova?tipo=` e `/:categoria/:id/editar`, confirmação ao sair sem salvar e Tab saindo do editor de texto.
- 2026-10-07: aprovada.
