# 030. Estrutura do painel: barra superior, menu, avisos e confirmações

- **Status:** aprovada
- **Item do planejamento:** Fase 8, item 8.2 (T-13, P-14)
- **Protótipo:** aba "Painel" (link no CLAUDE.md)
- **Criada em:** 2026-10-07

## Objetivo
O painel ganha a moldura do protótipo: barra superior com quem está logado, menu lateral em grupos com contagens, cabeçalho de seção com a ação principal, aviso curto depois de cada ação, confirmação antes de excluir e dica em todo botão só de ícone. Assim fica claro onde se está, o que cada botão faz e que a ação deu certo.

## Situação atual
- `panel_page.dart`: barra laranja com "PAINEL ADMINISTRATIVO" centralizado e ícone de sair. No desktop o menu fica fixo e pode ser recolhido; abaixo de 1024 vira gaveta pelo ícone da barra.
- `admin/sidebar/*`: logo no topo, itens soltos (Usuários, Mídias, Categorias, Posts, Equipe, Biblioteca) e "Posts" abre e fecha os 10 tipos. Sem contagens. Botão de recolher no pé.
- Seções (`section_header_*`, `crud_section.dart`): título laranja grande e botão "Criar" à direita.
- Ações dão aviso flutuante do Material (`Messenger`). **Excluir não pede confirmação.** Botão de excluir categoria com publicações simplesmente não aparece.
- Botões de ícone já têm `tooltip`, com textos curtos ("Excluir post").

## Comportamento

### Barra superior
Fundo branco com linha embaixo (deixa de ser laranja).
- Esquerda: botão de menu (só abaixo de 1024), logo e "Observatório / Painel" (link para a primeira seção do painel).
- Direita: botão "Ver site" com ícone de link externo (abre a Home numa nova aba) e a pessoa logada: círculo com as iniciais do nome, nome e papel ("Administração", "Edição" ou "Leitura", para `ADMIN`, `EDITOR` e `VIEWER`).
- Acima da barra, no dev, a faixa "Ambiente de testes" (029).

### Menu lateral
Largura fixa, sempre aberto no desktop. **Sai o recolher** (decidido com a pessoa). Grupos com título em versalete cinza:
- **Conteúdo:** Publicações; logo abaixo, sempre visíveis e recuados, os 10 tipos no plural ("Artigos", "Produções acadêmicas", "Livros", "Documentos", "Eventos", "Filmes", "Revistas", "Músicas", "Podcasts", "Pesquisas", na ordem de hoje); Categorias; Biblioteca.
- **Arquivos e pessoas:** Mídias; Equipe.
- **Administração:** Usuários. O grupo inteiro só aparece para quem pode ver Usuários (como hoje).
- No pé, "Sair", em cinza.

Cada item tem ícone, nome e, à direita, a **contagem** em cinza: publicações (total e por tipo), categorias, documentos da biblioteca (as duas áreas), membros da equipe e usuários. **Mídias fica sem número**, porque o Storage não informa o total sem listar tudo. Enquanto a contagem carrega, ou se ela falhar, o número não aparece (o item continua funcionando). As contagens se atualizam depois de criar ou excluir.

Item atual com fundo `accentSoft` e texto `accentStrong`. Com um tipo selecionado, "Publicações" fica em `accentStrong` sem fundo e o tipo fica marcado. Clicar em "Publicações" abre "Artigos".

### Gaveta (abaixo de 1024)
O botão de menu abre o menu por cima do conteúdo, com fundo escurecido. Fecha ao escolher um item, ao tocar fora ou com Esc. Ao abrir, o foco vai para o item atual; ao fechar sem escolher, volta ao botão de menu.

### Cabeçalho de seção
Em todas as seções: sobretítulo laranja com o grupo ("Publicações", "Conteúdo", "Arquivos e pessoas", "Administração"), título grande (nome da seção ou do tipo), uma linha de resumo em cinza e, à direita, o botão principal com "+": "Novo artigo", "Nova produção", "Novo livro", "Novo documento", "Novo evento", "Novo filme", "Nova revista", "Nova música", "Novo podcast", "Nova pesquisa", "Nova categoria", "Novo documento" (biblioteca), "Enviar imagens" (mídias, abre o diálogo atual), "Novo membro", "Novo usuário". Quem só pode ver (`VIEWER`) não vê o botão.

Resumos:
- Tipo de publicação: "N no total" (ou "Nenhuma ainda").
- Categorias: "N categorias · aparecem no menu de História e Geografia".
- Biblioteca: "N documentos em Geografia" (área aberta).
- Mídias: "Imagens usadas nas publicações. Copie o link para usar no editor."
- Equipe: "N pessoas · quem tem descrição ganha página no site".
- Usuários: "N usuários · só a administração vê esta seção".

Ao trocar de seção, o foco vai para o título da seção.

### Aviso curto após ações
Substitui o aviso flutuante no painel: caixa escura com ícone de confirmação, centralizada embaixo, some sozinha em cerca de 3 segundos e é anunciada ao leitor de tela. Textos:
- Publicar: "Publicado. Já aparece no site." Despublicar: "Despublicado. Saiu do site."
- Destacar: "Destacado na Home." Tirar: "Saiu dos destaques da Home."
- Excluir: "Publicação excluída.", "Categoria excluída.", "Documento excluído.", "Imagem excluída.", "Membro removido da equipe.", "Usuário excluído."
- Salvar: "Categoria salva.", "Documento salvo.", "Membro salvo.", "Usuário salvo.", "Imagem enviada."
- Copiar link: "Link copiado."

Erros continuam num aviso de erro (vermelho, com a mensagem atual), que não some sozinho rápido demais para ser lido. Acesso negado continua saindo do painel.

