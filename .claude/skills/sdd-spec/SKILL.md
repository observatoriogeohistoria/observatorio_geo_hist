---
name: sdd-spec
description: Cria a especificação (spec.md) de uma feature a partir de um pedido ou de um item de docs/future-ideas.md. Use quando a pessoa pedir para especificar, detalhar ou "começar" uma feature ou tela (por exemplo "spec da busca geral" ou "/sdd-spec copiar citação"). Não escreve código.
argument-hint: "<feature ou item de future-ideas.md, ex.: busca geral>"
---

# sdd-spec

Transforma um pedido numa especificação clara e conferível. **Não escreve código** e **não cria plano técnico**.

## Antes de começar
1. Leia `CLAUDE.md`, `docs/specs/README.md` e, se o pedido vier de lá, o item em `docs/future-ideas.md`. As decisões de design estão em `docs/redesign-history.md`.
2. Identifique o pedido em `$ARGUMENTS`. Se for ambíguo, pergunte.
3. Ache o próximo número (`NNN`): o maior entre as pastas de `docs/specs/` e o histórico do git (`git log --all --name-only --format= -- docs/specs | grep -o 'specs/[0-9]*' | sort -u | tail -1`). Se já existir spec em andamento para o pedido, pergunte se é para atualizar.
4. Se a tela existir no **protótipo** (link em `CLAUDE.md`), abra a aba correspondente. Leia o código atual que será afetado, para descrever o que muda em relação ao que existe.

## O que fazer
1. Crie `docs/specs/NNN-short-name/spec.md` (nome em inglês) com o modelo abaixo. Escreva para quem vai revisar: frases curtas, sem jargão de implementação.
2. Descreva **comportamento observável**, não estrutura de código. Nada de nomes de classes novas nem de arquitetura: isso é do plano.
3. Escreva critérios de aceite que possam ser conferidos como "passou" ou "não passou" (com larguras 390, 768 e 1280 px quando houver layout).
4. Tudo o que não estiver decidido vira **pergunta em aberto**. Não invente. Pergunte à pessoa (use `AskUserQuestion` quando forem poucas decisões objetivas) e registre as respostas na spec.
5. Ao terminar, mostre um resumo curto, liste as perguntas que ainda restam e **pare para aprovação**. Só mude o status para `aprovada` quando a pessoa disser que aprova.

## Modelo do `spec.md`

```markdown
# NNN. Título da feature

- **Status:** rascunho
- **Origem:** pedido de AAAA-MM-DD ou item de future-ideas.md
- **Protótipo:** aba "Home" (link no CLAUDE.md), se houver
- **Criada em:** AAAA-MM-DD

## Objetivo
Uma ou duas frases: o que a pessoa que usa o site passa a conseguir ou ver, e por quê.

## Situação atual
Como funciona hoje (com os arquivos principais), em poucas linhas.

## Comportamento
O que muda, tela por tela ou seção por seção. Inclua textos reais da interface.

## Estados
- **Carregando:**
- **Vazio:**
- **Erro:**
- **Sem imagem / imagem com falha:** (quando houver imagens)
- **Casos de borda:** (0, 1, 2 e muitos itens, texto muito longo etc.)

## Responsivo
Comportamento em celular (390), tablet (768) e desktop (1280).

## Acessibilidade
Foco por teclado, nomes acessíveis, contraste, movimento reduzido.

## Dados e regras de negócio
Que dados a tela usa e o que não pode mudar (modelos, rotas, regras já existentes).

## Critérios de aceite
- [ ] Critério 1, conferível
- [ ] Critério 2

## Fora do escopo
O que fica de fora de propósito.

## Perguntas em aberto
- Nenhuma. (ou lista)

## Histórico de mudanças
- AAAA-MM-DD: criada.
```

## Regras
- Uma spec cobre uma entrega que a pessoa consiga revisar de uma vez. Se o pedido for grande, proponha dividir em várias specs e pergunte.
- Siga as regras de design do `CLAUDE.md` nos critérios de aceite (tokens, contraste, estados obrigatórios).
