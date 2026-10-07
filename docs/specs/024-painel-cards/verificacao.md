# Verificação da 024. Cards do painel nos tokens novos

- **Data:** 2026-10-06
- **Resultado:** aprovada com ressalvas (não conferido o que depende de login)

Revisão do código de `05b8a52` e `263a89c` e do app numa cópia em caminho ASCII: build release servido localmente, aberto em `/admin/painel/...` sem login. Sem credenciais de teste e sem dados alterados.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas |
| `fvm dart format` nos alterados | 0 arquivos mudados |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro |
| `grep` de `num_extension`, getters e componentes Dosis, cores antigas e números soltos nos cards, `AppDivider`, `AppNetworkImage` e `ImageErrorContent` | nada |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Sem tokens antigos | passou | `grep` acima |
| 2 | Sem valor solto | passou | números só via `spacing`, `radii` e `components` |
| 3 | 10 tipos com selos | passou em parte | Artigos em 390, 768 e 1280: selos "Publicado" e "Destaque" com texto e fundo; demais tipos não abertos um a um |
| 4 | Ações funcionam | não conferido | exigem login |
| 5 | Botões por Tab | passou em parte | na implementação, foco visível e tooltips nos cards visíveis sem login; botões de edição exigem login |
| 6 | Contraste ≥ 4,5:1 | passou | `inkSecondary` 7,01; `accent` 4,87; Publicado 5,71; Não publicado 5,58; Destaque 6,11 (`accentStrong` sobre `accentSoft`) |
| 7 | Foto com falha sem estourar | passou | membro real com foto quebrada (Equipe) mostra só o ícone dentro do espaço da foto em 768 e 1280 |
| 8 | Sem `overflow` em 390, 768 e 1280 | passou | Artigos, Categorias e Equipe nas três larguras, com título longo e Lattes quebrando; release e debug na implementação |
| 9 | `analyze` | passou | sem problemas |

## Problemas encontrados
- **Leitura dupla do aviso de erro na foto do membro** (`image_error_content.dart`, detalhe): o `Tooltip` do modo compacto também expunha a frase ao leitor de tela, além do `Semantics`. Corrigido com `excludeFromSemantics: true` (`73a2766`).

## Registros (sem correção)
- Modo compacto: a largura vem do parâmetro `width` de `AppNetworkImage` (padrão infinito); só o card de membro (64 a 96 px) entra nele, e o site público não é afetado.

## Não conferido
- Publicar, despublicar, destacar, remover destaque, editar e excluir; editar e excluir em categorias, equipe e usuários; ver, copiar link e excluir mídia: exigem login, sem credenciais de teste.
- Listas de Mídias e Usuários com dados reais, e os 10 tipos de publicação um a um.
- Leitor de tela de verdade.
