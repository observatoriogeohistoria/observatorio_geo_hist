# Verificação da 007. Home: resumo de Nossa história

- **Data:** 2026-09-26
- **Resultado:** aprovada (dois detalhes encontrados e corrigidos em `737389c`: período do selo partido a 390 px; linha divisória colada ao resumo quando a Equipe não carrega)

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found, antes e depois das correções |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro, antes e depois das correções |
| Build servido por Python com fallback de SPA + navegador embutido | 390, 768 e 1280 px; `scrollWidth` igual à largura; console sem `overflow` |
| Build de teste com `TextScaler` 2,0 no `MaterialApp`, só no scratchpad | texto a 200% em 390 px na Home e em `/nossa-historia` |
| Script comparando os parágrafos de `our_history_page.dart` com `git show 69ca4e2:.../our_history.dart` | três parágrafos idênticos, mesma ordem |

Todas as tarefas do [tasks.md](tasks.md) estão marcadas. Revisão feita no código dos commits `f40baa9..7ea51d1`, não só no relatório da implementação.

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Resumo abaixo do vídeo e antes da Equipe, sem divisória; bloco antigo sumiu | passou | `home_page.dart`: vídeo → `OurHistorySummarySection` → Equipe; `our_history.dart` apagado. Tela: vídeo → faixa de superfície → Parceiros (Equipe vazia no Firebase de testes). Depois da correção 2, sem linha entre o resumo e o bloco seguinte |
| 2 | Textos exatos, rótulo, título, selo com ícone, dois parágrafos, link, fundo de superfície | passou | Strings iguais à spec e ao protótipo (aba Home, `.section.tint .narrow`); tela em 390 e 1280 |
| 3 | "Ler a história completa" abre `/nossa-historia` por clique, Enter e leitor de tela | passou | Clique real a 1280: `/nossa-historia` no topo. Semântica: `link "Ler a história completa"`. Enter: `ArrowLink` (`InkWell` + `AppFocusRing`, já conferido na 006) |
| 4 | Página com navbar, cabeçalho, três parágrafos idênticos e rodapé; abre no topo; acesso direto | passou | Script de comparação (idêntico); acesso direto a `/nossa-historia` em 768 e 1280 |
| 5 | Voltar do navegador retorna à Home | passou | `navigate back` a partir de `/nossa-historia` → `/` |
| 6 | "Nossa história" no rodapé entre Manifesto e Equipe | passou | `footer.dart`; rodapé visto em `/nossa-historia`, `/manifest`, `/biblioteca` e Home |
| 7 | Nenhuma rota existente muda | passou | `app_router.dart` só com acréscimo; `/`, `/manifest`, `/biblioteca` abrem |
| 8 | Colunas de 720 px (resumo) e 680 px (página) | passou | Tokens `ourHistorySummaryMaxWidth` e `readingMaxWidth`; tela a 1280 e 768 |
| 9 | Selo quebra dentro da pílula | passou | 390 px e 200%: quebra dentro do selo, sem `overflow`. A 390 px o período partia em "2016–/2018"; corrigido (espaço rígido e *word joiner*), agora quebra antes de "· 2016–2018" |
| 10 | Cabeçalhos, decorativos ignorados, foco e ordem por Tab | passou | Árvore de semântica: título do resumo e da página como `heading`; selo lido como texto; ícone em `ExcludeSemantics`. Foco: `AppFocusRing` no link e no rodapé |
| 11 | Contrastes | passou | `#A33600` sobre `#F7F5F2` = 6,26:1; sobre `#FFF0E6` = 6,11:1; `ink` ≥ 15:1 |
| 12 | Rodapé na base com janela alta | passou | 1280 × 2400 e 768 × 2400: rodapé colado na base |
| 13 | Sem rolagem horizontal, sobreposição ou `overflow` | passou | `scrollWidth` = largura em 390, 768 e 1280; 200% em 390 sem sobreposição |
| 14 | Só tokens, sem `num_extension`; analyze e build | passou | Diff sem cores, fontes ou espaçamentos soltos; comandos acima |

## Regressão do rodapé (commit `f40baa9`)
O tablet troca `LayoutBuilder` + `Wrap` por duas linhas de duas colunas (`Row` + `Expanded`). Conferido a 768 px em `/nossa-historia`, `/manifest` e `/biblioteca`: marca e Explorar na primeira linha, Institucional e Contato na segunda, mesmo visual de antes. Desktop e celular não mudam.

## Problemas encontrados
- **Período do selo partido** (detalhe, corrigido): a 390 px o selo quebrava em "2016–" / "2018".
- **Divisória colada ao resumo** (detalhe, corrigido): com a Equipe vazia ou carregando, a `AppDivider` que vinha depois dela aparecia logo abaixo da faixa de superfície. Agora a divisória só aparece junto com a Equipe.

## Não conferido
- Tab + Enter no navegador embutido: o painel não entregou o Tab ao Flutter (sem foco visível). Coberto pelo código (`ArrowLink` e `_FooterLink` com `InkWell` + `AppFocusRing`, os mesmos conferidos na 006).
- Transição do resumo para a Equipe com dados reais: o Firebase de testes não tem equipe. Pelo código, a Equipe usa o fundo da página, o que separa os blocos como no protótipo.
- Painel admin: não se aplica.
