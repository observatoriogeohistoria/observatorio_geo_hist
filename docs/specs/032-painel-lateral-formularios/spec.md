# 032. Painel lateral para formulários curtos

- **Status:** aprovada
- **Item do planejamento:** Fase 8, item 8.4 (T-13)
- **Protótipo:** aba "Painel", botões "Nova categoria", "Novo documento", "Novo membro", "Novo usuário" e "Editar" das linhas (link no CLAUDE.md)
- **Criada em:** 2026-10-07

## Objetivo
Criar e editar categoria, documento da biblioteca, membro da equipe, usuário e enviar imagem passam a acontecer num painel que desliza da direita, com rótulos claros, dicas sobre o efeito de cada campo e botões sempre visíveis no pé. A lista continua à vista por trás.

## Situação atual
- `right_aligned_dialog.dart` já abre os formulários encostados à direita, com altura total. Título no topo (`panel_dialog_title.dart`), campos com rótulos técnicos ("Chave", "Papel", "URL do Lattes", "Tipo de Produção"), interruptores para áreas, botões "Cancelar" e "Criar"/"Atualizar" no fim do conteúdo (rolam junto).
- Formulários: `create_or_update_category_dialog.dart` (chave, título, descrição, imagem, História, Geografia, Colaborar), `create_or_update_team_member_dialog.dart` (nome, papel, Lattes, descrição, foto), `create_or_update_user_dialog.dart` (nome, e-mail, senha só ao criar, papel em lista suspensa com `ADMIN`/`EDITOR`/`VIEWER`), `create_or_update_document_dialog.dart` (título, autor, instituição, ano, PDF, tipo, categorias), `create_media_dialog.dart` (nome do arquivo e "Selecionar arquivo").
- Erro ao salvar: aviso flutuante; o diálogo fecha só no sucesso.

## Comportamento

### Painel lateral (comum a todos)
- Abre da direita, com fundo escurecido sobre o resto. Largura fixa no tablet e desktop; tela cheia no celular.
- **Cabeçalho fixo:** título ("Nova categoria"/"Editar categoria", "Novo documento"/"Editar documento", "Novo membro"/"Editar membro", "Novo usuário"/"Editar usuário", "Enviar imagem") e botão de fechar com "×" (dica "Fechar sem salvar").
- **Corpo:** campos com rótulo em caixa normal acima do campo; "opcional" em cinza ao lado do rótulo quando o campo não é obrigatório; dica em cinza abaixo quando explica um efeito. Rola sozinho se não couber.
- **Pé fixo:** "Cancelar" e "Salvar" (à direita). Enter num campo de uma linha envia.
- **Ao abrir**, o foco vai para o primeiro campo. Esc, "×", "Cancelar" ou clique no fundo fecham sem salvar e o foco volta ao botão que abriu.
- **Validação ao salvar:** mensagens abaixo de cada campo ("Preencha este campo.", "Informe um e-mail válido.", e as atuais para Lattes, ano e senha), foco no primeiro campo com erro.
- **Salvando:** "Salvar" desabilitado com "Salvando…"; os campos não aceitam edição.
- **Sucesso:** o painel fecha, a lista se atualiza e aparece o aviso curto (030).
- **Erro:** o painel continua aberto, com o que foi digitado, e um aviso vermelho no topo do corpo com a mensagem do erro.

### Categoria
- "Nome" (hoje "Título").
- "Endereço" (hoje "Chave"), com a dica "Vira o fim do link: /publicacoes/geografia/{endereço}" mostrando o valor digitado.
- "Descrição", várias linhas, dica "Aparece no topo da página da categoria."
- "Imagem de fundo", com o campo de imagem de hoje.
- "Áreas": caixas de seleção "História" e "Geografia" (no lugar dos interruptores).
- Interruptor "Aceita colaboração", dica "Mostra o botão “Colabore” na página da categoria."

### Documento da biblioteca
- "Título", "Autor", "Instituição", "Ano" (dica `AAAA`).
- "Tipo de produção": lista suspensa com Dissertação e Tese.
- "Categorias": as 16 em caixas de seleção dentro de uma caixa com rolagem própria.
- "Arquivo": área de escolha do PDF ("Escolher PDF"), mostrando o nome do arquivo escolhido ou atual.
- A área (Geografia ou História) é a que está aberta na lista, como hoje.

