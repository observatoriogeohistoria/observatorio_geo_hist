# Execução da Fase 5

- **Início:** 2026-10-05
- **Branch:** refactor/redesign-fase-5 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 018-fale-com-a-gente | Fale com a gente (T-04) | feita (12 critérios, 11 tarefas) | feita (3 commits) | feita | verificada com ressalvas: 1 correção (rolar até o campo focado); leitor de tela e autopreenchimento não conferidos no app |
| 019-colabore | Colabore (T-05) | feita (12 critérios, 6 tarefas) | feita (2 commits) | feita | verificada com ressalvas: sem correções; categoria sem a opção (não há no ambiente), leitor de tela e autopreenchimento não conferidos no app |
| 020-estados-especiais | 404, erro, vazio e esqueletos (T-10) | feita (12 critérios, 9 tarefas) | pendente | pendente | |
| 021-tipos-post-obras | tipos de post livro, filme, revista, documento e produção acadêmica (T-08, P-08) | pendente | pendente | pendente | |
| 022-tipos-post-midia-eventos | tipos de post podcast, música, evento e pesquisa (T-08, P-08) | pendente | pendente | pendente | |

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

## Ressalvas
- 018: não conferidos no app o anúncio por leitor de tela, a sugestão de autopreenchimento do navegador e o botão principal no detalhe da biblioteca (sem documentos no ambiente de testes; mudança só aditiva); painel sem diff e não conferido.
- 019: não conferidos no app a categoria sem "Colabore com esta categoria" (o ambiente não tem), o anúncio por leitor de tela e a sugestão de autopreenchimento; painel sem diff e não conferido.

## Ocorrências
- (limites, falhas de ambiente, retomadas)
- 019 (verificação): o navegador embutido não repassava a digitação aos campos do Flutter; a conferência foi feita num Chrome headless por CDP.
