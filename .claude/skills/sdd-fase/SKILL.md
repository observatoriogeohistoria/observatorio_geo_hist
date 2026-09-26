---
name: sdd-fase
description: Conduz uma fase inteira do redesign (ou um intervalo de itens) do começo ao fim, sem paradas, passando por spec, plano, implementação, verificação com correções, commits e push na branch de trabalho. Cada etapa roda numa sessão separada (subagente) para poupar contexto. Use só quando a pessoa pedir explicitamente, por exemplo "/sdd-fase Fase 1" ou "/sdd-fase 1.1-1.4".
argument-hint: "<fase ou itens do planejamento, ex.: Fase 1, 1.1-1.3>"
disable-model-invocation: true
---

# sdd-fase

Modo **autônomo** do fluxo SDD (`docs/specs/README.md`). A pessoa não vai acompanhar: não pergunte nada, decida seguindo os padrões do projeto e registre cada decisão. Esta sessão é a **orquestradora**: ela divide o trabalho, dispara as sessões de cada etapa, faz os commits de documentação, o push e o resumo final. Ela **não** escreve código nem lê arquivos grandes; quem faz isso são as sessões de etapa.

## 0. Preparação (orquestradora)
1. Leia `CLAUDE.md`, `docs/specs/README.md`, a seção da fase em `docs/redesign/planejamento.md` e a lista de perguntas (Q-xx). Não leia código.
2. Confira o git. Push na `main` publica em produção e push na `develop` publica no ambiente de dev, então **nunca** faça commit ou push direto nessas duas.
   - `git status` limpo. Se houver alterações soltas, não as misture: registre no resumo e siga só se não tocarem os arquivos da fase; senão, pare e explique.
   - Crie a branch da fase a partir da `develop` atualizada: `git fetch origin && git switch -c refactor/redesign-<fase> origin/develop` (ex.: `refactor/redesign-fase-1`). Se ela já existir (retomada), apenas troque para ela.
3. **Retomada:** se existir `docs/specs/execucao-<fase>.md`, continue de onde parou (etapa e spec marcadas como pendentes) em vez de recomeçar.
4. Divida a fase em specs. Regra: cada item do planejamento que é "entregue e revisado isoladamente" vira uma spec; itens pequenos e vizinhos que mexem nos mesmos arquivos (ex.: dois blocos simples da Home) podem ir juntos. Alvo: meio dia a um dia de trabalho por spec. Números seguem o próximo `NNN` livre em `docs/specs/`. Respeite a coluna "Depende de": o que depende de outro item vem depois dele.
5. Crie `docs/specs/execucao-<fase>.md` (ex.: `execucao-fase-1.md`) com a tabela abaixo. Esse arquivo é o **estado** da execução e permite retomar em outra conversa se o limite de uso acabar. Ele entra no primeiro commit de documentação da fase (não precisa de commit próprio).

```markdown
# Execução da <fase>

- **Início:** AAAA-MM-DD
- **Branch:** refactor/redesign-<fase> → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 004-hero-atalhos | 1.1 | pendente | pendente | pendente | |

## Decisões tomadas sem a pessoa
- (spec, decisão, motivo)

## Ressalvas
- (spec, ponto, o que foi tentado)

## Ocorrências
- (limites, falhas de ambiente, retomadas)
```

## Commits: entregas separadas, sem excesso
O histórico deve contar a história da fase: cada commit é uma entrega que dá para entender sozinha, e o app compila em todos. Nem um commit gigante por spec, nem um por tarefa. Referência por spec (costuma dar de 3 a 6):

| Commit | Conteúdo |
|---|---|
| `docs: spec e plano da NNN` | spec, plano, tarefas (e o arquivo de execução atualizado) |
| `feat:`/`refactor:` (1 a 3) | um por parte **visível ou coerente** da entrega (ex.: "componente do card de destaque", "seção de destaques na Home com estados"). Tokens novos do tema entram junto do primeiro uso. Mudança em componente compartilhado que afeta outras telas vai em commit próprio |
| `fix:` | correções da verificação. Agrupe as pequenas num só; separe só a que for relevante por si |
| `docs: verificação da NNN` | `verificacao.md`, status, planejamento e arquivo de execução |