### Membro da equipe
- "Nome"; "Função" (hoje "Papel"); "Currículo Lattes" opcional, dica do formato `https://lattes.cnpq.br/…`.
- "Descrição" opcional, várias linhas, dica "Com descrição, a pessoa ganha página própria no site."
- "Foto": área quadrada de escolha de imagem, mostrando a foto atual.

### Usuário
- "Nome"; "E-mail".
- "Senha inicial", só ao criar, com a dica "8 caracteres ou mais, com letra maiúscula, minúscula, número e caractere especial. Envie à pessoa por um canal seguro."
- "Papel": três opções em cartões de escolha única, com título e explicação:
  - "Administração": "Tudo, inclusive criar e remover usuários."
  - "Edição": "Cria, edita e publica conteúdo."
  - "Leitura": "Só vê o painel, sem alterar nada."
  O cartão escolhido fica com borda e fundo de acento.

### Enviar imagem (Mídias)
Mesmo fluxo de hoje, decidido com a pessoa: "Escolher imagem" abre o seletor; depois o nome do arquivo aparece (só leitura) e "Salvar" envia uma imagem. No dev sem Storage, a mensagem atual de envio desabilitado continua, e "Salvar" fica desabilitado.

## Estados
- **Carregando:** "Salvando…" no botão. Ao editar, o painel já abre com os dados da linha (sem nova consulta).
- **Vazio:** não se aplica.
- **Erro:** aviso no topo do corpo; validação por campo.
- **Sem imagem / imagem com falha:** área de imagem com ícone e "Escolher imagem"/"Escolher foto"; imagem atual que falha mostra o mesmo placeholder.
- **Casos de borda:** descrição muito longa rola dentro do campo; muitas categorias rolam dentro da caixa; nome de PDF longo com reticências.

## Responsivo
- **390:** painel em tela cheia; pé fixo com os dois botões dividindo a largura.
- **768 e 1280:** painel de largura fixa à direita, lista visível e escurecida ao lado.

## Acessibilidade
- Painel anunciado como diálogo com o título; foco preso dentro enquanto aberto.
- Tab percorre campos, caixas, cartões de papel e o pé, com foco visível. Cartões de papel funcionam como opções de escolha única (setas trocam).
- Erros ligados aos campos; aviso de erro anunciado.
- Contraste ≥ 4,5:1 em "opcional", dicas e explicações dos papéis.

## Dados e regras de negócio
- Os mesmos campos de hoje em cada formulário, com as mesmas obrigatoriedades e validações. Mudam só rótulos, dicas e o tipo de controle (caixas no lugar de interruptores para áreas, cartões no lugar da lista de papéis).
- Valores salvos iguais (`ADMIN`, `EDITOR`, `VIEWER`; chave da categoria; áreas).
- Senha continua só no cadastro e com a regra atual.

## Critérios de aceite
- [ ] Os cinco formulários abrem no painel lateral e reproduzem o protótipo em 390, 768 e 1280 px, sem `overflow` nem rolagem horizontal.
- [ ] Cabeçalho e pé ficam fixos enquanto o corpo rola.
- [ ] Criar e editar categoria, documento, membro e usuário salvam os mesmos dados de hoje; enviar imagem funciona onde há Storage.
- [ ] Dica do endereço da categoria mostra o valor digitado.
- [ ] Papel do usuário escolhido por cartões, com as três explicações; o valor salvo é o mesmo de antes.
- [ ] Salvar vazio mostra as mensagens nos campos e foca o primeiro com erro.
- [ ] Durante o envio aparece "Salvando…" e não há envio duplo.
- [ ] Sucesso fecha o painel, atualiza a lista e mostra o aviso curto; erro mantém o painel aberto com os dados e o aviso.
- [ ] Esc, "×", "Cancelar" e clique no fundo fecham sem salvar; o foco volta ao botão de origem.
- [ ] Navegação completa por teclado, com foco preso no painel.
- [ ] Contraste ≥ 4,5:1 em rótulos, dicas e "opcional".
- [ ] Sem cor, fonte ou espaçamento solto; o que faltar vira token.
- [ ] `fvm flutter analyze` sem erros novos.

## Fora do escopo
- Formulário de publicação (033).
- Envio de várias imagens de uma vez.
- Novos campos ou regras de validação.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-07: criada. Decidido com a pessoa manter o fluxo atual de envio de mídia (uma imagem), agora no painel lateral.
- 2026-10-07: aprovada.
