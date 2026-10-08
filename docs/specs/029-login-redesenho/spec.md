# 029. Login redesenhado

- **Status:** implementada
- **Item do planejamento:** Fase 8, item 8.1 (T-12)
- **Protótipo:** aba "Login" (link no CLAUDE.md)
- **Criada em:** 2026-10-07

## Objetivo
Quem administra o site entra no painel por uma tela com a cara do site novo: marca de um lado, formulário do outro, erro de credenciais explicado num aviso único e sem a regra de senha que só vale para criar usuário.

## Situação atual
`admin/login/presentation/signin_page.dart`: cartão centralizado com "LOGIN", rótulos "E-MAIL" e "SENHA" em maiúsculas, texto da regra de senha abaixo do campo e botão "ENTRAR", que vira um círculo girando enquanto espera. A senha é validada pela regra de criação (8 caracteres, maiúscula etc.). Erro do Firebase aparece num aviso flutuante ("Credenciais inválidas"). Não há caminho de volta ao site. A faixa "Ambiente de Testes" (`environment_banner.dart`) fica acima de todas as telas no dev.

## Comportamento
**Duas colunas** (tablet e desktop):
- **Coluna da marca**, fundo escuro do rodapé com círculos concêntricos laranja ao fundo (decorativos): logo e nome "Observatório / Ensino de História e Geografia" (link para a Home, nome acessível "Observatório, voltar ao site"); sobretítulo "Painel da equipe"; título "Publique no Observatório."; texto "Publicações, biblioteca, equipe e imagens do site em um só lugar."; no pé, "Sem acesso? Peça a quem administra o painel para criar seu usuário."
- **Coluna do formulário**, fundo `surface`, com cartão branco centralizado (largura máxima fixa):
  - Título "Entrar" e subtítulo "Use o e-mail e a senha que a administração cadastrou para você."
  - Campo "E-mail" (dica `nome@exemplo.com`) e campo "Senha" com botão de mostrar/ocultar dentro do campo.
  - Botão "Entrar" na largura do cartão.
  - Link "Voltar ao site" com seta, que leva à Home.

**Validação ao enviar** (Enter em qualquer campo também envia):
- E-mail vazio ou inválido: "Informe o e-mail, como nome@exemplo.com."
- Senha vazia: "Informe a senha." Sai a regra de 8 caracteres, maiúscula etc. (continua valendo ao criar usuário).
- O foco vai para o primeiro campo com erro.

**Envio:** o botão fica desabilitado, com indicador girando e o texto "Entrando…". Formulário não é enviado duas vezes.

**Erro do Firebase:** aparece um aviso vermelho no topo do cartão, acima dos campos, no lugar do aviso flutuante.
- Credenciais inválidas, usuário não encontrado ou senha errada: "E-mail ou senha não conferem. Confira os dois e tente de novo." A senha é apagada e recebe o foco.
- Outros erros (muitas tentativas, usuário desabilitado, falha de rede): a mensagem atual de cada erro, no mesmo aviso.
- O aviso some na próxima tentativa.

**Sucesso:** abre o painel, como hoje. Quem já está logado e abre `/admin` vai direto para o painel.

**Faixa de ambiente:** no dev, faixa laranja no topo com "Ambiente de testes" (caixa de frase). Em prod não aparece. A faixa é a mesma das outras telas, então o texto muda em todas.

## Estados
- **Carregando:** botão "Entrando…" desabilitado. Enquanto confere se já há sessão, a tela já aparece com o formulário.
- **Vazio:** não se aplica.
- **Erro:** aviso no cartão, descrito acima.
- **Casos de borda:** e-mail muito longo não estoura o campo; mensagem de erro longa quebra linha dentro do aviso.

## Responsivo
- **390:** uma coluna. A marca vira faixa escura no topo, só com logo, sobretítulo e título menor (somem o texto e o pé). Abaixo, o cartão ocupa a largura com margem lateral.
- **768:** duas colunas; o cartão ocupa a largura da coluna do formulário, com margem.
- **1280:** duas colunas (marca ~45%, formulário ~55%), cartão com largura máxima centralizado. A tela ocupa pelo menos a altura da janela.

## Acessibilidade
- Ordem de Tab: logo, e-mail, senha, mostrar senha, Entrar, Voltar ao site. Foco visível em todos.
- Botão de senha com nome "Mostrar senha"/"Ocultar senha", estado de pressionado e dica ao passar o mouse e no foco ("Mostrar a senha digitada"/"Ocultar a senha").
- Erros de campo ligados ao campo (leitor de tela lê junto). O aviso de erro do Firebase é anunciado ao aparecer.
- Textos sobre o fundo escuro com contraste ≥ 4,5:1; os círculos do fundo são decorativos e ficam fora da árvore de acessibilidade.
- O indicador do botão não anima com movimento reduzido.

## Dados e regras de negócio
Sem mudança em autenticação, `AuthStore`, mensagens das falhas (só o login escolhe o texto unificado para credenciais), rota `/admin` e redirecionamentos. A regra de senha de `Validators.isValidPassword` continua no cadastro de usuário.

## Critérios de aceite
- [ ] Tela reproduz a aba "Login" do protótipo em 390, 768 e 1280 px, sem `overflow` nem rolagem horizontal.
- [ ] Rótulos "E-mail" e "Senha" em caixa normal; não aparece a regra de senha.
- [ ] Enviar vazio mostra as duas mensagens de campo e põe o foco no e-mail.
- [ ] Senha curta (ex.: 3 caracteres) é aceita pela validação e enviada ao Firebase.
- [ ] Credencial errada mostra "E-mail ou senha não conferem. Confira os dois e tente de novo." no cartão, apaga a senha e foca nela; não aparece aviso flutuante.
- [ ] Durante o envio o botão mostra "Entrando…" e não aceita novo clique.
- [ ] Login certo abre o painel; abrir `/admin` já logado vai ao painel.
- [ ] "Voltar ao site" e o logo levam à Home.
- [ ] Mostrar/ocultar senha funciona por mouse e teclado, com nome acessível e dica.
- [ ] Faixa "Ambiente de testes" aparece no dev e não em prod.
- [ ] Contraste ≥ 4,5:1 em todos os textos, inclusive na coluna escura.
- [ ] Sem cor, fonte ou espaçamento solto; o que faltar vira token.
- [ ] `fvm flutter analyze` sem erros novos.

## Fora do escopo
- Recuperação de senha e criação de conta.
- Painel (030 a 033).

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-07: criada. Fase 8 dividida em cinco specs (029 a 033), uma por item, decidido com a pessoa.
- 2026-10-07: aprovada.
- 2026-10-08: plano criado (plan.md e tasks.md), sem mudança de comportamento. A spec foi conferida com o código e a aba "Login" do protótipo e bate com os dois. Como a pessoa estava ausente, a aprovação do plano foi dada pelo fluxo autônomo. Decisões em plan.md: o formulário reaproveita o `FormTextField` do site, o carregamento entra como opção do `AppButtonBase` e `passwordVisible` fica no `AuthStore`.
- 2026-10-08: implementada, sem mudança de comportamento. Dois ajustes de layout decididos no fluxo autônomo: perto de 600 px a coluna da marca é mais estreita que o logo e que a palavra "Observatório.", então o logo encolhe para caber e o título reduz a fonte só o necessário para não quebrar a palavra (mesma regra do `WordSafeText`). O aviso de erro é controlado pela página, porque o `AuthStore` não tem como limpar o erro e não podia mudar.
