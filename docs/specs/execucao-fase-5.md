# Execução da Fase 5

- **Início:** 2026-10-05
- **Término:** 2026-10-06
- **Branch:** refactor/redesign-fase-5 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 018-fale-com-a-gente | Fale com a gente (T-04) | feita (12 critérios, 11 tarefas) | feita (3 commits) | feita | verificada com ressalvas: 1 correção (rolar até o campo focado); leitor de tela e autopreenchimento não conferidos no app |
| 019-colabore | Colabore (T-05) | feita (12 critérios, 6 tarefas) | feita (2 commits) | feita | verificada com ressalvas: sem correções; categoria sem a opção (não há no ambiente), leitor de tela e autopreenchimento não conferidos no app |
| 020-estados-especiais | 404, erro, vazio e esqueletos (T-10) | feita (12 critérios, 9 tarefas) | feita (5 commits) | feita | verificada com ressalvas: sem correções; erro dos Destaques, "Nenhum documento encontrado", leitor de tela e painel não conferidos no app |
| 021-tipos-post-obras | tipos de post livro, filme, revista, documento e produção acadêmica (T-08, P-08) | feita (15 critérios, 14 tarefas) | feita (3 commits) | feita | verificada com ressalvas: 1 correção (ordem de leitura dos dados ao lado da capa); leitor de tela e painel não conferidos no app |
| 022-tipos-post-midia-eventos | tipos de post podcast, música, evento e pesquisa (T-08, P-08) | feita (14 critérios, 14 tarefas) | feita (5 commits) | feita | verificada com ressalvas: 1 correção (link malformado lançava exceção no clique); leitor de tela e painel não conferidos no app |

## Divisão
- 018 e 019 são formulários separados; a 019 reaproveita o que a 018 criar (campos, validação, confirmação).
- 020 vem antes dos tipos de post para que eles já usem a 404 e os estados de erro e vazio.
- Os 9 tipos de post restantes ficam em duas specs, sobre o layout-base da 012: obras com ficha (021) e mídia, eventos e pesquisa (022). A 022 reaproveita os blocos da 021.

