---
name: sdd-implement
description: Implementa as tarefas de docs/specs/NNN-*/tasks.md em ordem, marcando o progresso, seguindo a spec e o plano. Use quando a pessoa pedir para implementar, executar ou continuar uma spec (por exemplo "/sdd-implement 001" ou "continua a implementação da Fase 0").
argument-hint: "<número da spec, ex.: 001> [tarefa, ex.: A2]"
---

# sdd-implement

Executa o plano **uma tarefa por vez**, com a spec como referência.

## Antes de começar
1. Leia `CLAUDE.md`, a `spec.md`, o `plan.md` e o `tasks.md` da pasta `docs/specs/$ARGUMENTS-*`.
2. Confirme que a spec está `aprovada` e que o plano foi aprovado. Se não, pare e diga o que falta.
3. Rode `git status`. Se houver alterações que não são desta spec, avise antes de continuar.
4. Encontre a próxima tarefa `- [ ]` (ou a que a pessoa indicou).

## Ciclo de cada tarefa
1. Diga em uma linha qual tarefa vai fazer.
2. Releia os arquivos que ela toca antes de editar. Siga o padrão do código ao redor (nomes, idioma). Comentários só pelas regras do `CLAUDE.md`: raros, curtos, dizendo o porquê, sem citar spec, fase ou protótipo.
3. Implemente **só** o que a tarefa pede. Não adiante tarefas seguintes nem "aproveite" para refatorar outras áreas.
4. Se alterou stores MobX ou modelos gerados, rode `fvm dart run build_runner build --delete-conflicting-outputs`.
5. Rode `fvm dart format` nos `.dart` que a tarefa alterou (não nos gerados) e depois `fvm flutter analyze`. Corrija o que a tarefa introduziu. Não deixe avisos novos.
6. Confira a tarefa contra o critério de aceite ligado a ela. Quando fizer sentido, rode o app (`fvm flutter run -d chrome`) e olhe a tela em 390, 768 e 1280 px, comparando com o protótipo.
7. Marque `- [x]` no `tasks.md` e acrescente, se útil, uma nota curta ("feito com X porque Y").
8. Ao fim de cada **grupo** de tarefas, faça um resumo (o que mudou, o que conferir) e **pare** para a pessoa revisar antes do grupo seguinte.

## Quando algo não bate com a spec
- **Pare.** Explique o problema e proponha a mudança na spec (ou no plano).
- Só siga depois de a pessoa aprovar, e registre a mudança no "Histórico de mudanças" da spec. Não implemente uma divergência em silêncio.

## Regras
- Siga as regras de design do `CLAUDE.md`: tokens do tema, contraste, foco visível, estados de carregamento/vazio/erro, imagens sem proporção garantida.
- **Não faça commit nem push**, a menos que a pessoa peça. Lembre: push na `main` publica o site.
- Não crie testes nem dependências que o plano não previu. Se precisar de um pacote novo, pergunte.
- Ao concluir todas as tarefas, mude o status da spec para `implementada` e sugira rodar `/sdd-verify`.
