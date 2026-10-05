# Execução da Fase 5

- **Início:** 2026-10-05
- **Branch:** refactor/redesign-fase-5 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 018-fale-com-a-gente | Fale com a gente (T-04) | feita (12 critérios, 11 tarefas) | pendente | pendente | |
| 019-colabore | Colabore (T-05) | pendente | pendente | pendente | |
| 020-estados-especiais | 404, erro, vazio e esqueletos (T-10) | pendente | pendente | pendente | |
| 021-tipos-post-obras | tipos de post livro, filme, revista, documento e produção acadêmica (T-08, P-08) | pendente | pendente | pendente | |
| 022-tipos-post-midia-eventos | tipos de post podcast, música, evento e pesquisa (T-08, P-08) | pendente | pendente | pendente | |

## Divisão
- 018 e 019 são formulários separados; a 019 reaproveita o que a 018 criar (campos, validação, confirmação).
- 020 vem antes dos tipos de post para que eles já usem a 404 e os estados de erro e vazio.
- Os 9 tipos de post restantes ficam em duas specs, sobre o layout-base da 012: obras com ficha (021) e mídia, eventos e pesquisa (022). A 022 reaproveita os blocos da 021.

## Decisões tomadas sem a pessoa
- 018: "Voltar ao formulário" mantém os campos; Enter passa ao campo seguinte; corpo do e-mail como no protótipo (mensagem, nome e e-mail); contatos de `AppStrings`, iguais ao rodapé; redes sociais só no rodapé; mensagem com mínimo de 10 caracteres; confirmação sempre aparece (o navegador não diz se o e-mail abriu); cor nova de borda dos campos (#8A8178), mais escura que a do protótipo, por contraste. Formulário e confirmação recebem campos e textos de fora, para a 019. Detalhes em [018/spec.md](018-fale-com-a-gente/spec.md).

## Ressalvas
- (spec, ponto, o que foi tentado)

## Ocorrências
- (limites, falhas de ambiente, retomadas)
