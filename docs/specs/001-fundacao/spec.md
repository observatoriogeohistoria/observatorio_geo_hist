# 001. Fundação visual (tokens, fontes e breakpoints)

- **Status:** implementada
- **Item do planejamento:** Fase 0, entregas 0.1, 0.2 e 0.3
- **Protótipo:** aba "Fundamentos" (link no CLAUDE.md)
- **Criada em:** 2026-09-26

> A Fase 0 foi dividida em três specs: **001** Fundação (esta), **002** Botões, navbar e rodapé (0.4 a 0.6), **003** `index.html` e tela de carregamento inicial (0.7).

## Objetivo
Dar ao projeto a base visual do redesign (cores, fontes, espaçamentos e faixas de largura) para que as telas novas sejam construídas em cima dela. Quem usa o site **não vê mudança nenhuma** com esta entrega: ela só prepara o terreno.

## Situação atual
- Cores, espaçamentos, raios e traços ficam em `lib/app/theme/` (`AppTheme.colors`, `.dimensions`, `.typography`).
- Todo texto usa a fonte Dosis. Ela está embutida em `assets/fonts/`, mas os estilos de texto a pedem pelo pacote `google_fonts`.
- Os tamanhos de texto e de espaçamento escalam com a largura da tela (`num_extension`).
- `ScreenUtils` (`core/utils/screen/screen_utils.dart`) já separa celular (< 600), tablet (600–1023) e desktop (≥ 1024), mas o espaçamento lateral da página ainda passa pela escala e não existe largura máxima de conteúdo.
- Não existe cor de texto secundário, de superfície, de linha nem de rodapé escuro.

## Comportamento

### Cores (0.1)
Entram cores novas **ao lado** das atuais. Nenhuma cor atual é alterada ou removida.

| Uso | Valor (do protótipo) |
|---|---|
| Fundo da página | `#FFFFFF` |
| Superfície (blocos alternados) | `#F7F5F2` |
| Texto principal | `#1F1B18` |
| Texto secundário | `#5E5852` |
| Linhas e bordas | `#E6E1DA` |
| Acento (laranja) | `#C94400` |
| Acento forte (hover) | `#A33600` |
| Acento suave (fundos) | `#FFF0E6` |
| Rodapé: fundo | `#1C1917` |
| Rodapé: linha | `#37322E` |
| Rodapé: texto | `#D8D2CA` |
| Rodapé: destaque | `#FF9A62` |
| Erro | `#B3261E` |
| Sucesso (texto / fundo) | `#1C6B34` / `#E4F3E8` |

### Espaçamentos, raios e sombras (0.1)
- Escala de espaçamento em passos fixos de 4 px: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 96.
- Raios: 6, 8, 10, 12, 14, 16, 18, 20 e "pílula" (totalmente arredondado). São os usados no protótipo.
- Duas sombras: **suave** (cartões em repouso) e **elevada** (menus, painéis e cartões em hover).
- Foco visível padrão: contorno de 3 px na cor de acento, afastado 2 px do elemento.

### Fontes (0.2)
- **Bricolage Grotesque** para títulos (pesos 600, 700 e 800) e **Figtree** para texto (pesos 400, 500, 600 e 700).
- As duas ficam **embutidas no app** (`assets/fonts/`), sem baixar do Google em tempo de execução. Não pode haver troca visível de fonte no carregamento.
- Escala de texto nova, com tamanho fixo por faixa de largura (sem `num_extension`):

| Estilo | Celular | Tablet | Desktop |
|---|---|---|---|
| Título de página (h1) | 32 | 40 | 52 |
| Título de seção (h2) | 26 | 30 | 36 |
| Título de cartão (h3) | 18 | 20 | 20 |
| Texto de leitura | 17 | 18 | 18 |
| Texto padrão | 16 | 16 | 16 |
| Texto pequeno | 14 | 14 | 14 |
| Rótulo (caixa alta) | 12,5 | 12,5 | 13 |

  Valores em px lógicos, derivados do protótipo. Ajustes finos só com o protótipo aberto ao lado.
- Os estilos de texto **antigos (Dosis) continuam como estão**. As telas antigas e o painel admin não mudam de fonte.

