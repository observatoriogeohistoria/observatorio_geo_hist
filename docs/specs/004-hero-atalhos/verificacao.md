# Verificação da 004. Home: hero e atalhos

- **Data:** 2026-09-26
- **Resultado:** aprovada com ressalvas (uma ressalva fora do escopo: opções do menu de categorias da navbar)

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found (antes e depois das correções) |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro, após as correções |
| `fvm flutter run -d web-server` (modo debug, cópia ASCII) + navegador embutido | usado para ver avisos de `overflow`, texto ampliado e semântica; nenhum aviso no console |
| Testes de widget temporários (só na cópia do scratchpad, não entram no repositório) | 35 testes passando: hero em 390, 600, 768, 1023, 1024 e 1280 px com texto a 100%, 150% e 200%; janela com 30 categorias de nome longo em 390×700, 390×400, 768×1024 e 1280×800 a 100% e 200%; estados da janela; foco preso; movimento reduzido; ações semânticas |
| `build/web` servida por servidor Python local (fallback de SPA) + navegador embutido | 390, 768 e 1280 px; `scrollWidth` igual à largura nas três |

Todas as tarefas do [tasks.md](tasks.md) estão marcadas. Revisão feita no código dos commits `518915c` e `99ad990`, não só no relatório da implementação.

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Hero primeiro, demais blocos intactos | passou | `home_page.dart`: `HomeHero` é o primeiro sliver depois do `NavbarSliver`; o diff dos outros slivers só acrescenta comentários. Na tela, Quem somos e demais blocos seguem abaixo |
| 2 | Rótulo, título com acento, apoio, botões e atalhos com os textos da spec | passou | `home_hero.dart` com os textos exatos; conferido na tela em 390, 768 e 1280 |
| 3 | "Explorar a biblioteca" → `/biblioteca`, "Ler o manifesto" → `/manifest` | passou | `home_hero.dart` (`AppRoutes.library` e `/manifest`); teste de widget com GoRouter |
| 4 | Atalho Biblioteca → `/biblioteca` | passou | `home_hero.dart`; conferido na implementação e no código |
| 5 | Janelas com categorias reais; Expogeo e Geoensine primeiro em Geografia | passou | Build release: "Categorias de Geografia" com Expogeo e Geoensine (ícone externo), divisor e as 8 categorias do banco |
| 6 | Categoria fecha a janela e abre a página; Expogeo/Geoensine abrem o site externo | passou | Build release: clique em "Eventos" levou a `/posts/geografia/1743476204112`. Links externos usam `openUrl` do mesmo componente da navbar (conferido na 002) |
| 7 | Fecha por "Fechar", Esc e clique fora; foco volta ao atalho | passou | Debug: 14 × Tab dentro da janela sem sair dela (foco em "Fechar", dentro do `role=dialog`), Esc fecha e o contorno de foco volta ao atalho Geografia. Teste de widget repete Tab, Esc e confere o `FocusNode` do atalho |
| 8 | Carregando, erro com "Tentar de novo" e vazio | passou | Teste de widget com o store real e repositório falso: esqueleto (`_LoadingRows`), "Nenhuma categoria por enquanto", "Tentar de novo" que busca de novo e mostra a categoria; Geografia vazia mantém Expogeo e Geoensine |
| 9 | Layout por faixa, 1120 px, sem rolagem horizontal nem `overflow` | passou | Release: 390 uma coluna, 768 três colunas com ícone acima, 1280 três colunas em linha; `scrollWidth` = largura nas três. Debug e testes de widget sem nenhum erro de `overflow`, inclusive com texto a 200% |
| 10 | Tab na ordem visual, foco visível, nome acessível, ícones ignorados | passou após correção | Ordem e contorno conferidos na implementação e de novo aqui. **Problema achado:** os atalhos (e todos os botões do site) não tinham ação de toque na semântica, então o clique do leitor de tela não fazia nada; e a janela não era anunciada como diálogo. Corrigido (ver abaixo) |
| 11 | Hover: borda, subida de 2 px, sombra; sem subida nem transição com movimento reduzido | passou | Teste de widget com mouse: `transform` −2 e 150 ms sem movimento reduzido; 0 e `Duration.zero` com `disableAnimations`. Janela: `transitionDuration` zero com movimento reduzido (código) |
| 12 | Contraste | passou | Calculado: rótulo `#A33600` sobre `#F7F5F2` 6,26:1; apoio e descrições `#5E5852` 6,45:1 (superfície) e 7,01:1 (branco); trecho `#C94400` 4,48:1 em texto grande (≥ 3:1) |
| 13 | Só tokens, sem `num_extension` | passou | Busca nos arquivos novos e nas correções: nenhum `.scale` de `num_extension`, `.fontSize`, `.verticalSpacing` ou `Color(0x`; números restantes são 0/1 geométricos. Novo token `heroShortcutsStackTextScale` |
| 14 | `analyze` e build release | passou | Ver comandos |

## Problemas encontrados e correções
1. **Leitor de tela não ativava atalhos nem botões** (bloqueia, acessibilidade). `Semantics(excludeSemantics: true)` escondia a ação do `InkWell` e não repetia `onTap`. Evidência: teste de widget com `hasAction(tap) == false` e, no navegador com semântica ligada, `click()` no elemento do atalho não abria a janela. Correção: `onTap` na semântica de `HeroShortcutCard` e de `AppButtonBase` (vale para todos os botões do site). Conferido: `hasAction(tap) == true` e o `click()` no elemento abre a janela. Commit `edd4e92`.
2. **Janela sem papel de diálogo** (ajuste). O nome existia, mas o elemento não tinha `role=dialog`. Correção: `role: SemanticsRole.dialog`. Conferido: `role=dialog` com `aria-label="Categorias de Geografia"`. Commit `edd4e92`.
3. **Título quebrava palavras com texto ampliado** (ajuste). A largura máxima em "em" não acompanhava a ampliação. Correção: largura calculada com `MediaQuery.textScalerOf`. Conferido: a 200% o título fica com a mesma estrutura de linhas de 100% (teste) e sem palavra cortada no navegador. Commit `e1b0e89`.
4. **Atalhos quebravam títulos ao meio com texto ampliado** (ajuste). A 200% em 768 px, "Geograf-ia" e "Bibliote-ca". Correção: a partir de 130% de texto os atalhos ficam em uma coluna (token `heroShortcutsStackTextScale`). Conferido no navegador: 125% em 768 e 1024 px mantém três colunas sem quebra; 200% em 768 px fica em uma coluna. Commit `e1b0e89`. Spec atualizada (Responsivo).

## Ressalvas
- **Opções do menu de categorias (navbar) sem ação de toque na semântica.** `NavbarMenuOption` tem o mesmo padrão do problema 1, e é ele que monta as opções da janela de categorias. Não corrigido aqui porque mudanças na navbar estão fora do escopo da 004. Sugestão: repetir `onTap` na semântica de `NavbarMenuOption` (e revisar outros `Semantics(excludeSemantics: true)` do site) numa correção própria.

## Não conferido
- Leitor de tela real (VoiceOver/NVDA): conferido pela árvore de semântica e pelo DOM de acessibilidade do Flutter Web, não com leitor de tela.
- Movimento reduzido no navegador: conferido por teste de widget e leitura de código (o navegador embutido não emula `prefers-reduced-motion` para o Flutter).
