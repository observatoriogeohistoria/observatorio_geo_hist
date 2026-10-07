# Verificação da 025. Diálogos e campos do painel nos tokens novos

- **Data:** 2026-10-06
- **Resultado:** aprovada com ressalvas (não conferido o que depende de login)

Revisão do código de `722b3f0` e `c68deda` (`git diff 86d2b5e..HEAD`) e do app numa cópia em caminho ASCII: build release servido localmente e uma sessão em modo debug, abertos em `/`, `/admin` e `/admin/painel/publicacoes` sem login. Sem credenciais de teste e sem dados alterados.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia ASCII) | sem problemas, antes e depois da correção |
| `dart format` no projeto (conferência do `CLAUDE.md`) | 0 arquivos mudados |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro |
| `grep` de `num_extension`, componentes e getters Dosis, cores antigas, `Colors.`, `.scale` e `*Spacing` nos arquivos do critério 1 | nada (só `Colors.transparent` no `search_field.dart`, que é de antes e não é cor antiga) |
| `grep` de números soltos nos mesmos arquivos | só `minLines`/`maxLines`, `Positioned(0)` e limites do formatador de data |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Sem tokens antigos | passou | `grep` acima |
| 2 | Sem valor solto | passou | espaçamentos via `spacing`/`radii`; tamanhos novos em `ComponentSizes` (`panelDialog*`, `panelField*`, `panelTabViewHeight`, `panelImagePreview*`, `panelEditor*Factor`, `videoControlIcon`) |
| 3 | Criar e editar funcionam | não conferido | exige login; por código, dados, validadores e `onSubmit` intocados |
| 4 | Validação | passou em parte | login: "Entrar" vazio mostra as mensagens em `error` abaixo dos campos, borda de erro 2 px no foco; diálogos do painel exigem login |
| 5 | "Cancelar" e "Ver imagem" | não conferido | exige login; por código, "X" virou `AppIconButton` "Fechar" e o diálogo é `showDialog` (Esc padrão) |
| 6 | Tab e foco visível | passou em parte | login percorrido por Tab na implementação; foco em `accent` 2 px visto no e-mail; abas com sobreposição no foco; alternância com nome pelo rótulo. Ver ressalva do Quill |
| 7 | Contraste | passou | `inkSecondary` 7,01 (6,45 em `surface`); `error` 6,54; `fieldBorder` 3,82 no branco e 3,51 em `surface` (≥ 3:1 de componente de UI); botões de autor em `accent` 4,87 |
| 8 | Diálogos sem `overflow` | passou em parte | campos e listas compartilhados sem `overflow` em 390, 768 e 1280 (filtros do painel e login, release e debug); diálogos exigem login. Por conta: área das abas (96 px) comporta campo + erro de URL de uma linha; prévia de 117×88 + botão cabem nos 326 px úteis em 390; nome de arquivo com reticências |
| 9 | Vídeo da Home | passou | player aberto em 390 e redimensionado para 768 e 1280 no modo debug, sem asserção no console |
| 10 | `analyze` | passou | sem problemas |

## Pontos da implementação conferidos
- `PanelFieldDecoration`: decoração única para texto e lista de opções, com os estados exigidos (desativado em `surface`, foco 2 px `accent`, erro em `error`). Também usada pelo login, o que cobre o item "Login" da spec.
- Foco com 2 px: o campo do site usa anel de 4 px por fora; aqui a borda engrossa porque o rótulo flutuante fica sobre ela. Aceito.
- Alturas dos editores em fração da altura da tela (0,7/0,4/0,3): é a mesma regra de antes, agora em token. Não escala com a largura (não é `num_extension`) e fica dentro do formulário rolável; a regra de "tamanho fixo por faixa" mira tamanhos que encolhem com a largura. Aceito sem mudança.
- Área das abas de 72 para 96 px e prévia 88 px em 4:3: registradas no histórico da spec; conferidas por conta acima.

## Problemas encontrados
- **Campos de autor sem nome acessível** (`create_or_update_article_dialog.dart`, ajuste): os campos repetidos de autor não tinham rótulo, e o leitor de tela não dizia o que pediam. Corrigido com o rótulo flutuante "Autor N" (`b4dd993`); conferido por `analyze` e pela busca de `AppTextField` sem `labelText` nos diálogos (nenhum restante).

## Ressalvas
- **Tab no editor de texto rico:** o `flutter_quill` usa Tab para recuo dentro do editor, o que prende a navegação por teclado nos formulários com Quill. É comportamento de antes e mudar o Tab tira o recuo de listas; não conferido na tela (exige login). Fica para decidir junto com a pessoa.

## Não conferido
- Criar, editar, cancelar e validar nos diálogos de usuário, mídia, categoria, membro e nos 10 tipos de publicação; "Ver imagem" com imagem e vídeo; upload em produção: exigem login, sem credenciais de teste.
- Diálogos em 390, 768 e 1280 px com o formulário de artigo e nome de arquivo longo.
- Leitor de tela de verdade.
