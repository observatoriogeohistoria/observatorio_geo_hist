# Verificação da 023. Login e estrutura do painel nos tokens novos

- **Data:** 2026-10-06
- **Resultado:** aprovada com ressalvas (não conferido o que depende de login)

Revisão do código de `7d61dc2`, `c0a1b44` e `4c615bb` (`git diff develop...HEAD`) e do app numa cópia em caminho ASCII: build release servido localmente e `flutter run -d web-server` (debug). Sem credenciais de teste: nada foi digitado além de valores inválidos no login.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas, depois das correções |
| Conferência de formato do `CLAUDE.md` | 0 arquivos a formatar |
| `fvm flutter build web --release` | concluído sem erro |
| `grep` de `num_extension`, `.scale`, `verticalSpacing`/`horizontalSpacing`, getters Dosis, `App{Headline,Title,Label,Body}`, cores antigas, `Color(0x` e `Colors.*` nos 19 arquivos da spec | nada (só `Colors.transparent`) |
| `flutter run -d web-server` (debug) em 390, 768 e 1280 | login, painel em Publicações e biblioteca pública sem `overflow`, exceção nem asserção na saída |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Arquivos do painel sem tokens antigos | passou | `grep` acima |
| 2 | Componentes de `core/` sem tokens antigos | passou | `grep` acima |
| 3 | Sem valor solto | passou | números só via `spacing`, `radii` e `components`; sobra o padrão 24 do `AppIconButton` (anterior) |
| 4 | Login funciona | passou em parte | "E-mail inválido" e "Senha inválida" aparecem; credencial errada e login certo não conferidos |
| 5 | Mostrar/ocultar senha | passou | Tab chega ao olho com anel de foco, Enter alterna; tooltip "Mostrar senha"/"Ocultar senha" (`signin_page.dart`) |
| 6 | Abas, filtros, "Criar", "Sair" | passou em parte | Publicações abre, lista e filtra (busca sem resultado); "Criar", "Sair" e demais abas exigem login |
| 7 | Barra lateral recolhe/expande e abre como menu | passou em parte | desktop recolhe e expande; celular abre e fecha pelo botão; itens da barra só aparecem com login |
| 8 | Mensagem de vazio | passou | "Nenhuma publicação encontrada." com busca "zzzqqq" em 390 e 768 |
| 9 | Contraste ≥ 4,5:1 | passou (após correção) | regra da senha `inkSecondary`/branco 7,0:1; branco/`accent` 4,9:1; subitem `accent`/branco 4,9:1; subitem em hover/foco era 4,48:1, agora `accentStrong`/`surface` 6,3:1 |
| 10 | Login e painel sem `overflow` | passou | debug em 390, 768 e 1280 |
| 11 | Telas públicas sem `overflow` | passou | biblioteca em 390, 768 e 1280 em debug; menu, vídeo e categorias conferidos na implementação |
| 12 | `analyze` | passou | sem problemas |

## Problemas encontrados
- **Item da barra lateral sem ação para leitor de tela** (`sidebar_menu_item.dart`, ajuste): o `Semantics` com `excludeSemantics` descartava o toque do `InkWell`, então o leitor anunciava um botão que não fazia nada. Corrigido com `onTap` no `Semantics`. Conferido no código; a barra sem login não tem itens para testar na tela.
- **Subitem com acento abaixo de 4,5:1 em hover e foco** (`sidebar_menu_item.dart`, ajuste): `accent` sobre `surface` dá 4,48:1. Corrigido usando `accentStrong` nesses estados.
- **Comentário do `ToggleCollpaseButton` dizia "no celular e no tablet"** (detalhe): o botão só fecha o menu no celular. Corrigido.

## Registros (sem correção)
- `focusRingColor` em `AppIconButton`: opcional, sem efeito em quem não passa; usado só em "Sair".
- Fundo do painel e do `AppCard` passou a `page` (branco), o mesmo valor do `white` anterior no cartão.
- `/admin/painel/...` sem login mostra a estrutura e lista publicações (comportamento anterior, fora do escopo).
- No tablet o botão da barra recolhe o menu aberto em vez de fechá-lo (comportamento anterior, mantido pela spec).
- Ao trocar de largura (menu → barra fixa), a aba de Publicações é recriada e perde o filtro digitado (comportamento anterior).

## Não conferido
- Credencial errada, login certo, "Sair", "Criar", demais abas, itens e subitens da barra (Tab e foco): exigem login, sem credenciais de teste.
- Leitor de tela de verdade.
