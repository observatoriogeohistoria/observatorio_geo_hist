# Plano da 026. Biblioteca do painel e faixa de ambiente nos tokens novos

- **Spec:** spec.md
- **Criado em:** 2026-10-06

## Abordagem
Última spec da Fase 6. Depende da 023 (barra do topo, avisos, carregamento), da 024 (botões de card) e da 025 (campos, diálogo lateral, `PanelDialogTitle`). Como campos e diálogo lateral já estarão migrados, aqui sobram a página da lista, o painel de filtros, o card do documento, o diálogo de documento e a faixa de ambiente.

Na página da lista, a ordem dos estados muda um pouco: com a lista vazia, "Criar documento" e a fileira de "Filtros"/"Carregar mais" continuam visíveis, e só a área da lista mostra "Nenhum documento encontrado.". O erro passa a usar o componente de erro das telas públicas (`StateErrorInline`), com o botão de tentar de novo.

No fim, uma busca no projeto inteiro confirma que só restam tokens antigos em `theme/`, `num_extension.dart` e nos arquivos sem uso da Fase 7.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Largura do painel de filtros |
| Alterar | `lib/app/features/library/presentation/pages/library_list_page.dart` | Barra do topo, estados, espaçamentos, painel de filtros no celular |
| Alterar | `lib/app/features/library/presentation/components/filters.dart` | Largura, fundo, títulos, espaçamentos |
| Alterar | `lib/app/features/library/presentation/components/document/library_document_card.dart` | Textos, ícone, botões, área clicável |
| Alterar | `lib/app/features/library/presentation/components/create_or_update_document_dialog.dart` | Título e rótulos dos grupos, espaçamentos |
| Alterar | `lib/app/core/components/environment/environment_banner.dart` | Texto em Figtree |

## Decisões técnicas
- **Barra do topo:** mesma aparência da barra do painel (023): `accent`, título em `h3` branco, "Voltar" com `AppIconButton` (nome e foco já embutidos).
- **Largura dos filtros:** hoje é 20 % da tela, o que dá cerca de 80 px no painel do celular. Passa a `panelFiltersWidth` (300) no desktop e à largura toda dentro do painel aberto por "Filtros" (celular e tablet). O painel do tablet fica com no máximo `mobileMenuMaxWidth` (420, já usado pelo menu do site).
- **Fundo dos filtros** `surface` com borda direita `line` no desktop; título "Filtros" em `h3`/`ink`; "Tipo de Produção" e "Categorias" com o `FormLabel` da 023. "Fechar filtros" passa a `accent`.
- **Erro com `StateErrorInline`**, com o botão "Tentar de novo" das telas públicas.
- **Vazio:** `Text` em `regular`/`inkSecondary`, como na `CrudSection` (023).
- **Card do documento:** hoje a linha inteira abre o documento público com `GestureDetector`, sem foco por teclado. Passa a `InkWell` + `AppFocusRing`, com `Semantics` "Abrir documento: <título>". Ícone do livro em `inkSecondary` com tamanho de token; título em `h3`/`ink`; dados em `regular`/`inkSecondary`; editar em `accent` e excluir em `error` (padrão da 024).
- **Divisórias da lista** com `AppDivider` (já em `line` desde a 024) no lugar do `Divider` padrão.
- **Faixa de ambiente:** estilo `label` da tipografia nova, branco sobre `accent` (4,86:1), altura igual (`environmentBannerHeight`).
- **Busca final** com o mesmo padrão das outras specs, no `lib/` inteiro, excluindo `theme/`, `num_extension.dart` e os 7 arquivos sem uso.

## Dependências e geração de código
Nenhum pacote, rota ou `build_runner`. Depende da 023, 024 e 025 implementadas.

## Riscos e cuidados
- **`environment_banner`** aparece em todas as telas do ambiente dev; só a fonte muda.
- **Painel de filtros no celular:** hoje é estreito demais; com a largura nova, conferir que "Aplicar Filtros" e "Limpar Filtros" ficam visíveis sem rolagem horizontal.
- **Biblioteca pública** não usa nenhum destes arquivos; nada muda lá.

## Como conferir
- Busca de tokens antigos nos arquivos da tabela e no `lib/` inteiro (critério 3).
- `fvm flutter analyze` e `fvm dart format` (em cópia com caminho sem acento).
- `fvm flutter run -d chrome` no painel, aba Biblioteca → Geografia e História, em 390, 768 e 1280 px: filtrar, filtro sem resultado, limpar, carregar mais, criar, editar e excluir; erro de carregamento simulado (sem rede); painel de filtros aberto no celular e no tablet; faixa de ambiente no dev.
