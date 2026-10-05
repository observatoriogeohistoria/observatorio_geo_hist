# 019. Colabore

- **Status:** implementada
- **Item do planejamento:** Fase 5, tela T-05 (`/colaborar`); decisão "Rodapé: Colabore" (seção 1) e Q-04
- **Protótipo:** sem aba própria. A aba "Categoria" mostra o botão "Colabore com esta categoria"; o formulário segue a aba "Contato" (link no CLAUDE.md)
- **Criada em:** 2026-10-05
- **Depende de:** [018-fale-com-a-gente](../018-fale-com-a-gente/spec.md) (formulário por e-mail, confirmação e "Copiar mensagem")

## Objetivo
Quem quer publicar no Observatório encontra, numa página só, o que pode enviar e em que condições, e prepara a proposta num formulário que abre o próprio programa de e-mail com a mensagem pronta, faltando só anexar os arquivos.

## Situação atual
- [collaborate_page.dart](../../../lib/app/features/posts/presentation/pages/collaborate_page.dart) (`/colaborar`): foto de fundo escurecida com o título "COLABORE", dois parágrafos longos em branco centralizados, um botão com o e-mail que abre o `mailto:` vazio e o link "clique aqui" (laranja sobre a foto) para as licenças Creative Commons. Depois, "Realização e apoio" e o rodapé.
- Chega-se a ela pelo botão "Colabore com esta categoria" no cabeçalho das categorias com `hasCollaborateOption`. O rodapé não tem mais o link (P-01).
- Usa `num_extension`, cores antigas, texto branco sobre foto (contraste depende da imagem) e não tem migalhas nem formulário.

## Comportamento

Navbar, cabeçalho de página, conteúdo, "Realização e apoio" e rodapé (na base da janela quando a página é curta).

### Cabeçalho
Faixa em superfície, igual à de Fale com a gente:
1. Migalhas "Início › Colabore" (página atual sem link).
2. Título (`h1`) "Colabore".
3. Texto de apoio: "O Observatório é uma plataforma colaborativa. Professores, pesquisadores e estudantes podem publicar artigos de opinião, relatos de experiência e produções acadêmicas, ou sugerir materiais."

Sai a foto de fundo.

### Formulário
Na coluna principal, cinco campos com rótulo visível acima, no mesmo desenho, validação, teclas e comportamento de Fale com a gente (018):

| Campo | Tipo | Regra | Mensagem de erro |
|---|---|---|---|
| Nome completo | uma linha; sugestão do navegador (nome) | não vazio | "Informe seu nome completo." |
| E-mail | uma linha; teclado de e-mail; sugestão do navegador (e-mail) | formato `algo@algo.algo` | "Informe um e-mail válido, como nome@exemplo.com." |
| Instituição (opcional) | uma linha; sugestão do navegador (organização) | nenhuma | — |
| Título da contribuição | uma linha | não vazio | "Informe o título da contribuição." |
| Sobre a contribuição | várias linhas | pelo menos 10 caracteres | "Conte um pouco sobre a contribuição, com pelo menos 10 caracteres." |

Abaixo dos campos:
- Botão principal **"Abrir no meu e-mail"**, com ícone de envelope à esquerda.
- Texto de apoio: "Vamos abrir o seu programa de e-mail com a mensagem já preenchida. Anexe seus arquivos por lá e aperte **Enviar**."

### Envio e confirmação
Com tudo válido, abre o programa de e-mail na mesma aba com:
- **Para:** o e-mail do Observatório (o mesmo do rodapé);
- **Assunto:** "Colaboração: " seguido do título digitado;
- **Corpo:** o texto de "Sobre a contribuição", uma linha em branco e a assinatura: nome, instituição (só quando preenchida) e e-mail, um por linha.

A confirmação é a de Fale com a gente, com um texto próprio:
- título "Seu e-mail está pronto";
- "Abrimos o seu programa de e-mail com a mensagem preenchida. Anexe seus arquivos e aperte **Enviar** por lá para concluir.";
- "Não abriu? Copie a mensagem e escreva para [e-mail do Observatório]." (link `mailto:`);
- "Copiar mensagem" (texto no formato "Para / Assunto / corpo" da 018) e "Voltar ao formulário" (campos mantidos, foco no primeiro campo).

