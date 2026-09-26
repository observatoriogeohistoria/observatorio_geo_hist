# Verificação da 002. Botões, navbar e rodapé

- **Data:** 2026-09-26 (segunda rodada, com o app rodando)
- **Resultado:** aprovada com ressalvas (após as correções da 2ª rodada; ressalvas em "Não conferido")

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro |
| Build release servida localmente, operada no navegador em 390, 768, 1024 e 1280 px | ver critérios |
| `fvm flutter run -d web-server` (debug), mesmas telas | nenhum `RenderFlex overflowed` nem exceção do Flutter no console |

Todas as tarefas do [tasks.md](tasks.md) estão marcadas.

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Botões: 3 tipos, 3 tamanhos, repouso, hover, foco, desativado, texto longo | passou (hover só por código) | Tela provisória da 1ª rodada (tipos, tamanhos, desativado, quebra de linha). Anel de foco visto no botão "Manifesto" da Home ao navegar por Tab. Hover por leitura de [app_button_base.dart](../../../lib/app/core/components/buttons/app_button_base.dart) |
| 2 | Enter/Espaço acionam; discreto com foco | passou parcial | Enter e Espaço acionaram os itens da navbar e o botão de menu (todos `InkWell`). Botão discreto com foco não operado em tela |
| 3 | Painel admin e site abrem sem erro | passou parcial | Home, manifesto, categoria, biblioteca, lista da biblioteca (com filtros), contato, colaborar, 404 e login do admin abrem. **Painel logado não aberto** (exige credenciais) |
| 4 | Logo SVG na navbar e no rodapé, nítido | passou | Visto em 390, 768, 1024 e 1280. No celular só "Observatório", como a spec pede |
| 5 | Navbar fixa em todas as páginas | passou | Visto rolando em categoria (1280), manifesto (768) e Home (390): a navbar fica no topo, translúcida. Presente em biblioteca, contato, colaborar e 404. Membro e post não abertos (mesma `NavbarSliver`) |
| 6 | Item ativo laranja com sublinhado | passou | Sobre na Home, História em `/posts/historia/...`, Biblioteca em `/biblioteca`. No painel de celular, "Sobre" em laranja na Home |
| 7 | Menus desktop: hover, teclado, fechamento | passou (após correção) | Abre por clique e teclado; fecha com Esc (foco volta ao item), clique fora e ao escolher uma categoria. Depois da correção: Espaço em Geografia foca Expogeo; seta para baixo em História foca Audiovisual; Tab com o menu aberto fecha e vai a "Biblioteca". Antes: o foco ficava no painel sem item marcado e o Tab pulava "Biblioteca" |
| 8 | Geografia: Expogeo e Geoensine primeiro, divisor, outra aba | passou parcial | Ordem, ícone de link externo e divisor vistos no desktop e na sanfona. Abrir em outra aba não conferido: o navegador de teste bloqueia pop-ups disparados por mim |
| 9 | Menu de celular/tablet | passou | 768 e 390: painel abre (em 390 ocupa a largura), sanfonas de História e Geografia, escolher "Narrativas" fecha e navega, Esc fecha e devolve o foco ao botão de menu, toque fora fecha, foco preso no painel (Tab circula Fechar → Sobre → História → Geografia → Biblioteca) |
| 10 | Estados carregando, vazio e erro | não conferido | Código em [navbar_categories_menu.dart](../../../lib/app/core/components/navbar/navbar_categories_menu.dart). Não consegui forçar lentidão nem falha do Firestore no navegador de teste |
| 11 | Rodapé 4/2/1 colunas, links, sem "Colabore" e "Nossa história" | passou parcial | 4 colunas em 1024 e 1280, 2 em 768, 1 em 390. Sem "Colabore" e "Nossa história". `mailto:`/`tel:` e redes não clicados. Linha da licença Creative Commons adicionada e vista em 390, 768, 1024 e 1280 |
| 12 | Ano dinâmico | passou | `DateTime.now().year` em [footer.dart](../../../lib/app/core/components/footer/footer.dart#L98); tela mostra 2026 |
| 13 | Foco visível e nome acessível em todo clicável | passou parcial | Anel visto em logo, itens da navbar, opções do menu, botão de menu, botão Fechar, itens do painel e botão da página. Ordem de Tab segue a visual (logo → Sobre → História → Geografia → Biblioteca → conteúdo). Links do rodapé não percorridos por Tab |
| 14 | Contraste ≥ 4,5:1 | passou | Tabela abaixo |
| 15 | Só tokens, sem `num_extension` nos novos | passou com ressalva | `grep` nos componentes novos: só `Colors.transparent`, alturas de linha (1,1 a 1,7), opacidade 0,5 do desativado, `blur 10` da navbar, `bottom: 2` do sublinhado e `-0.03` do logo. `AppIconButton` e `CustomIconButton` mantêm `.scale`, que já usavam |
| 16 | Sem rolagem horizontal nem `overflow` em 390/768/1280 | passou | Build de debug em 390 (Home com menu aberto, lista da biblioteca e filtros, 404), 768 (lista da biblioteca) e 1024 (404): nenhum aviso de `overflow` no console. Release em 1280 sem cortes visíveis |
| 17 | `analyze` sem novos avisos | passou | saída acima |

### Contraste (WCAG)
| Par | Razão |
|---|---|
| branco / acento (primário repouso) | 4,87 |
| branco / acento forte (primário hover) | 6,81 |
| acento / branco (item ativo) | 4,87 |
| acento forte / branco (discreto repouso) | 6,81 |
| acento forte / acento suave (discreto hover, opção marcada) | 6,11 |
| acento forte / superfície (opção com hover) | 6,26 |
| tinta / branco | 17,10 |
| texto secundário / branco (subtítulo do logo) | 7,01 |
| branco / tinta (secundário hover) | 17,10 |
| rodapé texto / fundo | 11,65 |
| rodapé destaque / fundo | 8,37 |
| branco / fundo do rodapé | 17,49 |

## Problemas encontrados
Todos corrigidos na 2ª rodada e conferidos de novo no navegador (build release), com `analyze` limpo:
- ~~**Bloqueia:** Tab com o menu aberto pulava "Biblioteca".~~ O Tab agora fecha o menu e só move o foco depois que o painel sai da tela (`_closeAndMoveFocus` em [navbar_dropdown.dart](../../../lib/app/core/components/navbar/navbar_dropdown.dart)). Vale também para Tab no próprio item com o menu aberto.
- ~~**Ajuste:** Enter, Espaço e seta para baixo não levavam o foco ao primeiro item.~~ `_focusFirstOption` usa a política de ordem de Tab para achar a primeira opção.
- ~~**Ajuste:** faltava a linha da licença no rodapé.~~ `AppStrings.footerLicense` na faixa inferior de [footer.dart](../../../lib/app/core/components/footer/footer.dart).
- ~~**Detalhe:** o endereço do rodapé quebrava mal em 1024 e 1280 px.~~ Explorar e Institucional com largura do conteúdo; marca e contato em 4:3. Medido com a Figtree 14 px: endereço 279 px, e-mail 252 px; em 1024 px as colunas ficam com cerca de 379 e 284 px.
- **Não é defeito:** o fundo cinza "preso" no painel de celular era o hover do `InkWell` com o ponteiro parado sobre a linha.
- **Já resolvido:** `AppFocusRing` escuta `addHighlightModeListener`, então troca de mouse para teclado atualiza o anel.

## Não conferido
- Painel admin logado com os botões novos (exige credenciais; pedir para a pessoa abrir).
- Estados carregando, vazio e erro do menu de categorias.
- Links externos (Expogeo, Geoensine, redes) abrindo em outra aba, e `mailto:`/`tel:` abrindo os aplicativos.
- Hover dos botões; movimento reduzido ligado.
- Páginas de membro e de post abertas (usam a mesma `NavbarSliver`).
- Links do rodapé percorridos por Tab.
