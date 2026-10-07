# 024. Cards do painel nos tokens novos

- **Status:** aprovada
- **Item do planejamento:** Fase 6, item 6.2
- **Protótipo:** não há telas do painel. A referência são os tokens e componentes do site público.
- **Criada em:** 2026-10-06

## Objetivo
Os cards das listas do painel (publicações, categorias, mídias, equipe e usuários) passam a usar só os tokens novos, sem `num_extension`, sem a fonte Dosis e sem as cores antigas. O uso continua igual.

## Situação atual
- **Card de publicação** (`cards/post_card.dart` e os 10 de `cards/posts_cards/`): número, título, subtítulo ou dados do tipo, divisória, "Área(s)" e "Categoria" com rótulo laranja, situação "Publicado" (verde) ou "Não Publicado" (vermelho), "DESTAQUE" em cinza sublinhado e, para quem edita, os botões publicar, destacar, editar e excluir.
- **Categoria, mídia, membro da equipe e usuário** (`category_card`, `media_card`, `team_member_card`, `user_card`): número, nome e dados em cinza, botões de ação com ícone. O de mídia tem "Ver imagem" e "Copiar link"; o de membro mostra a foto (96 px, que escala com a tela).
- Componentes de `core/` usados só por eles: `AppDivider`, `AppNetworkImage` e `ImageErrorContent` (mensagem "Erro ao carregar a imagem").
- O contorno do card (`AppCard`) já migrou na spec 023.

## Comportamento
Layout, textos e ações continuam os mesmos. Muda a aparência:
- Número do item em `inkSecondary`; título em fonte de título (Bricolage) e `ink`; dados secundários em Figtree e `inkSecondary` (hoje em cinza claro, sem contraste).
- Rótulos "Área(s):" e "Categoria:" em `accent`; o valor em `ink`.
- Situação vira selo com texto e fundo: "Publicado" em `success` sobre `successSurface`, "Não publicado" em `error` sobre `errorSurface`, "Destaque" em `accent` sobre `accentSoft`. A informação deixa de depender só da cor e do sublinhado. O texto "Não Publicado" passa a "Não publicado" e "DESTAQUE" a "Destaque".
- Botões de ação: publicar, destacar e editar em `accent`; excluir em `error`; copiar link em `inkSecondary`. Todos com o mesmo tamanho fixo.
- Link do Lattes no card de membro em `accent` (hoje laranja claro, sem contraste).
- Foto do membro com tamanho fixo por faixa de largura e cantos arredondados. Sem foto, o card fica como hoje (sem o espaço da foto).
- Divisória em `line`.

## Estados
- **Carregando, vazio e erro da lista:** da spec 023.
- **Imagem carregando:** esqueleto com as cores novas.
- **Imagem com falha:** ícone e "Erro ao carregar a imagem" em `inkSecondary` e Figtree, dentro do espaço da foto.
- **Casos de borda:** título longo quebra em várias linhas sem empurrar os botões para fora; URL de mídia longa quebra sem rolagem horizontal; card sem categoria não mostra a linha "Categoria".

## Responsivo
- **390:** botões de ação continuam na coluna à direita; textos quebram. Foto do membro menor.
- **768 e 1280:** como hoje, com tamanhos fixos.

## Acessibilidade
- Todos os botões de ação com nome (os tooltips atuais) e foco visível por teclado.
- Texto e ícones informativos com contraste mínimo de 4,5:1, inclusive o número, os dados secundários, os selos e o link do Lattes.
- Situação legível sem depender de cor (texto no selo).

## Dados e regras de negócio
Sem mudança em dados, ações ou permissões: só quem pode editar vê os botões de edição; "Ver imagem" e "Copiar link" continuam visíveis para todos.

## Critérios de aceite
- [ ] Nenhum arquivo de `panel/presentation/components/cards/` (inclusive `posts_cards/`), nem `AppDivider`, `AppNetworkImage` e `ImageErrorContent`, importa `num_extension`, usa os componentes ou getters de texto Dosis (`AppHeadline`, `AppTitle`, `AppLabel`, `AppBody`, `typography.headline/title/body/label`) ou as cores `orange`, `lightOrange`, `amber`, `gray`, `lightGray`, `lighterGray`, `darkGray`, `red`, `green`, `blue`.
- [ ] Sem cor, tamanho de fonte ou espaçamento solto nesses arquivos.
- [ ] Os 10 tipos de publicação mostram seus dados como antes, com os selos "Publicado"/"Não publicado" e "Destaque".
- [ ] Publicar, destacar, editar e excluir funcionam como antes em publicações; editar e excluir em categorias, equipe e usuários; ver, copiar link e excluir em mídias.
- [ ] Botões de ação alcançáveis por Tab, com foco visível e nome acessível.
- [ ] Contraste ≥ 4,5:1 em número, dados secundários, selos, rótulos e link do Lattes.
- [ ] Foto do membro com falha mostra a mensagem de erro sem estourar o card.
- [ ] Listas sem `overflow` nem rolagem horizontal em 390, 768 e 1280 px, inclusive com título e URL longos.
- [ ] `fvm flutter analyze` sem erros novos.

## Fora do escopo
- Confirmação antes de excluir (hoje exclui direto). Fica registrado como melhoria futura.
- Diálogos abertos pelos botões (spec 025).
- O carrossel de destaques antigo, que também usa `AppNetworkImage`, não é usado e sai na Fase 7.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-06: criada e aprovada.
