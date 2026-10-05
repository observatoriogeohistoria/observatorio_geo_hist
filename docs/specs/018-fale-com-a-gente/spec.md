# 018. Fale com a gente

- **Status:** aprovada
- **Item do planejamento:** Fase 5, tela T-04 (`/contato`); decisão "Fale com a gente" (seção 1) e Q-04
- **Protótipo:** aba "Contato" (link no CLAUDE.md)
- **Criada em:** 2026-10-05
- **Depende de:** [010-leitura-manifesto](../010-leitura-manifesto/spec.md) (cabeçalho de página e migalhas), [013-compartilhamento-post](../013-compartilhamento-post/spec.md) (retorno de "copiar")

## Objetivo
Quem quer escrever ao Observatório preenche um formulário claro, vê na hora o que falta corrigir e, ao enviar, entende que o próprio programa de e-mail foi aberto com a mensagem pronta. Quem não tem programa de e-mail configurado copia a mensagem e escreve por conta própria, sem perder o que digitou.

## Situação atual
- [contact_us_page.dart](../../../lib/app/features/home/presentation/pages/contact_us_page.dart) (`/contato`): título "CONTATO" em laranja com divisória; à esquerda, campos "NOME", "E-MAIL", "ASSUNTO" e "MENSAGEM" com rótulo laranja e borda cinza; botão "ENVIAR". À direita (abaixo no celular), endereço, telefones, e-mail, Instagram, Facebook e YouTube como texto cinza claro, sem link.
- Validação: só "Por favor, o campo não pode ser vazio" em cada campo; o e-mail não é conferido. Espaços contam como preenchido.
- "ENVIAR" abre o `mailto:` para `AppStrings.email` com o assunto e o corpo "De / E-mail / Mensagem". Nada muda na tela depois: a pessoa não sabe se algo aconteceu, e quem não tem programa de e-mail fica sem saída.
- Usa `num_extension`, cores antigas (`orange`, `gray`) e não tem migalhas.

## Comportamento

Navbar, cabeçalho de página, conteúdo e rodapé (na base da janela quando a página é curta).

### Cabeçalho
Faixa de cabeçalho em superfície, igual às do Manifesto e da listagem:
1. Migalhas "Início › Fale com a gente" (página atual sem link).
2. Título (`h1`) "Fale com a gente".
3. Texto de apoio: "O Observatório é criado por e para professores, pesquisadores e estudantes. Envie suas contribuições, opiniões e sugestões."

### Formulário
Na coluna principal, quatro campos, cada um com rótulo visível acima ("Nome", "E-mail", "Assunto", "Mensagem"), em minúsculas com inicial maiúscula (sai a caixa alta laranja):
- **Nome:** uma linha; o navegador pode sugerir o nome.
- **E-mail:** uma linha; teclado de e-mail no celular; o navegador pode sugerir o e-mail.
- **Assunto:** uma linha.
- **Mensagem:** caixa de várias linhas (altura de cerca de 6 linhas), que cresce com o texto até um limite e depois rola por dentro.

Abaixo dos campos:
- Botão principal **"Abrir no meu e-mail"**, com ícone de envelope à esquerda.
- Texto de apoio: "Vamos abrir o seu programa de e-mail com a mensagem já preenchida. Falta só você apertar **Enviar** por lá."

Teclas: Enter em Nome, E-mail e Assunto passa ao campo seguinte; Enter em Mensagem quebra a linha. O envio é só pelo botão (clique, Enter ou espaço com o foco nele).

### Validação
Ao apertar "Abrir no meu e-mail", cada campo é conferido (sem contar espaços no começo e no fim):

| Campo | Regra | Mensagem |
|---|---|---|
| Nome | não vazio | "Informe seu nome." |
| E-mail | formato `algo@algo.algo`, sem espaços | "Informe um e-mail válido, como nome@exemplo.com." |
| Assunto | não vazio | "Informe o assunto." |
| Mensagem | pelo menos 10 caracteres | "Escreva uma mensagem com pelo menos 10 caracteres." |

