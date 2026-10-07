# 023. Login e estrutura do painel nos tokens novos

- **Status:** aprovada
- **Item do planejamento:** Fase 6, item 6.1
- **Protótipo:** não há telas do painel. A referência são os tokens e componentes já usados no site público.
- **Criada em:** 2026-10-06

## Objetivo
A página de login e a estrutura do painel (barra lateral, barra do topo, títulos e listas de cada aba) passam a usar só os tokens novos, sem `num_extension`. Assim a Fase 7 pode remover os tokens antigos. Para quem administra, nada muda no uso: só fontes, cores e espaçamentos ficam iguais aos do site novo.

## Situação atual
- **Login** (`admin/login/presentation/signin_page.dart`): cartão centralizado com "LOGIN", e-mail, senha com botão de mostrar, texto de regra da senha em cinza claro e botão "ENTRAR". A largura do cartão é uma fração da tela.
- **Painel** (`panel_page.dart`): barra do topo laranja com "PAINEL ADMINISTRATIVO" e botão "Sair". No desktop a barra lateral fica fixa; no celular e no tablet, vira menu aberto pelo ícone.
- **Barra lateral** (`admin/sidebar/*`): logo (ou a lupa, quando recolhida), itens com ícone laranja, subitens de Publicações por tipo e botão de recolher.
- **Abas** (`sections/*`, `section_header_*`, `form_label.dart`): título laranja grande, botão "Criar", filtros em Publicações, lista com rolagem e indicadores de carregamento.
- Tudo usa a fonte Dosis, as cores antigas (`orange`, `gray`, `lighterGray`, `darkGray`) e tamanhos que escalam com a tela (`num_extension`). Os componentes de `core/` usados aqui (`app_card`, `app_scrollbar`, `app_icon_button`, `circular_loading`, `linear_loading` e os avisos de `Messenger`) também.

## Comportamento
Layout, textos e fluxos continuam os mesmos. Muda só a aparência:

- **Fontes:** títulos em Bricolage Grotesque e textos em Figtree, nos estilos de `AppTheme.typography.of(context)`.
- **Cores:** laranja de acento (`accent`) no lugar do laranja antigo; texto em `ink`/`inkSecondary`; fundos e bordas em `surface`/`line`. A barra do topo continua laranja, agora no tom de acento, com texto branco.
- **Tamanhos:** fixos por faixa de largura (celular < 600, tablet 600–1023, desktop ≥ 1024), sem escalar com a tela.
- **Login:** o cartão tem largura máxima fixa e ocupa a largura disponível no celular, com margem lateral. O texto da regra da senha passa a ter contraste legível. O botão de mostrar e ocultar a senha vira botão de verdade, alcançável por teclado e com nome ("Mostrar senha" / "Ocultar senha").
- **Barra lateral:** largura fixa aberta e recolhida. Os itens mostram o selecionado com fundo e cor de acento. O botão de recolher é alcançável por teclado e tem nome ("Recolher menu" / "Expandir menu").
- **Avisos** (erro, sucesso, informação): passam às cores novas (`error`, `success` e uma de informação com contraste). Isso vale também para os avisos do site público.
- **Lista vazia:** hoje a aba sem itens mostra só espaço em branco. Passa a mostrar "Nenhum item cadastrado." (ou "Nenhuma publicação encontrada." em Publicações quando há filtro).

## Estados
- **Carregando:** indicadores atuais mantidos (circular no primeiro carregamento, linear ao atualizar), na cor de acento.
- **Vazio:** mensagem descrita acima.
- **Erro:** aviso de erro como hoje. Acesso negado continua saindo do painel.
- **Sem imagem / imagem com falha:** o logo da barra lateral é asset local; sem mudança.
- **Casos de borda:** nome de aba longo com a barra lateral aberta não estoura a largura; muitos subitens de Publicações rolam junto com a barra.

## Responsivo
- **390:** login ocupa a largura com margem; painel com barra lateral em menu de tela cheia; filtros de Publicações empilhados.
- **768:** login com largura máxima centralizada; barra lateral em menu.
- **1280:** barra lateral fixa, aberta ou recolhida; conteúdo ao lado.

## Acessibilidade
- Foco visível por teclado em todos os itens da barra lateral, subitens, botão de recolher, "Sair", "Criar" e no botão de mostrar senha.
- Nome acessível nos botões só com ícone.
- Texto e ícones informativos com contraste mínimo de 4,5:1 (inclui a regra da senha, os subitens não selecionados e o texto branco na barra do topo).

## Dados e regras de negócio
Sem mudança em stores, rotas (`/admin`, `/admin/painel/:tab`, `?tipo=`), permissões (aba Usuários só para quem pode), autenticação ou consultas ao Firebase.

## Critérios de aceite
- [ ] Nenhum arquivo de `admin/login/`, `admin/sidebar/`, `panel_page.dart`, `section_header_*`, `form_label.dart` e `sections/*` importa `num_extension`, usa os getters Dosis (`typography.headline/title/body/label`, `AppHeadline`, `AppTitle`, `AppLabel`, `AppBody`) ou as cores `orange`, `lightOrange`, `gray`, `lightGray`, `lighterGray`, `darkGray`, `red`, `green`, `blue`.
- [ ] O mesmo vale para `app_card`, `app_scrollbar`, `app_icon_button`, `circular_loading`, `linear_loading` e `Messenger`.
- [ ] Sem cor, tamanho de fonte ou espaçamento solto nesses arquivos; o que faltar vira token no tema.
- [ ] Login funciona: e-mail ou senha inválidos mostram a validação; credencial errada mostra aviso de erro; login certo abre o painel.
- [ ] Mostrar/ocultar senha funciona com mouse e com teclado, e o botão tem nome acessível.
- [ ] Todas as abas abrem, listam, filtram (Publicações) e abrem o diálogo de "Criar" como antes. "Sair" volta ao login.
- [ ] A barra lateral recolhe e expande no desktop, e abre e fecha como menu no celular e no tablet; todos os itens alcançáveis por Tab com foco visível.
- [ ] Aba sem itens mostra a mensagem de vazio.
- [ ] Contraste ≥ 4,5:1 em texto e ícones informativos do login, da barra do topo e da barra lateral.
- [ ] Login e painel sem `overflow` nem rolagem horizontal em 390, 768 e 1280 px.
- [ ] Telas públicas que usam os componentes de `core/` alterados (menu do celular, vídeo, biblioteca) seguem sem `overflow` em 390, 768 e 1280 px.
- [ ] `fvm flutter analyze` sem erros novos.

## Fora do escopo
- Cards das abas (6.2), diálogos e campos de formulário (6.3), inclusive o campo de texto do login, que continua como está até a 6.3.
- Redesenho de layout do painel ou novas funções.
- Remover tokens antigos e `num_extension` do tema (Fase 7).

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-06: criada e aprovada. Decidido com a pessoa que o painel adota fontes e cores novas (não só tamanhos), para a Fase 7 remover todos os tokens antigos.
