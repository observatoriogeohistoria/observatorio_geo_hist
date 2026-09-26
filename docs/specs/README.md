# Especificações (SDD)

Cada feature maior tem uma pasta `docs/specs/NNN-nome-curto/` com três arquivos, criados em sequência pelas skills do projeto.

| Arquivo | Criado por | Conteúdo |
|---|---|---|
| `spec.md` | `/sdd-spec` | **O quê e por quê**: comportamento, estados, critérios de aceite, fora do escopo |
| `plan.md` | `/sdd-plan` | **Como**: abordagem técnica, arquivos afetados, decisões e riscos |
| `tasks.md` | `/sdd-plan` (atualizado por `/sdd-implement`) | Lista de tarefas ordenadas, com o progresso |
| `verificacao.md` | `/sdd-verify` | Resultado da conferência contra os critérios de aceite |

## Fluxo

```
planejamento.md ──► /sdd-spec ──► (aprovação) ──► /sdd-plan ──► /sdd-implement ──► /sdd-verify
     (item)          spec.md                      plan.md         código +           verificacao.md
                                                  tasks.md        tasks.md marcadas
```

Em cada etapa a skill **para** e espera a sua aprovação antes de seguir.

**Modo autônomo:** `/sdd-fase <fase ou itens>` (ex.: `/sdd-fase Fase 1`) roda o fluxo inteiro sem paradas. Divide a fase em specs, faz cada etapa numa sessão separada, corrige o que a verificação achar (até 2 tentativas por problema), faz commits por entrega numa branch própria da fase (`refactor/redesign-<fase>`, criada a partir da `develop`), abre PR para a `develop` e termina com um resumo. O andamento fica em `docs/specs/execucao-<fase>.md`, que também serve para retomar se a execução for interrompida.

## Regras
- Numeração sequencial de três dígitos (`001`, `002`...). O nome é curto, em `kebab-case`, sem acentos.
- A spec tem um **status** no topo: `rascunho`, `aprovada`, `implementada` ou `verificada`.
- Uma spec só vai para o plano com **zero perguntas em aberto** e status `aprovada`.
- Se, durante a implementação, algo precisar divergir da spec, **atualize a spec primeiro** (e registre em "Histórico de mudanças"), depois o código.
- Cada critério de aceite deve poder ser conferido como "passou" ou "não passou".
- Ao final, o item correspondente no [planejamento](../redesign/planejamento.md) é marcado como concluído.

## Modelo de status no planejamento
Ao concluir uma spec, acrescente ao item do planejamento a referência: `→ specs/001-nome`.

## Quando usar
Use para features de mais ou menos meio dia para cima ou que mudem várias telas. Correções pequenas e ajustes pontuais dispensam spec.