## Decisões tomadas sem a pessoa
- 018: "Voltar ao formulário" mantém os campos; Enter passa ao campo seguinte; corpo do e-mail como no protótipo (mensagem, nome e e-mail); contatos de `AppStrings`, iguais ao rodapé; redes sociais só no rodapé; mensagem com mínimo de 10 caracteres; confirmação sempre aparece (o navegador não diz se o e-mail abriu); cor nova de borda dos campos (#8A8178), mais escura que a do protótipo, por contraste. Formulário e confirmação recebem campos e textos de fora, para a 019. Detalhes em [018/spec.md](018-fale-com-a-gente/spec.md).
- 018 (implementação): links de "Outros meios" e da confirmação em `accentStrong` (o acento normal dá 4,48:1); Nome, E-mail e Assunto rolam o texto por dentro, só a Mensagem quebra linha.
- 018 (verificação): foco no campo inválido, a volta ao Nome e a confirmação rolam a página até o elemento, abaixo da navbar fixa.
- 019: desenho da aba "Contato" (sem aba própria no protótipo), caixa "Antes de enviar" no lugar de "Outros meios"; campos Nome completo, E-mail, Instituição (opcional), Título da contribuição e Sobre a contribuição; assunto "Colaboração: [título]"; texto de apoio e confirmação pedem para anexar no programa de e-mail; sem foto de fundo; "Realização e apoio" mantida; categoria de origem fora (a rota não a leva); moldura da caixa lateral extraída do `ContactInfoCard` para `core/components/form/`. Detalhes em [019/spec.md](019-colabore/spec.md).
- 020: 404 na mesma caixa dos outros estados (`StateMessageBox` ganha `leading` e `titleHeadingLevel`), com "404" em laranja, título `h1` e botões "Ir para o início" e "Explorar a biblioteca"; esqueleto com brilho do protótipo, parado com movimento reduzido; erro discreto das seções da Home vira `StateErrorInline`; `EmptyContent` e `PageErrorContent`, sem uso, saem; erro de imagem antigo fica para a 021 e a 022. Detalhes em [020/spec.md](020-estados-especiais/spec.md).
- 021: divisão com a 022 mantida; layout único das obras alimentado por uma descrição por tipo; selo da categoria acima do título; ficha, selo e etiquetas da biblioteca e o "Assistir" da Home vão para `core`; documento e produção acadêmica sem imagem na página; filme com "Assistir" sobre o cartaz, sem player; texto abaixo do bloco com subtítulo "Sinopse"/"Descrição"/"Resumo"; texto não-delta como texto simples; cinco `*_content.dart` antigos apagados, erro de imagem antigo fica. Detalhes em [021/spec.md](021-tipos-post-obras/spec.md).
- 021 (implementação): palavras-chave separadas em "," e ";", sem ponto final (formato real das produções acadêmicas de prod); sem linha dupla acima do compartilhar quando a ficha fecha o bloco; `TypeBadge` com opção `wrap` para categorias longas nas obras.
- 022: faixa "Ouvir" com o site do link no lugar do player (sem player embutido); capa quadrada no podcast e na música; caixa de data só quando dia e mês do início são legíveis, "Data" sempre na ficha; evento sem imagem na página; abrangência na ficha; pesquisa com pílula verde/neutra junto do título e imagem com legenda como no artigo; `article_content.dart`, `SocialIcons` e `ViewQuill` apagados por ficarem sem uso; erro de imagem antigo fica (Home, `core`, painel). Detalhes em [022/spec.md](022-tipos-post-midia-eventos/spec.md).
- 022 (implementação): a caixa de data do evento aceita lista ou intervalo de dias antes de "de mês" e usa o primeiro dia (3 dos 7 eventos de prod escrevem assim).
- 022 (verificação): `openUrl` passa a tratar link que o `Uri.parse` recusa, em vez de lançar exceção no clique.

## Ressalvas
- 018: não conferidos no app o anúncio por leitor de tela, a sugestão de autopreenchimento do navegador e o botão principal no detalhe da biblioteca (sem documentos no ambiente de testes; mudança só aditiva); painel sem diff e não conferido.
- 019: não conferidos no app a categoria sem "Colabore com esta categoria" (o ambiente não tem), o anúncio por leitor de tela e a sugestão de autopreenchimento; painel sem diff e não conferido.
- 020: não conferidos no app o erro dos Destaques (com o Firestore bloqueado o cache devolve lista vazia e a seção some, como antes), "Nenhum documento encontrado" e "Limpar filtros" da biblioteca (sem documentos no ambiente) e o anúncio por leitor de tela; painel sem diff e não conferido.
- 021: não conferido no app o anúncio por leitor de tela (árvore semântica conferida); painel sem diff e não conferido.
- 022: não conferido no app o anúncio por leitor de tela (árvore semântica conferida); painel sem diff e não conferido.

### Revisão (2026-10-06)
- 020: erro dos Destaques corrigido no datasource: offline com cache vazio vira erro, e a seção mostra "Não foi possível carregar os destaques." em vez de sumir. Não conferido no app.
- Seguem em aberto os demais itens acima (leitor de tela, autopreenchimento, casos sem dados no ambiente e painel).

## Ocorrências
- 019 (verificação): o navegador embutido não repassava a digitação aos campos do Flutter; a conferência foi feita num Chrome headless por CDP.
- 020 (verificação): conferida num Chrome headless por CDP, comparando os esqueletos com um build do código anterior à spec.
- 021 (implementação): interrompida pelo limite de uso depois do primeiro commit e retomada na mesma sessão.
- 021 (verificação): leitura direta do Firestore de prod pela API REST negada pelo classificador; os posts foram achados pelo próprio site (build `APP_ENV=prod` só leitura) num Chrome headless por CDP.
- 022 (implementação): interrompida por erro do servidor (529) antes da conferência e retomada na mesma sessão.
- 022 (verificação): conferida num Chrome headless por CDP; Tab no navegador sem janela só avança sem a semântica ligada, então o foco foi conferido com Tabs contados e captura de tela.