- Campo inválido: borda na cor de erro e a mensagem logo abaixo, na cor de erro.
- Com erro, nada é aberto e o foco vai para o primeiro campo inválido.
- Antes da primeira tentativa, nenhum erro aparece. Depois dela, cada campo é conferido de novo enquanto a pessoa digita, e a mensagem some assim que o campo fica válido.
- Sem limite máximo de tamanho.

### Envio e confirmação
Com tudo válido:
1. O site abre o programa de e-mail (na mesma aba, sem deixar aba em branco) com:
   - **Para:** o e-mail do Observatório (o mesmo do rodapé);
   - **Assunto:** o assunto digitado;
   - **Corpo:** a mensagem, uma linha em branco, o nome e, na linha seguinte, o e-mail digitado.
2. No lugar do formulário aparece a **confirmação**, numa caixa com borda e cantos arredondados, centralizada:
   - ícone de envelope num círculo verde-claro;
   - título "Seu e-mail está pronto";
   - "Abrimos o seu programa de e-mail com a mensagem preenchida. Aperte **Enviar** por lá para concluir.";
   - "Não abriu? Copie a mensagem e escreva para [e-mail do Observatório]." (o e-mail é link `mailto:`);
   - botões **"Copiar mensagem"** (secundário, com ícone) e **"Voltar ao formulário"** (de texto).
3. **Copiar mensagem** copia um texto pronto para colar em qualquer e-mail:
   ```
   Para: [e-mail do Observatório]
   Assunto: [assunto]

   [mensagem]

   [nome]
   [e-mail digitado]
   ```
   O botão passa a "Mensagem copiada" por alguns segundos e volta a "Copiar mensagem" (sem mudar de largura). Se o navegador recusar, mostra "Erro ao copiar" pelo mesmo tempo, como o "Copiar link" do post.
4. **Voltar ao formulário** volta ao formulário **com os campos preenchidos** e sem erros, com o foco no campo "Nome".

O site não tem como saber se o programa de e-mail abriu ou se a mensagem foi enviada: a confirmação aparece sempre, e o texto diz o que falta fazer.

### Outros meios
Ao lado do formulário (abaixo no celular e no tablet), caixa em fundo de superfície com cantos arredondados:
- título "Outros meios";
- **E-mail:** o e-mail do Observatório, como link `mailto:`;
- **Telefones:** "34 3239-4163" e "34 3239-4212", um por linha, como links `tel:` (os mesmos do rodapé);
- **Endereço:** o endereço em três linhas do rodapé.

Rótulos pequenos em caixa alta na cor secundária; valores no tamanho do texto; links na cor de acento, sublinhados. Saem daqui Instagram, Facebook e YouTube (continuam no rodapé).

## Estados
- **Carregando / vazio / erro de dados:** não se aplicam; a página não busca dados.
- **Erro de validação:** ver "Validação".
- **Confirmação:** ver "Envio e confirmação".
- **Programa de e-mail não abre:** a confirmação aparece igual, com "Copiar mensagem" e o link para o e-mail.
- **Cópia recusada:** "Erro ao copiar" no botão, anunciado.
- **Casos de borda:** nome, assunto e mensagem muito longos (quebram linha, sem `overflow`; a mensagem rola dentro da caixa); mensagem com acentos, emojis, `&`, `?`, `#`, `%` e quebras de linha (chegam inteiros ao programa de e-mail e ao texto copiado); campos só com espaços (contam como vazios); e-mail com espaço no fim (aparado, válido); várias tentativas seguidas com erro; "Voltar ao formulário" e novo envio.

