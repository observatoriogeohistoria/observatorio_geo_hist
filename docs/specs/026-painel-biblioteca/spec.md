# 026. Biblioteca do painel e faixa de ambiente nos tokens novos

- **Status:** implementada
- **Item do planejamento:** Fase 6, item 6.4
- **Protótipo:** não há telas do painel. A referência são os tokens e componentes do site público.
- **Criada em:** 2026-10-06

## Objetivo
A gestão da biblioteca no painel e a faixa "Ambiente de Testes" passam a usar só os tokens novos. Com isso, nenhuma tela em uso depende mais de `num_extension`, da fonte Dosis ou das cores antigas, e a Fase 7 pode removê-los.

## Situação atual
- **Lista de documentos da área** (`/admin/painel/biblioteca/:area`, `library/presentation/pages/library_list_page.dart`): barra do topo laranja com "Voltar" e o nome da área; no desktop, filtros fixos à esquerda; lista de documentos com divisórias; "Criar documento" para quem edita; "Filtros" (celular e tablet) e "Carregar mais" embaixo.
  - Carregando: indicador circular. Atualizando: indicador linear.
  - Erro: só a mensagem do erro, em título Dosis.
  - Vazio: "Nenhum documento encontrado.", e nesse caso somem também "Criar documento" e "Filtros".
- **Filtros** (`components/filters.dart`): "Filtros", campos Título, Autor, Instituição e Ano, "Tipo de Produção", "Categorias", "Aplicar Filtros" e "Limpar Filtros". No celular e no tablet abrem num painel com "Fechar filtros".
- **Card do documento** (`components/document/library_document_card.dart`): título, "autor, instituição, ano" e botões "Editar documento" e "Excluir documento".
- **Diálogo de documento** (`components/create_or_update_document_dialog.dart`): Título, Autor, Instituição, Ano, Documento (URL ou upload), Tipo de Produção e Categorias, com avisos "Selecione o tipo de produção", "Selecione as categorias" e "Preencha o arquivo do documento".
- **Faixa de ambiente** (`core/components/environment/environment_banner.dart`): faixa "Ambiente de Testes" no topo de todas as telas fora de produção. Já usa as cores novas, mas o texto ainda é Dosis.

## Comportamento
Layout, textos e fluxos continuam os mesmos, com os ajustes abaixo:
- **Barra do topo** igual à do painel (spec 023): `accent`, nome da área em fonte de título branca, "Voltar" com foco visível.
- **Filtros:** título "Filtros" em fonte de título; grupos "Tipo de Produção" e "Categorias" no estilo de rótulo de formulário; campos com o visual da spec 025. Fundo do painel lateral em `surface` com borda `line`.
- **Card do documento:** título em fonte de título e `ink`; "autor, instituição, ano" em `inkSecondary`; botões como os cards da spec 024 (editar em `accent`, excluir em `error`).
- **Diálogo de documento:** mesmo visual dos diálogos da spec 025.
- **Divisórias da lista** em `line`.
- **Vazio:** "Nenhum documento encontrado." em texto `inkSecondary`. "Criar documento" e "Filtros" continuam visíveis, para que dê para criar o primeiro documento ou mudar um filtro que não trouxe resultado.
- **Erro:** mensagem do erro com o botão "Tentar de novo", no padrão de erro das telas públicas.
- **Faixa de ambiente:** texto em Figtree, no estilo de rótulo do site, mantendo cor e altura.

## Estados
- **Carregando:** indicador circular no primeiro carregamento, linear ao atualizar ou salvar, "Carregando..." em "Carregar mais".
- **Vazio:** como descrito acima.
- **Erro:** como descrito acima. Erro ao salvar ou excluir mostra o aviso de erro (spec 023).
- **Casos de borda:** título ou autor muito longos quebram sem empurrar os botões; muitas categorias selecionadas nos filtros não estouram a largura; "Carregar mais" some quando não há mais páginas.

## Responsivo
- **390:** sem filtros fixos; "Filtros" abre o painel de filtros em tela cheia; card com os botões à direita e o texto quebrando.
- **768:** como no celular, com o painel de filtros mais estreito.
- **1280:** filtros fixos à esquerda e lista ao lado.

