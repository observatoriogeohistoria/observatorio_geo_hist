# Tarefas da 024. Cards do painel nos tokens novos

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios da spec, na ordem: 1 arquivos sem tokens antigos; 2 sem valores soltos; 3 tipos de publicação com selos; 4 ações funcionam; 5 botões por teclado; 6 contraste; 7 foto com falha; 8 sem `overflow`; 9 `analyze`.

## Grupo A: peças comuns
- [x] **A1.** Tokens dos cards em `ComponentSizes` (`panelCardPaddingH/V`, `panelCardActionsGap`, `panelCardTextGap`, `panelMemberPhoto(breakpoint)`, `networkImageSkeletonHeight`). Arquivo: `app_dimensions.dart`. Atende: 2. Também `imageErrorIcon` e `imageErrorMessageMinWidth` (160); o raio da foto usa `radii.r12` direto.
- [x] **A2.** `StatusBadge` com tons sucesso, erro e acento. Arquivo: `chips/labels.dart`. Atende: 3, 6. "Destaque" em `accentStrong`: `accent` sobre `accentSoft` dá 4,38:1.
- [x] **A3.** `AppDivider` em `line`; `AppNetworkImage` sem `num_extension`; `ImageErrorContent` com ícone e texto em `inkSecondary`, estilo `small`, tamanho de ícone de token. Arquivos: `divider.dart`, `app_network_image.dart`, `image_error_content.dart`. Atende: 1, 2, 7. `ImageErrorContent` ganhou `compact` (só ícone, frase no tooltip e no nome acessível), ligado por `AppNetworkImage` quando a largura é menor que 160 px. Sem `LayoutBuilder`, que quebraria dentro do `IntrinsicHeight` do card.

## Grupo B: card de publicação
- [x] **B1.** Os 10 cards de tipo: número em `label`/`inkSecondary`, título em `h3`/`ink`, subtítulo do artigo em `regular`/`inkSecondary`, espaçamentos `panelCardTextGap`. Arquivos: `posts_cards/*.dart`. Atende: 1, 2, 3, 6.
- [x] **B2.** `PostCard`: "Área(s):"/"Categoria:" em `accent` com valor em `ink`; selos "Publicado"/"Não publicado" e "Destaque"; botões nas cores novas; espaçamentos de token. Arquivo: `post_card.dart`. Atende: 1, 2, 3, 6.

## Grupo C: demais cards
- [x] **C1.** `CategoryCard` e `UserCard` (situação do usuário como selo). Arquivos: `category_card.dart`, `user_card.dart`. Atende: 1, 2, 6.
- [x] **C2.** `MediaCard`: extensão e URL em `inkSecondary`, URL quebrando sem rolagem; "Copiar link" em `inkSecondary`. Arquivo: `media_card.dart`. Atende: 1, 2, 6, 8. URL em `small`; quebra por caractere sem rolagem (conferido com URL de 150 caracteres em 390 px).
- [x] **C3.** `TeamMemberCard`: foto `panelMemberPhoto(breakpoint)` com raio de token; cargo em `inkSecondary`; Lattes em `accent`. Arquivo: `team_member_card.dart`. Atende: 1, 2, 6, 7.

## Grupo D: conferência
- [x] **D1.** Busca de tokens antigos e de números soltos nos arquivos da tabela do plano. Atende: 1, 2. Nada encontrado. `typography.label` que aparece é o estilo novo (`AppTextStyles.label`), não o getter Dosis.
- [x] **D2.** `fvm flutter analyze` sem erros novos e `fvm dart format` nos alterados. Atende: 9.
- [ ] **D3.** Em cada aba: publicar, despublicar, destacar, remover destaque, editar e excluir uma publicação; editar e excluir categoria, membro e usuário; ver, copiar link e excluir mídia. Conferir os 10 tipos pelos subitens. Atende: 3, 4. Não conferido: sem credenciais de teste. Sem login, conferidos visualmente Categorias, Publicações e Equipe (o card de mídia e o de usuário, com dados falsos numa cópia de teste, em modo debug); as ações não foram acionadas.
- [x] **D4.** Percorrer os botões por Tab (foco visível, tooltip). Medir o contraste de número, textos secundários, selos, rótulos e Lattes. Atende: 5, 6. Foco visível e nomes (tooltips) conferidos por Tab e pela árvore de acessibilidade. Contraste: `inkSecondary` 7,0; `accent` 4,9; Publicado 5,7; Não publicado/inativo 5,6; Destaque 6,1.
- [x] **D5.** Em 390, 768 e 1280 px, com título longo, URL longa e foto quebrada (URL inválida num membro de teste): sem `overflow`, sem rolagem horizontal e com "Erro ao carregar a imagem" dentro da foto. Atende: 7, 8. Em 390, 768 e 1280 px (release e debug), sem `overflow` nem asserção no console. Foto quebrada simulada numa cópia de teste mostra o ícone dentro do espaço da foto.