## Responsivo
- **Celular (390):** margens de 20 px; formulário e "Outros meios" em uma coluna, nesta ordem; "Abrir no meu e-mail" na largura toda; botões da confirmação quebrando linha, centralizados.
- **Tablet (768):** margens de 32 px; uma coluna, como no celular; botão no tamanho do texto.
- **Desktop (1280):** duas colunas no conteúdo de até 1120 px: formulário mais largo (cerca de 3/5) e "Outros meios" à direita (cerca de 2/5), alinhados no topo.
- Em todas: sem rolagem horizontal, sem `overflow`; rodapé na base com conteúdo curto.

## Acessibilidade
- `h1` no título; migalhas como navegação "Você está em".
- Cada campo lido com o próprio rótulo; o erro lido junto com o campo; campo inválido marcado como inválido.
- Ao falhar a validação, o foco vai ao primeiro campo inválido, e o erro dele é lido.
- A confirmação é anunciada ao aparecer ("Seu e-mail está pronto") e recebe o foco, para quem usa teclado não ficar num botão que sumiu. "Mensagem copiada" e "Erro ao copiar" são anunciados.
- Ordem de Tab: navbar → migalhas → Nome → E-mail → Assunto → Mensagem → "Abrir no meu e-mail" → links de "Outros meios" → rodapé. Na confirmação: link do e-mail → "Copiar mensagem" → "Voltar ao formulário" → "Outros meios". Foco visível em todos.
- Contraste ≥ 4,5:1 em rótulos, texto de apoio, mensagens de erro, textos da confirmação, rótulos e valores de "Outros meios" e na borda dos campos usada como único contorno (≥ 3:1). Nada em cinza claro.
- Movimento reduzido: a troca entre formulário e confirmação é imediata.

## Dados e regras de negócio
- Nenhum dado é lido nem gravado; nada vai a servidor. O envio continua sendo o `mailto:` (Q-04).
- E-mail, telefones e endereço vêm das mesmas constantes do rodapé.
- A rota `/contato` não muda; os links que levam a ela (rodapé, chamada da Home, Manifesto) continuam iguais.
- **Reaproveitamento na 019 (Colabore):** os campos com rótulo e erro, as regras e mensagens de validação, o botão que abre o e-mail e a confirmação com "Copiar mensagem" e "Voltar ao formulário" são peças do site, não desta página, e a 019 vai usá-los com os próprios campos e textos. Esta spec não muda nada na página Colabore.
- Os campos do painel administrativo e a validação do login não mudam.