## Acessibilidade
- Foco visível e nome em "Voltar", "Fechar filtros", editar, excluir, "Aplicar Filtros", "Limpar Filtros", "Criar documento", "Filtros" e "Carregar mais".
- O card do documento, que abre o documento ao ser clicado, tem foco visível e o nome "Abrir documento: <título>".
- Texto e ícones informativos com contraste mínimo de 4,5:1; o texto da faixa de ambiente sobre `accent` também.

## Dados e regras de negócio
Sem mudança em consultas, filtros (seleção livre de categorias, tipos Tese e Dissertação), paginação, upload, permissões ou rotas. A biblioteca pública (`/biblioteca`) não muda.

## Critérios de aceite
- [ ] `library_list_page`, `filters`, `library_document_card`, `create_or_update_document_dialog` e `environment_banner` não importam `num_extension`, não usam os componentes ou getters de texto Dosis (`AppHeadline`, `AppTitle`, `AppLabel`, `AppBody`, `typography.headline/title/body/label`) e não usam as cores `orange`, `lightOrange`, `amber`, `gray`, `lightGray`, `lighterGray`, `darkGray`, `red`, `green`, `blue`.
- [ ] Sem cor, tamanho de fonte ou espaçamento solto nesses arquivos.
- [ ] Busca no projeto: fora de `theme/`, de `num_extension.dart` e dos arquivos sem uso listados na Fase 7, nenhum arquivo usa `num_extension`, Dosis ou cores antigas.
- [ ] Filtrar, limpar filtros, carregar mais, criar, editar e excluir documento funcionam como antes.
- [ ] Com filtro sem resultado, aparecem "Nenhum documento encontrado.", "Filtros" e (para quem edita) "Criar documento".
- [ ] Com erro de carregamento, aparece a mensagem e "Tentar de novo" recarrega.
- [ ] O card do documento é alcançável por Tab, com foco visível, e Enter abre o documento.
- [ ] Todos os botões citados em Acessibilidade alcançáveis por Tab, com foco visível e nome acessível.
- [ ] Contraste ≥ 4,5:1 nos textos e ícones informativos e na faixa de ambiente.
- [ ] Sem `overflow` nem rolagem horizontal em 390, 768 e 1280 px, com e sem o painel de filtros aberto.
- [ ] Faixa "Ambiente de Testes" aparece no ambiente dev, em Figtree, com a mesma altura de antes.
- [ ] `fvm flutter analyze` sem erros novos.

## Fora do escopo
- Biblioteca pública (já migrada na Fase 4).
- Arquivos sem uso, que saem na Fase 7: `avatar.dart`, `highlights_dialog_carousel.dart`, `common_title.dart`, `pages_circles.dart`, `custom_icon_button.dart`, `app_rounded_image.dart` e o cálculo de recuo de página antigo em `screen_utils.dart`.
- Confirmação antes de excluir documento.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-06: criada e aprovada.
- 2026-10-06: botão de erro "Tentar de novo" (componente das telas públicas) e foco no card do documento, vindos do plano.
- 2026-10-06 (implementação, decidido sem a pessoa, modo autônomo): a faixa de ambiente passa a ficar dentro de um `Material`, porque fora das páginas o texto herdava o sublinhado amarelo de erro do Flutter (visível também no release). "Fechar filtros" fica em `accentStrong`, não `accent`: o acento sobre o fundo `surface` do painel dá 4,48:1, abaixo do mínimo. O diálogo de documento ganha o título "Criar documento"/"Atualizar documento" (`PanelDialogTitle`), como os demais diálogos do painel. O `FormLabel` passa a alinhar à esquerda também quando recebe a largura toda (lista dos filtros); nos usos anteriores nada muda. O card não mostra mais "null" quando falta o ano.
- 2026-10-06 (implementação): a busca global achou os componentes de texto Dosis (`AppHeadline`, `AppTitle`, `AppLabel`, `AppBody`, em `core/components/text/`) usados só por `common_title.dart` e `highlights_dialog_carousel.dart`, que já saem na Fase 7. Eles saem junto, na Fase 7.
