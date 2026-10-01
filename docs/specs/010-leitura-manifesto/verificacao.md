# Verificação da 010. Layout de leitura compartilhado e Manifesto

- **Data:** 2026-10-01
- **Resultado:** aprovada (após 1 correção)

Revisão feita sobre o código dos commits `b3546e6` e `227edf2`, com o app real (build de release servido localmente) no navegador embutido.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas, antes e depois da correção |
| `fvm flutter build web --release` | concluído sem erro, antes e depois da correção |
| `git diff` de `app_router.dart` e `app_routes.dart` | vazio |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Navbar, cabeçalho de superfície, migalhas, título, coluna e rodapé | passou | Tela em 1280, 768 e 390 px |
| 2 | Texto exato e na ordem | passou | `manifest_page.dart` comparado com a spec e com `#s-manifest` do protótipo |
| 3 | Lista numerada com círculo e texto quebrado alinhado ao texto | passou | Tela em 390 px (itens de várias linhas alinhados ao texto); sem "1)" |
| 4 | Destaque com barra; botão abre `/contato` por clique e Enter | passou | Clique real no botão abriu `/contato` e o voltar retornou a `/manifesto`; Enter conferido na implementação |
| 5 | "Início" abre a Home por clique e Enter; "Manifesto" não é link | passou | Tab até "Início" (contorno visível) + Enter abriu `/`; "Manifesto" sem `href` na árvore |
| 6 | Acesso direto, `/manifest`, hero, Quem somos, rodapé, voltar | passou | `/manifest` → `/manifesto`; clique em "Conheça o manifesto" (Home) e em "Manifesto" no rodapé (a partir de `/biblioteca`) abriram `/manifesto` no topo |
| 7 | Nenhuma rota muda | passou | Diff de rotas vazio; `/biblioteca` e um post (`/publicacoes/geografia/…`) abriram como antes, console sem erros |
| 8 | Alinhamento e larguras por faixa | passou | 1280: cabeçalho à esquerda em 1120 px, coluna de 680 centralizada; 768 e 390 conforme a spec |
| 9 | Rodapé na base com janela alta | passou | 1280 × 2200 sem vão abaixo do rodapé |
| 10 | Semântica e ordem de Tab | passou após correção | `h1` "Manifesto"; itens lidos como "1. …"; setas e círculos fora da árvore; Tab: navbar → Início → botão. Migalhas saíam como `group`; corrigido para `navigation` "Você está em" |
| 11 | Contraste ≥ 4,5:1 | passou | Calculado pelos tokens usados no código: migalhas 6,45:1 (repouso) e 6,26:1 (hover) sobre a superfície; atual e título 15,7:1; número 6,11:1 sobre `accentSoft`; texto 17,1:1 sobre branco |
| 12 | Sem rolagem horizontal, sobreposição ou `overflow`, também a 200% | passou | `scrollWidth` igual à largura em 390, 768 e 1280; texto a 200% (fonte raiz do documento a 200%, que o Flutter web respeita) em 390 px: círculos crescem com o número, itens, destaque, migalhas e botão quebram sem sobrepor |
| 13 | Base única e reaproveitável | passou | `PageHeader` aceita N níveis de `BreadcrumbItem` e `lead` opcional; `ReadingColumn` independente do cabeçalho; seção "Páginas de leitura" em `docs/arquitetura.md` |
| 14 | Só tokens, sem `num_extension`, analyze e build limpos | passou | Busca nos arquivos novos sem cores, tamanhos ou `.scale`/`.fontSize`/`.verticalSpacing` soltos (só `TextScaler.scale`) |

## Problemas encontrados
- **Migalhas sem papel de navegação** (`breadcrumbs.dart`), gravidade ajuste: o grupo "Você está em" saía como `role=group`. Corrigido com `SemanticsRole.navigation`; conferido na árvore do app (`role=navigation`, rótulo "Você está em"), link "Início" intacto, console sem erros. Commit `fix:` próprio.
- **Seta do botão não cresce a 200%** (`PrimaryButton`, spec 002), detalhe: o texto do botão escala e o ícone fica em tamanho fixo. Não quebra nem sobrepõe; componente fora do escopo da 010, fica anotado.

## Não conferido
- Aviso de `overflow` no console: o build de release não imprime esse aviso; a ausência foi conferida pela tela e pelo `scrollWidth`.
- Contraste medido em pixel: o Flutter web desenha em canvas e a captura sai em JPEG; o contraste foi calculado com as cores dos tokens que o código usa.