Mensagens `tipo: descrição` em português, dizendo o que muda para quem usa o site. Corpo curto quando o título não basta. Terminar com a linha de coautoria definida pelo ambiente. Nunca `git add -A` às cegas: adicione os arquivos da entrega.

## 1. Ciclo por spec (em ordem, uma de cada vez)
Specs da mesma fase costumam mexer na mesma página: **não rode em paralelo**. Para cada spec, dispare **três sessões novas** com a ferramenta `Agent` (`subagent_type: general-purpose`, `run_in_background: false`), uma por etapa. Cada prompt deve ser autossuficiente: caminho do projeto, número da spec, o bloco "Regras do modo autônomo" abaixo (copiado inteiro) e o que devolver. Não repasse conteúdo de arquivos; passe caminhos.

### 1a. Sessão de spec + plano
- Invocar `/sdd-spec <itens>` e, na mesma sessão, `/sdd-plan <NNN>`.
- Onde as skills mandam "pare para aprovação" ou "pergunte": decidir pela recomendação mais alinhada ao protótipo, ao planejamento e às decisões já registradas (perguntas Q-xx, specs anteriores), registrar em "Perguntas em aberto" como respondida ("Decidido no modo autônomo: ... porque ...") e marcar a spec como `aprovada`.
- Ao fim, o plano deve ligar cada critério de aceite a uma tarefa e ter uma tarefa final de conferência rodando o app.
- **Não faz commit.** Devolve: caminho da spec, número de critérios e de tarefas, decisões tomadas, riscos.
- A orquestradora atualiza o arquivo de execução e faz o commit `docs: spec e plano da <NNN>`.

### 1b. Sessão de implementação
- Invocar `/sdd-implement <NNN>` e executar **todas** as tarefas, sem parar entre grupos.
- Divergência da spec: aceitar o ajuste recomendado, atualizar a spec (histórico) antes do código, seguir.
- **Commits por entrega coerente** (seção "Commits" acima, que deve ir no prompt): normalmente 1 a 3 `feat`/`refactor` por spec, cada um compilando. Não fazer um commit por tarefa. Marcações do `tasks.md` vão junto do commit correspondente. Nada de push.
- Devolve: commits feitos, tarefas com nota relevante, divergências, o que não conseguiu conferir.

### 1c. Sessão de verificação e correção
- Invocar `/sdd-verify <NNN>` e revisar o código de verdade, não só o relatório da implementação.
- Para cada problema encontrado, **um de cada vez**:
  1. corrigir;
  2. conferir de novo (comando, tela ou teste manual que mostrou o problema);
  3. se não resolveu, tentar outra abordagem, **no máximo 2 tentativas** por problema;
  4. resolveu: seguir para o próximo (o commit vem no fim);
  5. não resolveu depois de 2 tentativas: desfazer a tentativa se ela piorou algo, registrar em `verificacao.md` como ressalva (o que é, o que foi tentado, por que parou) e seguir.
- Ao fim das correções: um commit `fix:` com as correções pequenas e, se houver, um commit próprio para cada correção relevante por si.
- Status final: `verificada` (sem ressalvas) ou `verificada com ressalvas`. Marcar o item no planejamento com `→ specs/NNN-nome`.
- Commit `docs: verificação da <NNN>` (inclui o arquivo de execução, que a orquestradora pode completar antes).
- Devolve: situação por critério, correções (resolvidas ou não), ressalvas, commits.

### 1d. Fechamento da spec (orquestradora)
1. Atualizar `execucao-<fase>.md` (etapas, resultado, decisões, ressalvas). Se a verificação já fez o commit de docs, use `git commit --amend` só se ainda não houve push; senão, deixe para o próximo commit de docs.
2. `git push -u origin refactor/redesign-<fase>` (**nunca** `main` ou `develop`, nunca `--force`). Push a cada spec protege o trabalho se a execução for interrompida.
3. Se a verificação reprovou algo que **bloqueia** as specs seguintes (ex.: página não compila), abra uma sessão extra de correção com as mesmas regras de 2 tentativas antes de seguir. Se ainda bloquear, pare a fase e vá para o resumo final.

