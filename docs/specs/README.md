# Especificações (SDD)

Cada feature maior ganha uma pasta `docs/specs/NNN-short-name/` enquanto está em andamento, com os arquivos criados em sequência pelas skills do projeto.

| Arquivo | Criado por | Conteúdo |
|---|---|---|
| `spec.md` | `/sdd-spec` | **O quê e por quê**: comportamento, estados, critérios de aceite, fora do escopo |
| `plan.md` | `/sdd-plan` | **Como**: abordagem técnica, arquivos afetados, decisões e riscos |
| `tasks.md` | `/sdd-plan` (atualizado por `/sdd-implement`) | Lista de tarefas ordenadas, com o progresso |
| `verification.md` | `/sdd-verify` | Resultado da conferência contra os critérios de aceite |

## Fluxo

```
pedido ou ──► /sdd-spec ──► (aprovação) ──► /sdd-plan ──► /sdd-implement ──► /sdd-verify ──► merge
future-ideas    spec.md                     plan.md        código +           verification.md
                                            tasks.md       tasks.md marcadas
```

Em cada etapa a skill **para** e espera a sua aprovação antes de seguir.

## Regras
- Numeração sequencial de três dígitos, seguindo a última usada (a 033 foi a última do redesign; a próxima é a 034). O nome é curto, em inglês e `kebab-case`.
- A spec tem um **status** no topo: `rascunho`, `aprovada`, `implementada` ou `verificada`.
- Uma spec só vai para o plano com **zero perguntas em aberto** e status `aprovada`.
- Se, durante a implementação, algo precisar divergir da spec, **atualize a spec primeiro** (e registre em "Histórico de mudanças"), depois o código.
- Cada critério de aceite deve poder ser conferido como "passou" ou "não passou".

## Depois do merge
A pasta da spec sai do repositório no mesmo PR ou logo depois. Antes disso:
- regras e padrões novos vão para [architecture.md](../architecture.md) ou [admin-panel.md](../admin-panel.md);
- ressalvas que seguem em aberto vão para o histórico ([redesign-history.md](../redesign-history.md) ou um novo, se o trabalho for de outro assunto);
- se a feature vinha de [future-ideas.md](../future-ideas.md), o item sai de lá.

Para consultar uma spec apagada, use o git (`git log --all -- docs/specs/NNN-*`). As do redesign estão na tag `redesign-specs`.

## Quando usar
Use para features de mais ou menos meio dia para cima ou que mudem várias telas. Correções pequenas e ajustes pontuais dispensam spec.