### Antes de enviar
Ao lado do formulário (abaixo no celular e no tablet), caixa em superfície com cantos arredondados, no desenho de "Outros meios" da 018: título "Antes de enviar" e itens com rótulo pequeno em caixa alta:
- **O que enviar:** "Artigos de opinião, relatos de experiência, produções acadêmicas e sugestões de materiais."
- **Arquivos:** "Texto, áudio ou vídeo, em formatos de uso comum, como .pdf, .doc, .odt, .mp3, .mp4 e .jpg."
- **Criações de terceiros:** "Se o seu material usa obras de outras pessoas, confira se os termos de uso permitem a redistribuição."
- **Avaliação:** "Depois de avaliado, o material é publicado no Observatório."
- **Licença:** "Exceto quando indicado, o conteúdo do Observatório segue a licença Creative Commons Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional: pode ser compartilhado e remixado, com atribuição de autoria, para fins não comerciais e sob os mesmos termos." Em seguida, o link "Conheça as licenças Creative Commons", que abre o site das licenças em outra aba.
- **E-mail:** o e-mail do Observatório, como link `mailto:`, para quem prefere escrever direto.

Links na cor de acento forte, sublinhados, como na 018.

### Realização e apoio
A seção "Realização e apoio" continua antes do rodapé, como hoje e como na Home.

## Estados
- **Carregando / vazio / erro de dados:** não se aplicam; a página não busca dados.
- **Erro de validação, confirmação, cópia recusada, programa de e-mail que não abre:** como na 018.
- **Casos de borda:** instituição vazia ou só com espaços (a linha some da assinatura); textos muito longos em todos os campos (sem `overflow`); acentos, emojis, `&`, `?`, `#`, `%` e quebras de linha (chegam inteiros ao e-mail e ao texto copiado); título com "Colaboração:" já digitado (o assunto repete o prefixo, sem tratamento especial); várias tentativas com erro; voltar e enviar de novo.

## Responsivo
Igual à 018:
- **Celular (390):** margens de 20 px; formulário e "Antes de enviar" em uma coluna, nesta ordem; botão na largura toda.
- **Tablet (768):** margens de 32 px; uma coluna; botão no tamanho do texto.
- **Desktop (1280):** duas colunas no conteúdo de até 1120 px, formulário (cerca de 3/5) e "Antes de enviar" (cerca de 2/5), alinhados no topo.
- Em todas: sem rolagem horizontal, sem `overflow`; rodapé na base.

## Acessibilidade
- `h1` no título; migalhas como navegação "Você está em"; "Antes de enviar" como título de nível 2.
- Campos lidos com o rótulo (inclusive "(opcional)") e o erro; foco no primeiro inválido; confirmação anunciada e focada; "Mensagem copiada" e "Erro ao copiar" anunciados (como na 018).
- Ordem de Tab: navbar → migalhas → cinco campos → "Abrir no meu e-mail" → "Conheça as licenças Creative Commons" → e-mail de "Antes de enviar" → "Realização e apoio" → rodapé. Foco visível em todos.
- O link das licenças diz no nome acessível que abre em outra aba.
- Contraste ≥ 4,5:1 em todos os textos da página e da caixa; nada em cinza claro nem texto sobre foto.
- Movimento reduzido: a troca entre formulário e confirmação é imediata.

## Dados e regras de negócio
- Nenhum dado é lido nem gravado; o envio continua sendo `mailto:` (Q-04). Anexos não passam pelo site: a pessoa anexa no programa de e-mail.
- A rota `/colaborar` não muda, nem o botão "Colabore com esta categoria" e a regra `hasCollaborateOption` da categoria.
- E-mail do Observatório e endereço das licenças vêm das constantes já existentes.
- O conteúdo dos dois parágrafos atuais continua na página, reescrito em itens curtos (lead e "Antes de enviar"); nada é perdido.
- Fale com a gente deve ficar igual depois desta entrega.

