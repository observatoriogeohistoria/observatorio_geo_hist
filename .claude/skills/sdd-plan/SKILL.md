---
name: sdd-plan
description: Cria o plano técnico (plan.md) e a lista de tarefas (tasks.md) de uma spec aprovada em docs/specs. Use quando a pessoa pedir para planejar a implementação de uma spec (por exemplo "/sdd-plan 001" ou "plano da spec da Fase 0"). Não escreve código de produção.
argument-hint: "<número da spec, ex.: 001>"
---

# sdd-plan

Converte uma spec **aprovada** em plano técnico e tarefas ordenadas. **Não implementa.**

## Antes de começar
1. Leia `CLAUDE.md`, `docs/arquitetura.md` e a spec em `docs/specs/$ARGUMENTS-*/spec.md`.
2. Confirme que o status é `aprovada` e que **não há perguntas em aberto**. Se não for o caso, pare e diga o que falta (sugira `/sdd-spec`).
3. Explore o código que será tocado: leia os arquivos reais, não presuma. Veja como componentes parecidos já foram feitos e reaproveite.

## O que fazer
1. Crie `plan.md` na pasta da spec com o modelo abaixo.
2. Crie `tasks.md` com tarefas pequenas, na ordem em que devem ser feitas. Cada tarefa:
   - cabe em uma sessão curta e deixa o app **compilando** (`fvm flutter analyze` limpo);
   - diz quais arquivos cria ou altera;
   - diz como conferir (qual critério de aceite da spec ela atende, ou o que olhar na tela);
   - fica em `- [ ]`.
3. Ligue cada critério de aceite da spec a pelo menos uma tarefa. Se algum critério ficar sem tarefa, ajuste.
4. Se o plano revelar que a spec está incompleta ou errada, **não corrija sozinho**: aponte, proponha a mudança e peça aprovação para atualizar a spec (com registro no "Histórico de mudanças").
5. Mostre um resumo do plano e das tarefas e **pare para aprovação**.

## Modelo do `plan.md`

```markdown
# Plano da NNN. Título

- **Spec:** spec.md
- **Criado em:** AAAA-MM-DD

## Abordagem
Em poucos parágrafos, como a spec será atendida e por quê.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | lib/app/... | ... |
| Alterar | lib/app/... | ... |

## Decisões técnicas
- Decisão, alternativas consideradas e motivo.

## Dependências e geração de código
Pacotes novos, assets, `build_runner`, mudanças de rota (`app_router.dart`), registro em `*_setup.dart`.

## Riscos e cuidados
O que pode quebrar (telas que usam o mesmo componente, regressões visuais) e como conferir.

## Como conferir
Comandos e telas a olhar (`fvm flutter analyze`, `fvm flutter run -d chrome`, larguras 390/768/1280).
```

## Modelo do `tasks.md`

```markdown
# Tarefas da NNN. Título

Legenda: `- [ ]` a fazer, `- [x]` feita.

## Grupo A: nome
- [ ] **A1.** Descrição curta. Arquivos: `...`. Atende: critério 2.
- [ ] **A2.** ...

## Grupo B: nome
- [ ] **B1.** ...
```

## Regras
- Respeite as convenções do `CLAUDE.md` (tokens do tema, sem `num_extension` em código novo, estados obrigatórios).
- Componentes compartilhados (navbar, rodapé, botões etc.) mudam várias telas: inclua uma tarefa de conferir as outras telas que os usam.
- Nada de tarefas vagas ("melhorar", "ajustar"). Cada uma deve ter um resultado verificável.