## Critérios de aceite
1. [ ] `/contato` mostra navbar, cabeçalho em superfície com migalhas "Início › Fale com a gente", `h1` "Fale com a gente" e o texto de apoio, formulário, "Outros meios" e rodapé; sem "CONTATO" em laranja, sem divisória e sem "ENVIAR".
2. [ ] Formulário com "Nome", "E-mail", "Assunto" e "Mensagem" (rótulo visível acima de cada um), botão "Abrir no meu e-mail" com ícone de envelope e o texto de apoio abaixo; sugestão do navegador em Nome e E-mail; Enter passa de campo nas três primeiras linhas e quebra linha na mensagem.
3. [ ] Validação ao apertar o botão, com as regras e mensagens da tabela; espaços nas pontas ignorados; erro na cor de erro com borda de erro; foco no primeiro inválido; nada abre com erro; depois da primeira tentativa, o erro some ao corrigir.
4. [ ] Com tudo válido, abre o programa de e-mail na mesma aba, para o e-mail do Observatório, com o assunto e o corpo (mensagem, linha em branco, nome, e-mail) inteiros, inclusive acentos, `&`, `?`, `#`, `%` e quebras de linha.
5. [ ] Depois do envio, a confirmação substitui o formulário com o título, os dois textos, o link do e-mail e os botões "Copiar mensagem" e "Voltar ao formulário"; é anunciada e recebe o foco.
6. [ ] "Copiar mensagem" copia o texto no formato da spec; o botão mostra "Mensagem copiada" (ou "Erro ao copiar") por alguns segundos, anunciado, sem mudar de largura.
7. [ ] "Voltar ao formulário" volta com os campos preenchidos, sem erros, com o foco em "Nome"; novo envio funciona.
8. [ ] "Outros meios" com E-mail (`mailto:`), dois telefones (`tel:`) e o endereço do rodapé; links com foco visível e nome acessível; sem Instagram, Facebook e YouTube na página.
9. [ ] Acessibilidade: campos lidos com rótulo e erro; ordem de Tab conforme "Acessibilidade", com foco visível; contraste ≥ 4,5:1 nos textos listados; troca imediata com movimento reduzido.
10. [ ] Em 390, 768 e 1280 px conforme "Responsivo", com formulário vazio, com erros, com textos longos e na confirmação: sem rolagem horizontal, sem sobreposição e sem `overflow`, em release e em debug; rodapé na base.
11. [ ] Campos, validação, botão de envio e confirmação ficam em componentes compartilhados que recebem campos e textos de fora (prontos para a 019); a página Colabore, o painel e o `Validators` atual sem mudança.
12. [ ] Código novo usa só tokens de `lib/app/theme/`, não usa `num_extension` nem `GestureDetector` solto; rotas só por `AppRoutes`; nenhum pacote novo; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Envio pelo próprio site, sem programa de e-mail (ideia futura 9.3), proteção contra spam e qualquer serviço novo.
- A página Colabore (019), mesmo usando as peças daqui.
- Saber se o e-mail foi enviado; guardar o rascunho ao sair da página; anexos.
- Título da aba do navegador; Instagram, Facebook e YouTube nesta página (seguem no rodapé).
- Apagar `AppTextField`, `Validators` ou textos antigos (usados pelo painel; limpeza da Fase 7).
- Mudar modelos, regras, rotas, o painel, Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **"Voltar ao formulário" mantém os campos.** Decidido no modo autônomo: o protótipo limpa o formulário, mas quem volta em geral quer corrigir algo ou tentar de novo porque o programa não abriu; apagar o texto seria perda. Quem quiser outra mensagem apaga os campos.
  - **Enter não envia.** Decidido no modo autônomo: Enter passa ao campo seguinte nas linhas simples, para ninguém abrir o e-mail sem querer no meio do preenchimento; o protótipo (formulário HTML) enviaria.
  - **Corpo do e-mail.** Decidido no modo autônomo: formato do protótipo (mensagem e, embaixo, nome e e-mail como assinatura). O "De:" atual sai porque o e-mail já sai da conta da pessoa; o e-mail digitado fica na assinatura para resposta, caso ela escreva de outra conta. O texto copiado acrescenta o e-mail digitado, que o protótipo omitia.
  - **E-mail do Observatório.** Decidido no modo autônomo: o de `AppStrings.email` (o do rodapé); o do protótipo é exemplo.
  - **Endereço de três linhas, sem CEP.** Decidido no modo autônomo: o mesmo do rodapé e do protótipo, para não haver duas versões.
  - **Sem redes sociais na página.** Decidido no modo autônomo: como no protótipo; elas estão no rodapé logo abaixo.
  - **Mensagem com 10 caracteres no mínimo e sem máximo.** Decidido no modo autônomo: regra do protótipo. Mensagens muito longas podem ser cortadas por alguns programas de e-mail; "Copiar mensagem" cobre esse caso.
  - **Confirmação sempre.** Decidido no modo autônomo: o navegador não informa se o programa de e-mail abriu; por isso o texto diz "Não abriu?" e oferece a cópia.
  - **Peças compartilhadas.** Decidido no modo autônomo: campos, validação, botão e confirmação feitos para a 019 reaproveitar com outros campos e textos, como pede a divisão da Fase 5.

## Histórico de mudanças
- 2026-10-05: criada e aprovada no modo autônomo (execução da Fase 5).
- 2026-10-05: plano e tarefas criados (`plan.md`, `tasks.md`).
