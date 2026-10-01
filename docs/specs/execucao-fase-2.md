# Execução da Fase 2

- **Início:** 2026-10-01
- **Branch:** refactor/redesign-fase-2 → PR para develop

| Spec | Itens | Spec+plano | Implementação | Verificação | Resultado |
|---|---|---|---|---|---|
| 010-leitura-manifesto | layout de leitura, T-01 | feita (14 critérios, 11 tarefas) | feita (2 commits) | feita (1 fix) | verificada (5 commits) |
| 011-nossa-historia-pessoa | T-03, T-02 | feita (17 critérios, 12 tarefas) | feita (4 commits) | feita (1 fix) | verificada com ressalvas (7 commits) |
| 012-post-base | T-08 (artigo), P-05, P-07, P-08 | feita (18 critérios, 18 tarefas) | feita (4 commits) | feita (1 fix) | verificada com ressalvas (7 commits) |
| 013-compartilhamento-post | P-06 | feita (12 critérios, 12 tarefas) | pendente | pendente | |

## Divisão
- 010 cria o layout de leitura compartilhado (cabeçalho de página e coluna de texto) e o aplica no Manifesto, a página mais simples.
- 011 junta Nossa história e Pessoa da equipe: duas páginas curtas que reaproveitam o layout da 010.
- 012 é o layout-base do post com o tipo artigo; os demais tipos ficam para a Fase 5.
- 013 separa o compartilhamento (P-06) do layout do post, por ser entrega isolada e depender da 012.

## Decisões tomadas sem a pessoa
- 010: texto do Manifesto com a revisão do protótipo (abertura, lista, destaque e pequenas correções, sem apagar frases); migalhas no cabeçalho de página; base de leitura só com os blocos do Manifesto (subtítulo e lista com marcadores na 011); Nossa história provisória não migra na 010. Detalhes em [010/spec.md](010-leitura-manifesto/spec.md).
- 011: texto de Nossa história atual palavra por palavra na estrutura do protótipo (sem a reescrita dele); foto `our-history.webp` em 21:9 com recorte para cima; sem o botão "← Equipe"; "Equipe" nas migalhas vai para a Home; pessoa não encontrada usa a 404 atual; laço de leituras já resolvido no código, mantido como critério. Detalhes em [011/spec.md](011-nossa-historia-pessoa/spec.md).

- 012: só o artigo no layout-base; os outros 9 tipos mantêm o conteúdo atual dentro da página nova (estados e Apoio novos); migalhas "Início › Área › Categoria › Artigo" com a área sem link; sem botão de voltar e sem barra de progresso; compartilhar atual (4 opções) no lugar do protótipo, só acessível; data "março de 2026"; Leia também com até 3 artigos da categoria, escondido se vazio; imagens do texto sem recorte; post não publicado → 404. Detalhes em [012/spec.md](012-post-base/spec.md).
- 013: outros 9 tipos seguem sem compartilhar (hoje não têm) até a Fase 5, que reaproveita o componente único `PostShare`; celular com "Compartilhar" nativo (se o navegador oferecer), "Copiar link", WhatsApp e "Mais" (linha que se abre); nativo só abaixo de 600 px; confirmação "Link copiado" no próprio botão e anunciada; Twitter vira X; ícones SVG de traço do protótipo; nenhum pacote novo (`package:web` e `Clipboard` do Flutter). Detalhes em [013/spec.md](013-compartilhamento-post/spec.md).

## Ressalvas
- 010: a seta do `PrimaryButton` (spec 002) não cresce com o texto a 200%; não quebra o layout. Anotada para quando o botão for revisto.
- 011: offline, o Firestore responde do cache vazio e a pessoa cai na 404 em vez da caixa de erro (comportamento anterior; mudar exige mexer no datasource). Membro sem descrição e botão Lattes só conferidos com dados injetados (não há no banco de dev).
- 012: links dentro do texto e da nota do artigo abrem pelo mouse, mas não recebem foco por teclado (limite do Quill só leitura; a alternativa reescreve o `ReadingRichText`). Erro com rede bloqueada e post não publicado conferidos só com falha injetada e pelo código.

## Ocorrências
- 010: na verificação, as migalhas saíam como grupo; passaram a `navigation` "Você está em" (`fix:` próprio). Texto a 200% conferido ampliando a fonte raiz do documento, que o Flutter web respeita.
- 011: na verificação, com a página rolada as migalhas recebiam foco escondidas sob a navbar fixa (e vinham antes da navbar no Tab). Corrigido no `ReadingPageScaffold` (`fix:` próprio): navbar primeiro na ordem e item focado rolado para aparecer. Vale também para o Manifesto.
- 012: o Firebase dev só tem um post (pesquisa); artigos e os demais tipos foram conferidos em build `APP_ENV=prod` só leitura. Capa ausente, capa com falha e delta de teste, em build temporário com dados injetados (não commitado). Na implementação, a página alternava sem parar entre esqueleto e 404 com categoria inexistente (corrigido; confirmado na verificação, sem leituras repetidas). Na verificação, o texto e a nota viravam paradas de Tab invisíveis (`fix:` próprio).
