---
name: sdd-spec
description: Cria a especificação (spec.md) de uma feature do redesign a partir de um item de docs/redesign/planejamento.md. Use quando a pessoa pedir para especificar, detalhar ou "começar" uma fase, seção ou tela (por exemplo "spec da Fase 0" ou "/sdd-spec 1.2"). Não escreve código.
argument-hint: "<item do planejamento, ex.: Fase 0, 1.2, T-04>"
---

# sdd-spec

Transforma um item do planejamento numa especificação clara e conferível. **Não escreve código** e **não cria plano técnico**.

## Antes de começar
1. Leia `CLAUDE.md`, `docs/redesign/planejamento.md` e `docs/specs/README.md`.
2. Identifique o item pedido em `$ARGUMENTS`. Se for ambíguo, pergunte qual.
3. Veja `docs/specs/` para achar o próximo número (`NNN`) e conferir se já existe spec para o item. Se existir, pergunte se é para atualizar.
4. Abra o **protótipo** (link em `CLAUDE.md`, aba correspondente) e leia o código atual dos arquivos citados no item, para descrever o que muda em relação ao que existe.

## O que fazer
1. Crie `docs/specs/NNN-nome-curto/spec.md` com o modelo abaixo. Escreva para quem vai revisar: frases curtas, sem jargão de implementação.
2. Descreva **comportamento observável**, não estrutura de código. Nada de nomes de classes novas nem de arquitetura: isso é do plano.
3. Escreva critérios de aceite que possam ser conferidos como "passou" ou "não passou" (com larguras 390, 768 e 1280 px quando houver layout).
4. Tudo o que não estiver decidido vira **pergunta em aberto**. Não invente. Pergunte à pessoa (use `AskUserQuestion` quando forem poucas decisões objetivas) e registre as respostas na spec.
5. Ao terminar, mostre um resumo curto, liste as perguntas que ainda restam e **pare para aprovação**. Só mude o status para `aprovada` quando a pessoa disser que aprova.

## Modelo do `spec.md`

```markdown
# NNN. Título da feature

- **Status:** rascunho
- **Item do planejamento:** ex. Fase 1, seção 1.2
- **Protótipo:** aba "Home" (link no CLAUDE.md)
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
- Uma spec cobre uma entrega que a pessoa consiga revisar de uma vez. Se o item for grande (uma fase inteira), proponha dividir em várias specs e pergunte.
- Não copie o planejamento inteiro: referencie o item e detalhe só o necessário.
- Siga as regras de design do `CLAUDE.md` nos critérios de aceite (tokens, contraste, estados obrigatórios).
- Atualize o item no `docs/redesign/planejamento.md` com a referência `→ specs/NNN-nome` só depois de a spec ser aprovada.
