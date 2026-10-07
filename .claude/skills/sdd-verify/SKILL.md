---
name: sdd-verify
description: Confere uma spec implementada contra seus critérios de aceite e o protótipo, e gera docs/specs/NNN-*/verificacao.md. Use quando a pessoa pedir para verificar, validar ou revisar uma implementação (por exemplo "/sdd-verify 001" ou "confere se a Fase 0 está pronta").
argument-hint: "<número da spec, ex.: 001>"
---

# sdd-verify

Confere o resultado com evidência, critério por critério. **Não corrige** o que achar sem combinar antes.

## Antes de começar
1. Leia `CLAUDE.md`, a `spec.md` e o `tasks.md` de `docs/specs/$ARGUMENTS-*`.
2. Veja o que mudou: `git status` e `git diff` (e `git log` se já houver commits da spec).
3. Se restarem tarefas `- [ ]`, avise: a verificação será parcial.

## O que conferir
1. **Análise estática e formatação:** `fvm flutter analyze` sem avisos novos e o projeto formatado (comando de conferência no `CLAUDE.md`, seção Comandos). Se houver arquivo fora do formato, formate-o.
2. **Compilação:** `fvm flutter build web --release` conclui sem erro (use quando a spec mexe em rotas, assets ou dependências; caso contrário, o `analyze` basta).
3. **Cada critério de aceite** da spec: marque `passou`, `não passou` ou `não conferido`, com a evidência (arquivo e linha, saída de comando ou o que foi visto na tela). Não escreva "passou" sem ter verificado.
4. **Telas:** rode o app (skill `run`, ou `fvm flutter run -d chrome`) e olhe em 390, 768 e 1280 px, comparando com a aba do protótipo. Confira estados de carregamento, vazio, erro e sem imagem. Abra ao menos uma vez em modo debug (`flutter run`): o build release esconde asserções de layout. Se não for possível abrir o app, diga isso e marque os critérios visuais como `não conferido`.
5. **Regras do `CLAUDE.md`:** procure no código alterado cores, tamanhos de fonte e espaçamentos soltos, `GestureDetector` sem foco/semântica, textos secundários com pouco contraste e comentários fora das regras (que dizem o quê, repetem o nome, citam spec, fase ou protótipo, ou código desativado). Remova os que sobrarem.
6. **Regressões:** para componentes compartilhados (navbar, rodapé, botões etc.), abra ao menos uma outra tela que os use e confirme que continua funcionando.
7. **Fora do escopo:** confirme que nada da lista "Fora do escopo" foi alterado.

## Saída
Crie `verificacao.md` na pasta da spec:

```markdown
# Verificação da NNN. Título

- **Data:** AAAA-MM-DD
- **Resultado:** aprovada | aprovada com ressalvas | reprovada

## Comandos
| Comando | Resultado |
|---|---|
| fvm flutter analyze | ... |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | ... | passou | ... |

## Problemas encontrados
- Descrição, onde, gravidade (bloqueia / ajuste / detalhe).

## Não conferido
O que não foi possível verificar e por quê.
```

Depois:
- Mostre um resumo curto com as pendências e **pergunte** o que a pessoa quer corrigir.
- Se o resultado for `aprovada` (ou `aprovada com ressalvas` que a pessoa aceite), mude o status da spec para `verificada` e marque o item no `docs/redesign/planejamento.md` com `→ specs/NNN-nome` e "concluído".
