# Redesign do site: planejamento

Este documento registra as decisões de design tomadas, o que ainda falta no protótipo e a ordem de implementação no Flutter. O portal administrativo e a seção Geoensine ficam fora deste escopo.

- **Protótipo (v5, com todas as telas):** https://claude.ai/artifact/PimRbbQyUDbqrapiv8HseH
- **Situação:** protótipo aprovado na direção geral. Implementação ainda não iniciada.
- **Primeira entrega:** Home (e o "casco" compartilhado por todas as páginas: navbar, rodapé, botões e tokens).

---

## 1. Decisões já tomadas

| Tema | Decisão |
|---|---|
| Público | Professores, pesquisadores e estudantes, em desktop e celular |
| Tom | Moderno, limpo, leitura confortável |
| Fonte | Sem serifa. Títulos em Bricolage Grotesque, texto em Figtree (substitui a Dosis) |
| Cor | Laranja como acento, levemente mais escuro (#C94400) para contraste. Neutros quentes |
| Rodapé | Escuro e discreto, em colunas |
| Modo escuro | Fora do escopo por enquanto |
| Imagens | Enviadas pelos autores, sem controle de proporção. O layout precisa aceitar qualquer imagem (proporção fixa 16:10 com `cover`, degradê só sob o título, placeholder quando não há imagem) |
| Menu História/Geografia | As categorias reais permanecem como estão e **não são agrupadas**. Os nomes do protótipo são apenas exemplos |
| Logo | A marca provisória do protótipo (círculos concêntricos em laranja) passa a ser a marca oficial. Arquivo SVG criado em `assets/images/logo.svg` → specs/002-botoes-navbar-rodape, concluído |
| Biblioteca: categoria | Seleção livre de quantas categorias o usuário quiser, como já é hoje (documento aparece se tiver qualquer uma delas). Sem "Todas" e sem agrupar |
| Categorias | Permanecem como estão em **ambos** os lugares: menu de posts e as 16 categorias de documentos. Nada é agrupado |
| Fale com a gente | Mantém o comportamento atual: o botão **abre o programa de e-mail** com os dados preenchidos, e a pessoa só aperta Enviar. Sem servidor. Melhorias: validação e tela de confirmação com "Copiar mensagem" para quem não tem programa de e-mail |
| Parceiros | A mesma lista de **9 parceiros** na Home e no post |
| Fontes | Bricolage Grotesque (é o nome completo da família no Google Fonts) e Figtree, **embutidas** nos assets |
| Rodapé: "Colabore" | Não aparece no rodapé. O botão continua no cabeçalho da categoria, condicionado a `hasCollaborateOption` |

---

## 2. Ajustes pedidos na revisão do protótipo

Itens vindos da revisão do protótipo. Todos já estão refletidos no protótipo atual e servem de requisito na implementação de cada tela.

**Status:** o protótipo v5 aplica P-01 a P-12. O P-11 foi fechado como seleção livre de categorias (sem "Todas" e sem agrupamento). A busca (P-13) ficou como ideia futura (seção 9).

### Geral e rodapé
- **P-01** Remover "Colabore" do rodapé.
- **P-02** Incluir redes sociais no rodapé (Instagram, Facebook e YouTube, como no componente `Support` atual).
- **P-03** "Realização e apoio": usar os logos reais (`assets/images/partners`) e adicionar efeito ao passar o mouse. Proposta: logos em escala de cinza e opacidade reduzida que ganham cor, sobem 2px e crescem levemente no hover. Se o parceiro tiver link, o logo é clicável e mostra foco visível.
- **P-04** Menu: dentro de História e Geografia continuam listadas as **categorias reais** (vindas do banco de dados), sem agrupamento. No desktop abrem ao passar o mouse ou clicar. No celular, cada área é uma sanfona com suas categorias, como no site atual (`NavbarMobileMenu`). Em Geografia, Expogeo e Geoensine ficam antes, separados por um divisor. Os nomes no protótipo são exemplos.

### Post
- **P-05** Remover o "tempo de leitura".
- **P-06** Ampliar o compartilhamento. Proposta: Copiar link, WhatsApp, Facebook, X, LinkedIn, Telegram e E-mail. No celular, oferecer também o compartilhamento nativo do sistema. Em telas estreitas, agrupar os menos usados em "Mais".
- **P-07** Reincluir a seção **Apoio** (redes sociais e os 9 apoiadores), que existe hoje no `Support` (com 4 apoiadores) e foi omitida no protótipo. Posição: depois do conteúdo e do "Leia também", antes do rodapé.
- **P-08** Layout-base do post com variações por tipo (ver seção 3, item "Tipos de post").

### Biblioteca
- **P-09** A entrada da biblioteca lista as **áreas** (Geografia e História), como no site atual, e não tipos de documento. Remover os cartões inventados ("Artigos científicos", "Livros e capítulos"). Mostrar a contagem por área.
- **P-10** Tipos de documento: apenas **Tese** e **Dissertação**. Remover "Artigo" do filtro.
- **P-11** Filtro **Categoria** (16 valores fixos em `DocumentCategory`): seleção livre de quantas categorias o usuário quiser (o documento aparece se tiver qualquer uma delas). Sem "Todas" e sem agrupamento.
- **P-12** Mostrar contagem por tipo e por categoria nos filtros (o datasource já tem `countByType` e `countByCategory`).

### Busca geral
- **P-13** Busca geral do site: desenhada no protótipo, mas **fora das fases atuais** (ver seção 9).

---

## 3. Telas do protótipo

Todas as telas abaixo já existem no protótipo v5. A coluna "Observações" registra o que precisa ser considerado na implementação.

| ID | Tela | Rota atual | Observações |
|---|---|---|---|
| T-01 | Manifesto | `/manifest` | Leitura longa. Os cinco compromissos viram lista numerada (a ordem é do texto original) |
| T-02 | Pessoa da equipe | `/membro/:id` | Foto, nome, função e descrição. Só é acessível quando o membro tem descrição. Corrigir a busca em laço com id inexistente (ver verificação da 008) |
| T-03 | Nossa história (completa) | `/nossa-historia` | Criada na spec 007 como página provisória, com o texto completo que estava na Home. A Home mostra só o resumo. Redesenho na Fase 2 |
| T-04 | Fale com a gente | `/contato` | Continua abrindo o programa de e-mail (`mailto:`). Novidades: validação dos campos e tela de confirmação com "Copiar mensagem" |
| T-05 | Colabore | `/colaborar` | Continua existindo, acessada pelo cabeçalho da categoria |
| T-06 | Biblioteca: lista por área | `/biblioteca/:area` | Filtros, resultados e paginação |
| T-07 | Biblioteca: detalhe do documento | `/biblioteca/:area/documento/:slug` | Metadados e visualizador do documento |
| T-08 | Tipos de post | `/posts/:area/:category/:id` | Hoje são 10 layouts (artigo, documento, livro, filme, revista, podcast, música, produção acadêmica, evento, pesquisa). Proposta: um layout-base único com blocos específicos por tipo. O protótipo mostra Livro, Filme, Podcast/Música, Evento e Pesquisa; os demais reaproveitam esses blocos |
| T-09 | Busca | novo | **Ideia futura.** Desenhada no protótipo (aba "Busca (ideia)"), sem implementação planejada. Ver seção 9 |
| T-10 | Estados especiais | `PageNotFound`, erro e vazio | Página 404, erro de carregamento, lista vazia e esqueletos de carregamento |

---

## 4. Plano de implementação

### Princípios
1. **Componentes compartilhados mudam todas as páginas de uma vez.** Navbar, rodapé, botões, `Support` e `Partners` aparecem em várias telas. Por isso a Fase 0 os entrega juntos, e as demais páginas continuam funcionando, só ficam com a nova roupa desses componentes antes de serem redesenhadas.
2. **Tokens novos ao lado dos antigos.** As telas migram uma a uma. Só removemos os tokens antigos quando nenhuma tela os usa.
3. **Tamanhos por breakpoint.** Os componentes novos usam tamanhos fixos por faixa de largura (celular, tablet, desktop) e uma largura máxima de conteúdo. Deixam de depender de `num_extension` (escala pelo tamanho da tela). A extensão só é removida no fim.
4. **Cada fase termina com critérios de aceite** conferidos contra o protótipo, no celular e no desktop.

### Fase 0: Fundação e casco (base da Home)
Dividida em três specs: 0.1 a 0.3 → specs/001-fundacao; 0.4 a 0.6 → specs/002-botoes-navbar-rodape; 0.7 → specs/003-index-carregamento.

| # | Entrega | Principais arquivos |
|---|---|---|
| 0.1 | Tokens: cores novas, raios, espaçamentos, sombras → specs/001-fundacao, concluído | `theme/app_colors`, `theme/app_dimensions` |
| 0.2 | Tipografia nova (Bricolage + Figtree). **Decisão D-01:** embutir as fontes em `assets/fonts` em vez de baixar do Google em tempo de execução → specs/001-fundacao, concluído | `theme/app_typography`, `pubspec.yaml` |
| 0.3 | Breakpoints e largura máxima de conteúdo (~1120px) → specs/001-fundacao, concluído | `core/utils/screen/screen_utils.dart` |
| 0.4 | Botões: primário, secundário e discreto, com foco visível e estado desativado → specs/002-botoes-navbar-rodape, concluído | `core/components/buttons/*` |
| 0.5 | Navbar: fixa, item ativo sublinhado, dropdown com links externos separados, menu de celular → specs/002-botoes-navbar-rodape, concluído | `core/components/navbar/*`, `navbar_mobile_menu.dart` |
| 0.6 | Rodapé escuro em colunas, com redes sociais, contatos clicáveis e ano dinâmico → specs/002-botoes-navbar-rodape, concluído | `core/components/footer/footer.dart` |
| 0.7 | Cabeçalho `<title>` e descrição do `web/index.html`, tela de carregamento inicial → specs/003-index-carregamento, concluído | `web/index.html`, `web/manifest.json`, `tool/web_icons/` |

**Aceite:** todas as páginas existentes abrem sem erro com a navbar, o rodapé e os botões novos. Contraste de texto ≥ 4,5:1. Navegação completa por teclado na navbar.

### Fase 1: Home
Ordem sugerida das seções. Cada uma é entregue e revisada isoladamente.

| # | Seção | Notas técnicas | Depende de |
|---|---|---|---|
| 1.1 | Hero e atalhos → specs/004-hero-atalhos, concluído | Proposta de valor, dois botões, três atalhos (História, Geografia, Biblioteca) | 0.x |
| 1.2 | Destaques → specs/005-destaques, concluído | Três visíveis de uma vez (o primeiro em destaque). Tratar 0, 1, 2 e mais de 3 destaques. Degradê apenas sob o título. Sem carrossel automático | `FetchHighlightsStore` |
| 1.3 | Quem somos → specs/006-quem-somos-video, concluído | Missão e três públicos (professores, pesquisadores, estudantes). Substitui o bloco de tela cheia com foto | |
| 1.4 | Vídeo → specs/006-quem-somos-video, concluído | Capa com botão de reproduzir. Sem autoplay | `AppVideoPlayer` |
| 1.5 | Nossa história (resumo) → specs/007-resumo-nossa-historia, concluído | Resumo com o marco da FAPEMIG e link para a página completa | T-03 (rota nova) |
| 1.6 | Equipe → specs/008-equipe, concluído | Grade com todos os membros. Só é clicável quando há descrição | `FetchTeamStore`, T-02 |
| 1.7 | Realização e apoio → specs/009-apoio-contato | Logos reais com efeito de hover (P-03) | P-03 |
| 1.8 | Chamada para contato → specs/009-apoio-contato | Bloco de chamada para `/contato` | |

**Aceite:** a Home reproduz o protótipo em 390px, 768px e 1280px. Sem rolagem horizontal. Estados de carregamento (esqueleto) e de erro tratados. Sem `overflow` no console.

### Fases seguintes (ordem sugerida, ajustável)
| Fase | Escopo | Motivo da posição |
|---|---|---|
| 2 | Leitura: layout-base do post (artigo primeiro), Manifesto, Nossa história, Pessoa da equipe | Compartilham o mesmo layout de leitura |
| 3 | Listagem de categoria e cards de post | Maior volume de navegação |
| 4 | Biblioteca (índice, lista, detalhe, filtros) | Categorias e filtros já definidos |
| 5 | Acabamento: Fale com a gente, Colabore, 404/erros e demais tipos de post | Antes ficava na fase 6 |
| 6 | Reservada | Sem escopo definido |
| 7 | Limpeza: remover tokens antigos, `num_extension` e assets sem uso | Só quando nada mais usar |

---

## 5. Vídeo de apresentação
O vídeo é um arquivo MP4 no Firebase Storage e não tem capa. Proposta: extrair um quadro do próprio vídeo para servir de capa (`assets/images/video-capa.webp`), escolhido por você. Enquanto isso, o protótipo usa uma capa de exemplo.

---

## 6. Perguntas e respostas

### Respondidas
| ID | Resposta |
|---|---|
| Q-02 | Seleção livre de quantas categorias o usuário quiser (como hoje). Sem "Todas" e sem agrupar |
| Q-03 | Ambos: as categorias permanecem como estão, no menu e na biblioteca |
| Q-04 | O formulário continua abrindo o programa de e-mail com os dados preenchidos |
| Q-05 | Não existe logo em SVG nem capa do vídeo. O logo do protótipo é aprovado como marca. Ver decisões e seção 5 |
| Q-06 | A mesma lista de 9 parceiros na Home e no post |
| Q-08 | "Copiar citação" no documento da biblioteca: retirado do escopo, registrado como ideia futura |
| D-01 | Fontes embutidas nos assets. Bricolage Grotesque é a família correta |

### Em aberto
Nenhuma no momento.

---

## 7. Fora do escopo
- Portal administrativo (login e painel).
- Seção Geoensine.
- Modo escuro.
- Alteração de conteúdo ou de modelos de dados.

---

## 8. Riscos e cuidados
- **Fonte em tempo de execução:** a fonte baixada do Google pode causar troca visível de estilo no carregamento. Por isso a decisão D-01 (embutir). Detalhe técnico: o Google Fonts entrega a Bricolage como fonte variável. No Flutter, o mais seguro é gerar arquivos estáticos dos pesos usados (600, 700 e 800) e declará-los em `pubspec.yaml`.
- **Remoção de `num_extension`:** ela afeta o tamanho de textos e espaçamentos de praticamente todas as telas. Só sai na Fase 7, depois de todas migradas.
- **Imagens sem padrão:** qualquer componente com imagem precisa ser testado com imagens muito altas, muito largas, ausentes e com falha de carregamento.
- **Regressões visuais:** como as telas migram gradualmente, conferir a navegação entre uma tela nova e uma antiga a cada fase.

---

## 9. Ideias futuras (fora do escopo atual)

### 9.1 Busca geral do site
Uma lupa na navbar (atalho `/`) abriria um painel com resultados agrupados em **Publicações** e **Biblioteca**, com navegação por teclado. Enter levaria a uma página de resultados filtrável por grupo. O desenho está no protótipo (aba "Busca (ideia)").

**Situação atual:** posts têm busca por prefixo do título dentro de uma categoria (`body.title_lower`). A biblioteca tem filtros por título, autor e instituição, também por prefixo, sensíveis a maiúsculas e sem tratamento de acentos. Não existe busca que atravesse os dois.

**Motor (decisão adiada):**

| Opção | Como funciona | Limites |
|---|---|---|
| A. Firestore por prefixo | Consulta `collectionGroup` em posts e a coleção `library` | Só prefixo do título, sem acentos e sem várias palavras |
| B. Índice leve no cliente | Ao abrir a busca, carrega uma lista enxuta dos itens publicados e pesquisa no navegador, ignorando acentos e caixa e aceitando várias palavras | Vale enquanto o total for de centenas a poucos milhares de itens |
| C. Serviço de busca (Typesense, Algolia) | Índice externo sincronizado com o Firestore | Custo e operação extras |

Para decidir será preciso saber quantos posts e documentos existem hoje. Melhorar a busca da biblioteca (campos normalizados como `title_lower`) é ajuste do painel administrativo.

### 9.2 Copiar citação no documento da biblioteca
Um botão que copia a referência bibliográfica pronta do documento, para colar num trabalho. Exemplo: "SOBRENOME, Nome. Título. 2024. Dissertação – UFU." Seria útil para pesquisadores e estudantes, mas o formato da citação (ABNT) precisaria ser validado.

### 9.3 Envio de e-mail pelo próprio site
Hoje o formulário abre o programa de e-mail do visitante. Enviar direto pelo site exigiria um serviço (extensão "Trigger Email" do Firebase, Cloud Function ou serviço de formulário), proteção contra spam e, provavelmente, o plano Blaze do Firebase.