## Regras do modo autônomo (copiar em todo prompt de etapa)
```
MODO AUTÔNOMO: a pessoa está ausente e pré-aprovou o fluxo. Não use AskUserQuestion e não pare para aprovação; onde as skills sdd-* mandam parar ou perguntar, decida pela opção recomendada, registre a decisão no documento da spec e siga.
Leia CLAUDE.md antes de tudo e siga suas regras de design, idioma e git.
Git: trabalhe na branch atual (refactor/redesign-<fase>); nunca push; nunca commit na main nem na develop; nunca --force, reset --hard ou apagar branch.
Limites do que você pode decidir sozinha: não altere modelos de dados, regras/coleções do Firebase, rotas existentes, o painel admin nem nada em "Fora do escopo"; não adicione pacotes sem que o plano preveja; não apague conteúdo real. Se a tarefa exigir isso, registre como ressalva e pule só aquele ponto.
Ambiente:
- `fvm flutter analyze` quebra na pasta original por causa do "ó" no caminho. Rode-o numa cópia em caminho ASCII no scratchpad (rsync sem build/ e .dart_tool/, depois `fvm flutter pub get`). Symlink não resolve.
- Para ver a tela: `fvm flutter build web --release`, servir build/web com um servidor Python próprio em background (com fallback de SPA para index.html) e abrir no navegador embutido (mcp__Claude_Browser__*). Conferir 390, 768 e 1280 px e voltar o navegador ao preset desktop no fim. Parar os servidores ao terminar.
- Protótipo: link no CLAUDE.md; ler com a ferramenta Artifact (action read), não com WebFetch.
- Painel admin: só entrar se a tarefa exigir e se houver credenciais de teste neste prompt; senão marcar como não conferido.
Resposta final: no máximo ~300 palavras, em tópicos, só o pedido. Não cole diffs nem conteúdo de arquivos.
```

Se a pessoa tiver informado credenciais de teste na conversa, a orquestradora as acrescenta ao prompt da sessão que precisar delas. **Nunca** as grave em arquivo do repositório.

## 2. Encerramento (orquestradora)
1. Conferir `git status` limpo e `git log` com os commits da fase.
2. Atualizar a memória do projeto (estado do redesign) e, se preciso, `docs/arquitetura.md` com o que a fase introduziu de padrão novo, de forma breve.
3. Fechar `execucao-<fase>.md` com a data de término, fazer commit (`docs: encerramento da <fase>`) e push.
4. **Abrir PR para `develop`** com `gh pr create --base develop --head refactor/redesign-<fase>`. Siga o formato do PR da Fase 0 (#19): título `feat: redesign <fase> — <resumo>`; corpo com "Resumo" (links para planejamento e protótipo), uma seção por spec com links para spec e verificação e os pontos principais, "Decisões tomadas no modo autônomo", "Ressalvas", "Como testar" e a linha de atribuição definida pelo ambiente. Se já existir PR aberto da branch, só atualize a descrição.
   - Depois de abrir, acompanhe o CI (`ci.yml` roda em PR para `develop`) com as ferramentas `ccd_pr` (ou `gh pr checks`). Se falhar por causa da fase, corrija com a mesma regra de 2 tentativas, commit `fix:` e push. **Não faça merge** nem ative auto-merge: o merge em `develop` publica no ambiente de dev e fica com a pessoa.
5. Responder à pessoa com o **resumo final**:
   - link do PR e situação do CI;
   - tabela por spec: itens, resultado (verificada / com ressalvas / não concluída), nº de commits;
   - decisões tomadas sem ela (as que ela talvez queira rever primeiro);
   - ressalvas e o que ficou sem conferir (ex.: validação que só vale após o deploy);
   - ocorrências (falhas de ambiente, retomadas, limite de uso);
   - próximo passo sugerido (próxima fase ou revisão visual de algo específico).

## Se o limite de uso estiver perto
Pare **entre** etapas, nunca no meio de uma: garanta commits feitos, `execucao-<fase>.md` atualizado com a etapa seguinte como `pendente`, push, e um resumo dizendo como retomar (`/sdd-fase <mesma fase>`).

## Economia de contexto
- A orquestradora só lê o planejamento, o arquivo de execução e os relatórios curtos das sessões. Para conferir algo pontual, use `git log --stat` ou `grep`, não leia arquivos inteiros.
- Cada etapa começa numa sessão nova: a spec, o plano e o `tasks.md` são a memória entre elas.
- Se uma sessão de etapa voltar sem terminar (limite ou erro), dispare outra para a mesma etapa pedindo para continuar a partir do `tasks.md`/`verificacao.md`, em vez de refazer.