### Confirmação antes de excluir
Toda exclusão abre uma janela com título, explicação e os botões "Cancelar" (foco inicial) e "Excluir" (vermelho, com ícone). Esc ou clique fora cancelam; o foco volta ao botão que abriu.
- Publicação: "Excluir esta publicação?" / "“Título” sai do site e do painel. Não dá para desfazer."
- Categoria: "Excluir esta categoria?" / "“Nome” sai do site e do painel. Não dá para desfazer."
- Documento: "Excluir este documento?" / mesmo modelo.
- Imagem: "Excluir esta imagem?" / "Publicações que usam “nome.jpg” ficam sem imagem. Não dá para desfazer."
- Membro: "Remover este membro?" / "“Nome” sai da equipe no site e do painel. Não dá para desfazer."
- Usuário: "Excluir este usuário?" / "“Nome” deixa de ter acesso ao painel. O que a pessoa publicou continua no site."

### Dicas nos botões de ícone (P-14)
Todo botão só de ícone do painel tem dica ao passar o mouse **e** ao receber foco por teclado, dizendo o que acontece:
- "Publicar: passa a aparecer no site" / "Despublicar: sai do site e continua salva no painel"
- "Destacar: entra nos destaques da Home" / "Tirar dos destaques: deixa de aparecer no topo da Home"
- "Editar: abre a publicação no editor" (publicações) / "Editar: abre o formulário ao lado" (demais)
- "Excluir: pede confirmação antes de apagar"
- "Ver: abre a imagem em tamanho maior", "Copiar link: para colar no editor"
- Botão indisponível explica o motivo: excluir categoria com publicações aparece desabilitado com "Só dá para excluir categoria sem publicações. Esta tem N." (hoje o botão some).
- Fechar painel lateral: "Fechar sem salvar"; menu: "Abrir menu do painel"/"Fechar menu do painel".

O nome acessível do botão é a ação curta ("Excluir"); a dica é a descrição.

## Estados
- **Carregando:** esqueleto da lista ao abrir uma seção (detalhado em 031). Contagens do menu sem número enquanto carregam.
- **Vazio / Erro:** em 031.
- **Casos de borda:** nome da pessoa longo encurta com reticências; contagens de 3 dígitos cabem sem empurrar o nome do item; menu mais alto que a janela rola por dentro.

## Responsivo
- **390:** gaveta; na barra somem "Ver site" e o nome do produto (fica o logo), e a pessoa aparece só com as iniciais. Botão principal da seção ocupa a largura, abaixo do título.
- **768:** gaveta; barra com logo, nome, "Ver site" e iniciais.
- **1280:** menu fixo à esquerda, conteúdo ao lado; barra completa com nome e papel.

## Acessibilidade
- Menu com nome "Seções do painel"; item atual marcado como atual para leitor de tela.
- Tudo alcançável por Tab com foco visível: barra, itens e subitens do menu, Sair, botão principal, botões das linhas, janela de confirmação (foco preso dentro enquanto aberta).
- Dica aparece no foco por teclado e some com Esc.
- Contraste ≥ 4,5:1 em contagens, títulos de grupo, papel da pessoa e itens não selecionados.

## Dados e regras de negócio
- Sem mudança em permissões: Usuários só para `ADMIN`; criar, editar e excluir só para `ADMIN` e `EDITOR`.
- Rotas iguais: `/admin/painel/:tab`, `?tipo=`, `/admin/painel/biblioteca/:area`.
- Contagens são só leitura (consultas de contagem no Firestore). Se alguma pedir índice novo, o plano registra.
- Regra de exclusão de categoria (só sem publicações) continua igual.

## Critérios de aceite
- [ ] Barra superior, menu e cabeçalhos reproduzem a aba "Painel" do protótipo em 390, 768 e 1280 px, sem `overflow` nem rolagem horizontal.
- [ ] Menu em três grupos; Administração só aparece para `ADMIN`.
- [ ] Os 10 tipos aparecem sempre abaixo de Publicações; clicar em Publicações abre Artigos.
- [ ] Contagens corretas para publicações (total e por tipo), categorias, biblioteca, equipe e usuários; Mídias sem número; contagem que falha não quebra o menu.
- [ ] Não existe mais o botão de recolher.
- [ ] Barra mostra nome e papel da pessoa logada; "Ver site" abre a Home em nova aba.
- [ ] Abaixo de 1024 a gaveta abre, fecha com Esc, toque fora e ao escolher item, com foco no item atual.
- [ ] `VIEWER` não vê botão principal nem ações de editar, publicar, destacar e excluir.
- [ ] Toda exclusão pede confirmação; "Cancelar" não exclui; "Excluir" exclui e mostra o aviso curto.
- [ ] Excluir categoria com publicações aparece desabilitado e a dica diz quantas ela tem.
- [ ] Toda ação de sucesso mostra o aviso curto com o texto da lista; erro mostra aviso de erro.
- [ ] Todo botão só de ícone do painel tem dica no mouse e no foco por teclado e nome acessível.
- [ ] Contraste ≥ 4,5:1 nos textos e ícones informativos da barra e do menu.
- [ ] Sem cor, fonte ou espaçamento solto; o que faltar vira token.
- [ ] `fvm flutter analyze` sem erros novos.

## Fora do escopo
- Layout das listas e filtros (031), painel lateral dos formulários (032) e editor (033). Até lá, as listas e diálogos atuais continuam dentro da moldura nova.
- Envio de várias imagens de uma vez: Mídias mantém o diálogo atual, decidido com a pessoa.

## Perguntas em aberto
- Nenhuma.

## Histórico de mudanças
- 2026-10-07: criada. Decidido com a pessoa tirar o recolher do menu e manter o diálogo atual de envio de mídia.
- 2026-10-07: aprovada.