### Breakpoints e largura de conteúdo (0.3)
- Três faixas: **celular** (< 600), **tablet** (600–1023) e **desktop** (≥ 1024).
- Largura máxima do conteúdo: **1120 px**, centralizado.
- Margem lateral do conteúdo: **20 px** no celular e **32 px** do tablet para cima.
- As funções de faixa que já existem continuam respondendo o mesmo. As telas antigas seguem com o espaçamento atual.

## Estados
Não se aplica: nenhuma tela é criada.
- **Casos de borda:**
  - Se uma fonte falhar ao carregar, o texto cai para a fonte do sistema sem quebrar o layout.
  - Largura acima de 1120 px: o conteúdo fica centralizado e as margens crescem.
  - Larguras entre faixas (599/600 e 1023/1024) trocam de faixa sem tamanho intermediário.

## Responsivo
Cada valor novo tem uma versão por faixa (390, 768 e 1280 px) e não muda com a altura da tela nem com a orientação.

## Acessibilidade
- Contraste mínimo de 4,5:1 para todo par de texto e fundo aprovado. Pares a conferir:
  - texto principal, secundário e acento sobre o fundo branco;
  - texto secundário e acento sobre a superfície `#F7F5F2` (o acento aqui fica perto do limite);
  - texto do rodapé e destaque sobre `#1C1917`;
  - erro sobre branco e sucesso sobre o fundo de sucesso.
- Se algum par falhar, a cor é ajustada e a mudança registrada aqui.
- **Regra do acento (decidida em 2026-09-26):** `#C94400` passa sobre branco (4,87), mas fica abaixo de 4,5:1 sobre a superfície `#F7F5F2` (4,48) e sobre o acento suave `#FFF0E6` (4,38). Nesses fundos, texto e ícones laranja usam o **acento forte** `#A33600` (6,11 sobre `#FFF0E6`). O valor do acento não muda.
- O foco visível padrão existe como valor único para os componentes reutilizarem.
- Nenhum texto abaixo de 12,5 px.

## Dados e regras de negócio
- Nenhum dado, modelo ou rota muda.
- Nenhum valor antigo do tema é removido nem alterado (o painel admin depende deles).
- Só valores novos, prefixo ou nome distinto dos antigos, para ninguém confundir os dois na hora de usar.

## Critérios de aceite
- [ ] O app compila e roda; `fvm flutter analyze` sem novos avisos.
- [ ] Todas as telas atuais e o painel admin ficam **idênticos** ao que eram (mesma fonte, cores e espaçamentos).
- [ ] Todas as cores da tabela existem no tema com o valor indicado.
- [ ] Existem os espaçamentos, raios, sombras e o foco padrão descritos, todos no tema (nenhum valor solto no código).
- [ ] Bricolage Grotesque (600, 700, 800) e Figtree (400, 500, 600, 700) estão em `assets/fonts/`, declaradas no `pubspec.yaml`, e renderizam **sem acesso à internet**.
- [ ] Uma tela de teste temporária (não commitada) mostra cada estilo de texto em 390, 768 e 1280 px, com os tamanhos da tabela.
- [ ] Os estilos novos de texto não usam `google_fonts` nem `num_extension`.
- [ ] As três faixas retornam o valor certo em 390, 599, 600, 768, 1023, 1024 e 1280 px.
- [ ] O conteúdo novo respeita a largura máxima de 1120 px e as margens de 20 / 32 px.
- [ ] Todos os pares de cor listados em Acessibilidade têm contraste ≥ 4,5:1, com os valores calculados anotados no `verificacao.md`.
- [ ] As licenças (OFL) das duas fontes estão no repositório junto dos arquivos.

## Fora do escopo
- Botões, navbar, rodapé e `index.html` (specs 002 e 003).
- Trocar a fonte das telas antigas ou do painel admin.
- Remover `num_extension`, `google_fonts` ou os tokens antigos (Fase 7).
- Modo escuro.
- O logo em SVG (item da Fase 0 sem número; entra com a navbar, spec 002).

## Perguntas em aberto
- Nenhuma. (Respondidas: telas antigas mantêm a Dosis; pesos das fontes conforme o planejamento, seção 8.)

## Histórico de mudanças
- 2026-09-26: criada.
- 2026-09-26: aprovada.
- 2026-09-26: contraste. Acento sobre `#F7F5F2` (4,48) e sobre `#FFF0E6` (4,38) ficam abaixo de 4,5:1. Decisão: manter o acento e usar o acento forte nesses dois fundos (regra em Acessibilidade).
- 2026-09-26: implementada (aguarda `/sdd-verify`).
