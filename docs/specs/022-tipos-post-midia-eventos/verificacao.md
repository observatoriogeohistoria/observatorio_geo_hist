# Verificação da 022. Tipos de post: podcast, música, evento e pesquisa

- **Data:** 2026-10-06
- **Resultado:** aprovada com ressalvas (não conferidos: leitor de tela de verdade e painel)

Revisão do código de `94f63c5`, `193f07f`, `668408b`, `7772b4d` e `66ff258` e do app num Chrome headless por CDP: build release `APP_ENV=prod` só leitura com dados injetados no datasource só para ids `fake-*`, numa cópia fora do repositório (os posts reais passam pelo caminho sem mudança), e `flutter run -d web-server` (debug) na mesma cópia. Nada criado ou alterado no painel nem no Firestore.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas em `lib/`, antes e depois da correção |
| Conferência de formato do `CLAUDE.md` | 0 arquivos a formatar |
| `fvm flutter build web --release --dart-define=APP_ENV=prod` | concluído sem erro |
| `flutter run -d web-server` (debug) em 390, 768 e 1280 | podcast, música, evento e pesquisa reais, livro, música com título longo, pesquisa com integrantes longos e evento em intervalo injetados: sem `overflow`, exceção nem asserção no console |
| `eventDayOf` num `dart run` descartável: 40 formatos escritos à mão e 300 mil textos aleatórios (dígitos, barras, ordinais, meses, acentos, emoji, espaço inseparável, caracteres de controle) | nenhuma exceção; entradas patológicas de 5 mil itens em 1 ms; `null` em "2026-11-14", "14 de nov", "de 5 a 7 de agosto", "Sexta, 14 de novembro", "00/00", "30/02", números gigantes |
| `grep` por `SocialIcons`, `ViewQuill`, `ArticleContent`, `PodcastContent`, `MusicContent`, `EventContent`, `SearchContent` e `post_content/` em `lib/` e nos docs de arquitetura | nenhuma referência |
| `git diff 94f63c5~1..HEAD` em modelos, rotas, `pubspec.yaml`, regras do Firebase e `features/admin` | sem diff |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Estrutura e ordem | passou | podcast "Bê-á-bá Biomas", música "Palmares", evento "I Encontro Nacional do Coletivo…" e pesquisa "Observatório do Ensino…" reais: navbar, migalhas "Início › Geografia › categoria › tipo", bloco, compartilhar (na pesquisa, seguido da figura), texto, Apoio e rodapé; sem Leia também |
| 2 | Título e ficha | passou | `h1` em tinta, como cadastrado; "Artista"; "Data", "Local", "Cidade", "Abrangência" (sem "Horário" vazio); pesquisa com "Financiamento" e Integrantes na largura toda; integrantes injetados em 12 linhas mantêm as quebras; pesquisa só com descrição sem ficha |
| 3 | Capa quadrada | passou | 180 px 1:1 com `cover`, ao lado dos dados em 768/1280 e acima, à esquerda, em 390; placeholder sem imagem e com URL quebrada |
| 4 | Faixa "Ouvir" | passou | botão redondo, "open.spotify.com"/"youtu.be" sem "www.", ícone externo; clique e Tab+Enter abrem o link do Spotify (`window.open`) com foco visível; some sem link; "open.spotify.com/…" sem esquema e "ht!tp://x" só com o texto. O clique com endereço que não passa no `Uri.parse` lançava exceção (ver Problemas), corrigido |
| 5 | Descrição e letra | passou | "Descrição" e "Letra" como `h2`, letra em parágrafos por linha; letra vazia sem subtítulo; letra não-delta como texto simples |
| 6 | Caixa de data | passou | "15, 16 e 17 de julho de 2026." → 15 JUL; injetados "14/11/2026" → 14 NOV, intervalo "1º de janeiro…" → 1 JAN; "32/13/2020" e "A definir" sem caixa; "Data" sempre na ficha; as 7 datas de prod dão caixa no `eventDayOf` (inclusive "13/05/2026 a 16/05/2026", "19/07 a 24/07 de 2026", "30 de setembro, 1, 2 e 3 de outubro") |
| 7 | "Mais informações" e "Detalhes" | passou | Tab+Enter e clique abrem o link do even3 em outra aba (390); some sem link; "Detalhes" com parágrafos e sem subtítulo quando vazio |
| 8 | Pesquisa | passou | "Em andamento" verde e "Concluída" neutra; com título longo, a pílula desce de linha; figura 21:9 com "Pixabay" abaixo do compartilhar; sem imagem, sem figura; quebrada, placeholder; sem botão |
| 9 | Compartilhar | passou | o mesmo `PostShare` do artigo (fileira do celular, ícones e "Copiar link" em 768/1280) |
| 10 | Esqueleto, 404 e erro | passou | id inexistente: 404 da 020; erro injetado: "Não foi possível carregar" com "Tentar de novo" |
| 11 | Acessibilidade | passou com ressalva | árvore semântica: `h1`, `h2`, "Capa de Palmares", imagem da pesquisa com a legenda como nome, "Ouvir Palmares em outra aba", "Mais informações em outra aba", caixa de data fora da árvore, ficha em pares ("Artista, Natiruts"), pílula logo depois do título; Tab: navbar → migalhas → faixa/botão → compartilhar. Contraste: branco no laranja 4,87:1, pílula verde 5,71:1, texto secundário na superfície 6,45:1. Leitor de tela de verdade não conferido |
| 12 | Responsivo e debug | passou | 390, 768 e 1280 com `scrollWidth` igual à janela nos quatro tipos reais e em 12 casos injetados; títulos, nomes e integrantes longos quebram linha; debug sem `overflow` nem asserção |
| 13 | Outros tipos, Home e biblioteca | passou | artigo, livro, filme, revista, documento e produção acadêmica reais em 390, 768 e 1280 iguais ao desenho da 021 (ficha, palavras-chave, botões), sem erro no console; Home e lista da biblioteca sem mudança |
| 14 | Código, limpeza, docs, analyze e build | passou | só tokens do tema; sem `num_extension`, `GestureDetector` ou `AppNetworkImage` nos arquivos novos; `post_content/`, `SocialIcons` e `ViewQuill` apagados sem referência (o único `*_content.dart` é o despachante `post_type_content.dart`); `docs/arquitetura.md` atualizado; nada fora do escopo alterado |

## Problemas encontrados
- **Link malformado lançava exceção** (ajuste, corrigido): `openUrl` chamava `Uri.parse` fora do `try`, então a faixa "Ouvir" ou "Mais informações" com um link como "ht!tp://x" ou com porta inválida gerava "Uncaught" no console ao clicar. O `Uri.parse` foi para dentro do `try`. Conferido num build com o código anterior (exceção no clique) e depois da correção (nada no console, nada abre).

## Não conferido
- Anúncio por leitor de tela de verdade (árvore semântica conferida).
- Painel: sem diff e sem credenciais de teste.
