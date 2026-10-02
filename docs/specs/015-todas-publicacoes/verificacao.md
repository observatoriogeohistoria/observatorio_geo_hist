# Verificação da 015. Todas as publicações e "Ver todas" nos Destaques

- **Data:** 2026-10-02
- **Resultado:** aprovada com ressalvas (índice da busca a publicar)

Revisão do código de `50ed5fd..275f337` e do app real: build `APP_ENV=prod` só leitura servido localmente num Chrome sem janela controlado por CDP, e `flutter run -d web-server` em debug (dev, com destaques). Erro de rede simulado num build à parte com falha injetada no datasource, ligada e desligada pelo console, sem commit. Nada foi escrito no banco.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas |
| Conferência de formato do `CLAUDE.md` (cópia ASCII) | 0 arquivos a formatar |
| `fvm flutter build web --release --dart-define=APP_ENV=prod` | concluído sem erro |
| `flutter run -d web-server` (debug) em 390, 768 e 1280 | Home e `/publicacoes` sem `overflow` nem asserção no console |
| Busca por cor, fonte e espaço soltos, `num_extension` e `GestureDetector` no diff | nenhuma ocorrência |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Página completa, sem Colabore, navbar sem item ativo | passou | 1280 em prod: migalhas, `h1`, descrição, busca, chips, contagem, blocos e rodapé; nenhum item da navbar marcado |
| 2 | Migalhas | passou | `all_posts_page.dart`: "Início" com rota da Home, "Publicações" sem rota; clique e Enter conferidos na implementação |
| 3 | Ordem dos blocos e contagem | passou | Chips em ordem alfabética do plural; 443 publicações = soma dos 10 tipos |
| 4 | Chips | passou | "Todos 443" e um chip por tipo com quantidade |
| 5 | Paginação | passou | Mesmo `ListingTypeBlock` da 014; "Ver mais livros" conferido na implementação |
| 6 | Card abre o post certo | passou | Primeiro artigo abriu `/publicacoes/historia/<categoria>/<id>` com o post certo; Geografia conferido na implementação |
| 7 | Busca sem índice | passou | "a" em prod: `failed-precondition` no console, caixa "Não foi possível carregar" com o campo e "Limpar" visíveis; "Limpar" voltou aos 443 |
| 8 | Estados | passou | Falha injetada: caixa de erro; desligada a falha, "Tentar de novo" trouxe a lista. Vazio da página com textos próprios; a categoria passa os textos de antes (`posts_page.dart`) |
| 9 | Link dos Destaques | passou | Debug (dev): à direita do título em 1280 e 768, abaixo em 390; por Tab, o 11º foco é o link, com anel visível; Enter abriu `/publicacoes` |
| 10 | Rodapé | passou | "Sobre", "Publicações", "Biblioteca"; clique em "Publicações" na Biblioteca abriu `/publicacoes` |
| 11 | Sem regressão | passou | Categoria (Eventos de História) em 1280 e 390, busca vazia com "Nenhuma publicação encontrada"; post e Home iguais fora do link |
| 12 | Larguras | passou | 3, 2 e 1 colunas; `scrollWidth` igual à largura em 390 e 1280; sem `overflow` em debug |
| 13 | Tokens, rota, índice documentado, analyze e build | passou | Diff só com tokens; rota por `AppRoutes.publications`; índice em `docs/deploy-ambientes.md`, igual à consulta que falhou no console |

## Problemas encontrados
- `docs/deploy-ambientes.md` dizia que dev e produção usam o mesmo projeto Firebase. O código escolhe `observatorio-geo-hist-dev` no dev; só o Storage da biblioteca e das mídias do painel aponta fixo para o bucket de produção. Texto corrigido. Detalhe.

## Ressalvas
- A busca em `/publicacoes` só funciona depois que o índice (grupo de coleções `category_posts`: `isPublished`, `type`, `body.title_lower`, crescentes) for publicado em prod e dev. Até lá, mostra o erro tratado.

## Não conferido
- Erro de rede real (cabo cortado): simulado com falha injetada no datasource, que leva ao mesmo estado da store.
- Leitor de tela real.
