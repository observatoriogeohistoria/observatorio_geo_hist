# Tarefas da 024. Cards do painel nos tokens novos

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios da spec, na ordem: 1 arquivos sem tokens antigos; 2 sem valores soltos; 3 tipos de publicação com selos; 4 ações funcionam; 5 botões por teclado; 6 contraste; 7 foto com falha; 8 sem `overflow`; 9 `analyze`.

## Grupo A: peças comuns
- [ ] **A1.** Tokens dos cards em `ComponentSizes` (`panelCardPaddingH/V`, `panelCardActionsGap`, `panelCardTextGap`, `panelMemberPhoto(breakpoint)`, `networkImageSkeletonHeight`). Arquivo: `app_dimensions.dart`. Atende: 2.
- [ ] **A2.** `StatusBadge` com tons sucesso, erro e acento. Arquivo: `chips/labels.dart`. Atende: 3, 6.
- [ ] **A3.** `AppDivider` em `line`; `AppNetworkImage` sem `num_extension`; `ImageErrorContent` com ícone e texto em `inkSecondary`, estilo `small`, tamanho de ícone de token. Arquivos: `divider.dart`, `app_network_image.dart`, `image_error_content.dart`. Atende: 1, 2, 7.

## Grupo B: card de publicação
- [ ] **B1.** Os 10 cards de tipo: número em `label`/`inkSecondary`, título em `h3`/`ink`, subtítulo do artigo em `regular`/`inkSecondary`, espaçamentos `panelCardTextGap`. Arquivos: `posts_cards/*.dart`. Atende: 1, 2, 3, 6.
- [ ] **B2.** `PostCard`: "Área(s):"/"Categoria:" em `accent` com valor em `ink`; selos "Publicado"/"Não publicado" e "Destaque"; botões nas cores novas; espaçamentos de token. Arquivo: `post_card.dart`. Atende: 1, 2, 3, 6.

## Grupo C: demais cards
- [ ] **C1.** `CategoryCard` e `UserCard` (situação do usuário como selo). Arquivos: `category_card.dart`, `user_card.dart`. Atende: 1, 2, 6.
- [ ] **C2.** `MediaCard`: extensão e URL em `inkSecondary`, URL quebrando sem rolagem; "Copiar link" em `inkSecondary`. Arquivo: `media_card.dart`. Atende: 1, 2, 6, 8.
- [ ] **C3.** `TeamMemberCard`: foto `panelMemberPhoto(breakpoint)` com raio de token; cargo em `inkSecondary`; Lattes em `accent`. Arquivo: `team_member_card.dart`. Atende: 1, 2, 6, 7.

## Grupo D: conferência
- [ ] **D1.** Busca de tokens antigos e de números soltos nos arquivos da tabela do plano. Atende: 1, 2.
- [ ] **D2.** `fvm flutter analyze` sem erros novos e `fvm dart format` nos alterados. Atende: 9.
- [ ] **D3.** Em cada aba: publicar, despublicar, destacar, remover destaque, editar e excluir uma publicação; editar e excluir categoria, membro e usuário; ver, copiar link e excluir mídia. Conferir os 10 tipos pelos subitens. Atende: 3, 4.
- [ ] **D4.** Percorrer os botões por Tab (foco visível, tooltip). Medir o contraste de número, textos secundários, selos, rótulos e Lattes. Atende: 5, 6.
- [ ] **D5.** Em 390, 768 e 1280 px, com título longo, URL longa e foto quebrada (URL inválida num membro de teste): sem `overflow`, sem rolagem horizontal e com "Erro ao carregar a imagem" dentro da foto. Atende: 7, 8.
