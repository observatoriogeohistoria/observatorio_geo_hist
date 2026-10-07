# 025. Diálogos e campos do painel nos tokens novos

- **Status:** implementada
- **Item do planejamento:** Fase 6, item 6.3
- **Protótipo:** não há telas do painel. A referência são os tokens e componentes do site público.
- **Criada em:** 2026-10-06

## Objetivo
Os diálogos de criar e editar do painel e os campos de formulário que eles usam passam a usar só os tokens novos, sem `num_extension`, sem a fonte Dosis e sem as cores antigas. Os formulários continuam pedindo os mesmos dados e salvando do mesmo jeito.

## Situação atual
- **Diálogo lateral** (`core/components/dialog/right_aligned_dialog.dart`): painel cinza-claro que entra pela direita, com largura de tela cheia no celular, 70 % no tablet e 50 % no desktop. É a base dos formulários (`post_form_dialog.dart`, com "Cancelar" e "Criar"/"Atualizar"/"Aguarde...") e do "Ver imagem".
- **Diálogos do painel** (`panel/.../dialogs/`): usuário, mídia, categoria, membro da equipe, ver imagem, escolha de tipo de publicação (`create_or_update_post_dialog.dart`) e os 10 formulários de publicação (`create_or_update_posts_dialogs/`). Títulos e rótulos de grupo ("Área", "Categoria") em laranja Dosis.
- **Campos** (`core/components/field/`): texto, lista de opções, seleção múltipla, imagem (abas "URL" e "Upload") e documento (mesmas abas). Rótulo flutuante dentro do campo, borda cinza, foco laranja, erro vermelho, tudo em Dosis e com espaçamento que escala.
- **Outros de `core/`:** botão de alternância (`switch_button.dart`, "Publicado"/"Destaque"), editor de texto rico (`quill/editor_quill.dart`), player de vídeo do "Ver imagem" (`video_player/app_video_player.dart`) e o indicador dele (`loading_content.dart`).

## Comportamento
Layout, textos, campos e fluxos continuam os mesmos. Muda a aparência:
- **Diálogo lateral:** fundo `page`, borda à esquerda em `line`, cantos arredondados e espaçamento interno fixos. As larguras por faixa continuam, agora como tokens. No celular, a largura é a da tela.
- **Títulos dos diálogos** ("Criar usuário", "Atualizar categoria" etc.) em fonte de título e `ink`; rótulos de grupo ("Área", "Categoria", "Tipo de Produção" etc.) no estilo de rótulo de formulário do site, em `ink`.
- **Campos:** mantêm o rótulo flutuante. Texto em Figtree e `ink`; rótulo e dica em `inkSecondary`; borda `fieldBorder`; foco em `accent`; erro em `error`, com a mensagem em Figtree. Campo desativado com fundo `surface`.
- **Abas "URL"/"Upload"** em `ink` (selecionada) e `inkSecondary`, com indicador `accent`. "Nenhuma imagem selecionada" e "Nenhum arquivo selecionado" em `inkSecondary`.
- **Botão de alternância:** rótulo em Figtree e `ink`, ligado em `accent`.
- **Editor de texto rico:** borda `fieldBorder`, foco visível em `accent` e espaçamento fixo.
- **Ver imagem:** o "X" de fechar ganha nome ("Fechar") e foco visível; o player usa espaçamento fixo e indicador em `accent`.
- **Login:** o campo de e-mail e senha, que ficou fora da spec 023, ganha o mesmo visual dos campos acima.

## Estados
- **Carregando ao salvar:** como hoje ("Aguarde..." no botão principal, "Cancelar" escondido).
- **Carregando arquivo:** "Carregando..." no botão de arquivo, como hoje.
- **Erro de validação:** mensagem abaixo do campo, em `error`.
- **Erro ao salvar:** aviso de erro (spec 023), diálogo continua aberto.
- **Imagem com falha no "Ver imagem":** mensagem de erro de imagem da spec 024, sem estourar o diálogo.
- **Casos de borda:** formulário mais alto que a tela rola dentro do diálogo com os botões sempre visíveis; nome de arquivo longo quebra ou é cortado com reticências, sem rolagem horizontal.

## Responsivo
- **390:** diálogo ocupa a tela; campos lado a lado viram coluna quando não couberem.
- **768:** diálogo com a largura de tablet.
- **1280:** diálogo com a largura de desktop.

## Acessibilidade
- Ordem de Tab segue a ordem visual dos campos; foco visível em campos, abas, alternâncias, botões e no "X".
- Botões só com ícone com nome acessível.
- Rótulos, dicas, mensagens de erro e textos auxiliares com contraste mínimo de 4,5:1. Borda do campo com 3:1.

## Dados e regras de negócio
Sem mudança em validações, campos obrigatórios, upload, envio da imagem antes do post, troca de categoria, permissões ou dados gravados. O aviso de upload desativado no ambiente de testes continua.

## Critérios de aceite
- [ ] Nenhum arquivo de `panel/presentation/components/dialogs/` (inclusive `create_or_update_posts_dialogs/`), nem `right_aligned_dialog`, `field/*`, `switch_button`, `editor_quill`, `app_video_player` e `loading_content`, importa `num_extension`, usa os componentes ou getters de texto Dosis ou as cores `orange`, `lightOrange`, `amber`, `gray`, `lightGray`, `lighterGray`, `darkGray`, `red`, `green`, `blue`.
- [ ] Sem cor, tamanho de fonte ou espaçamento solto nesses arquivos.
- [ ] Criar e editar funcionam como antes para usuário, mídia, categoria, membro da equipe e os 10 tipos de publicação (com imagem por URL e, em produção, por upload).
- [ ] Validação mostra as mensagens de erro nos campos obrigatórios e impede salvar.
- [ ] "Cancelar" fecha sem salvar; "Ver imagem" abre imagem e vídeo e fecha pelo "X" e por Esc.
- [ ] Formulários percorríveis por Tab na ordem visual, com foco visível em todos os controles.
- [ ] Contraste ≥ 4,5:1 em rótulos, dicas, erros e textos auxiliares; borda de campo ≥ 3:1.
- [ ] Diálogos sem `overflow` nem rolagem horizontal em 390, 768 e 1280 px, com o formulário mais longo (artigo) e com nome de arquivo longo.
- [ ] O vídeo de apresentação da Home, que usa o mesmo player, continua sem `overflow` em 390, 768 e 1280 px.
- [ ] `fvm flutter analyze` sem erros novos.

## Fora do escopo
- Diálogo de documento da biblioteca e filtros da biblioteca do painel (spec 026), embora usem os mesmos campos.
- Trocar o rótulo flutuante pelo rótulo acima do campo, como no formulário de contato do site.
- Novos campos, validações ou mudanças nos dados.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-06: criada e aprovada.
- 2026-10-06 (implementação): botões de adicionar e remover autor só existem no diálogo de artigo; filme, documento e música têm campo único e só mudam título e espaçamentos. A área das abas "URL"/"Upload" passa de 72 para 96 px para caber a mensagem de erro da URL, e a prévia da imagem enviada fica com 88 px de altura em proporção 4:3 (os 120 px do plano eram cortados para a altura da área). O formulário de contato do site não usa os campos de `core/components/field/`; a conferência pública fica no vídeo da Home.