## Critérios de aceite
1. [ ] `/colaborar` mostra navbar, cabeçalho em superfície com migalhas "Início › Colabore", `h1` "Colabore" e o texto de apoio, formulário, "Antes de enviar", "Realização e apoio" e rodapé; sem foto de fundo, sem "COLABORE" em caixa alta e sem o botão com o e-mail.
2. [ ] Formulário com os cinco campos da tabela (rótulo visível acima), botão "Abrir no meu e-mail" com envelope e o texto de apoio sobre anexos; sugestão do navegador em Nome completo, E-mail e Instituição; Enter passa de campo nas linhas simples e quebra linha em "Sobre a contribuição".
3. [ ] Validação ao apertar o botão, com as regras e mensagens da tabela; Instituição nunca dá erro; espaços nas pontas ignorados; foco no primeiro inválido; nada abre com erro; depois da primeira tentativa, o erro some ao corrigir.
4. [ ] Com tudo válido, abre o e-mail na mesma aba para o e-mail do Observatório, assunto "Colaboração: [título]" e corpo com o texto, linha em branco, nome, instituição (só se preenchida) e e-mail, inteiros, inclusive acentos, `&`, `?`, `#`, `%` e quebras de linha.
5. [ ] A confirmação substitui o formulário com o texto que fala em anexar os arquivos, o link do e-mail, "Copiar mensagem" (texto no formato da 018, com o assunto e o corpo desta spec) e "Voltar ao formulário" (campos mantidos, foco no primeiro); anunciada e focada.
6. [ ] "Antes de enviar" com os seis itens e textos da spec; link das licenças abre `creativeCommonsUrl` em outra aba e o do e-mail abre `mailto:`; foco visível e nome acessível nos dois.
7. [ ] O conteúdo dos parágrafos atuais (o que enviar, tipos e formatos de arquivo, obras de terceiros, identificação, avaliação, licença e link das licenças) está todo presente na página.
8. [ ] Acessibilidade: ordem de Tab conforme "Acessibilidade", foco visível, campos lidos com rótulo e erro, contraste ≥ 4,5:1, troca imediata com movimento reduzido.
9. [ ] Em 390, 768 e 1280 px conforme "Responsivo", com formulário vazio, com erros, com textos longos e na confirmação: sem rolagem horizontal, sem sobreposição e sem `overflow`, em release e em debug; rodapé na base.
10. [ ] O botão "Colabore com esta categoria" de uma categoria com `hasCollaborateOption` leva a `/colaborar`; categoria sem a opção não mostra o botão.
11. [ ] `/contato` sem mudança visível nem de comportamento; rota, modelo de categoria e painel sem mudança.
12. [ ] Código novo usa só tokens de `lib/app/theme/`, sem `num_extension` nem `GestureDetector` solto; rotas por `AppRoutes`; nenhum pacote novo; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Envio pelo próprio site, anexos pelo site, proteção contra spam (ideia futura 9.3).
- Saber de qual categoria a pessoa veio (a rota não leva a categoria; ver "Perguntas em aberto").
- Escolha do tipo de contribuição por lista (pede um componente de seleção que não existe no formulário).
- Remover o asset `collaborate.webp` (limpeza da Fase 7), mudar Fale com a gente, rotas, modelos, painel, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Desenho sem aba no protótipo.** Decidido no modo autônomo: a página segue a aba "Contato" (cabeçalho, formulário, caixa lateral, confirmação), como previsto na divisão da Fase 5; a caixa lateral troca "Outros meios" por "Antes de enviar".
  - **Campos.** Decidido no modo autônomo: o texto atual pede nome completo, e-mail e, se houver, a instituição; por isso Instituição é opcional e o assunto vira "Título da contribuição". Sem lista de tipo de contribuição, para não criar componente novo.
  - **Prefixo "Colaboração:" no assunto.** Decidido no modo autônomo: separa as propostas das mensagens de Fale com a gente na caixa do Observatório.
  - **Anexos.** Decidido no modo autônomo: o `mailto:` não leva arquivos; o texto de apoio e a confirmação dizem para anexar no programa de e-mail.
  - **Categoria de origem.** Decidido no modo autônomo: não entra. A rota `/colaborar` não leva a categoria e mudar rota está fora do que esta execução pode decidir; a pessoa cita a categoria na mensagem se quiser.
  - **Ordem no celular.** Decidido no modo autônomo: formulário antes de "Antes de enviar", como em Fale com a gente; o texto de apoio já lembra dos anexos e a caixa, com seis itens, empurraria o formulário para longe.
  - **Foto de fundo.** Decidido no modo autônomo: sai. Texto sobre foto não garante 4,5:1 e as outras páginas de texto usam a faixa em superfície.
  - **"Realização e apoio".** Decidido no modo autônomo: continua, como na página atual.
  - **Texto reescrito.** Decidido no modo autônomo: os dois parágrafos viram o lead e os itens de "Antes de enviar", com o mesmo conteúdo em frases curtas.

## Histórico de mudanças
- 2026-10-05: criada e aprovada no modo autônomo (execução da Fase 5).
- 2026-10-05: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-10-05: implementada (tarefas A1 a D1), sem divergência da spec.
