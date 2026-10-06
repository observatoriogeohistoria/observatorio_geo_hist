# Verificação da 021. Tipos de post: livro, filme, revista, documento e produção acadêmica

- **Data:** 2026-10-06
- **Resultado:** aprovada com ressalvas (não conferidos: leitor de tela de verdade e painel)

Revisão do código de `fd293ca`, `18aa574` e `b980e7c` e do app real num Chrome headless por CDP: build release `APP_ENV=prod` só leitura (livro, filme, revista, documento e produção acadêmica reais; artigo, podcast, música, evento e pesquisa; lista e detalhe da biblioteca; vídeo da Home), um build temporário com dados injetados no datasource fora do repositório (casos de borda, erro e 404) e `flutter run -d web-server` (debug). Nada criado ou alterado no painel nem no Firestore.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas, antes e depois da correção |
| Conferência de formato do `CLAUDE.md` | 0 arquivos a formatar |
| `fvm flutter build web --release --dart-define=APP_ENV=prod` | concluído sem erro |
| `flutter run -d web-server` (debug) em 390, 768 e 1280 | livro, filme, revista, documento e produção acadêmica sem `overflow`, exceção nem asserção no console |
| Busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector`, `AppNetworkImage` e nomes antigos (`library*`, `VideoPlayButton`, `*_content.dart` apagados) | nenhuma ocorrência nos arquivos novos e alterados |
| `git diff fd293ca~1..HEAD` em modelos, rotas, `pubspec.yaml`, regras do Firebase e `features/admin` | sem diff |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Estrutura e ordem da página | passou | os cinco tipos: navbar, migalhas "Início › Geografia/História › categoria › tipo", bloco, compartilhar, texto, Apoio e rodapé; sem Leia também |
| 2 | Selo, `h1` e chamada | passou | selo com a categoria ("Ebook", "Documento Normativo", "Tese", "Curta Metragem"); `h1` em tinta, como cadastrado; chamada da revista "Terra Livre" abaixo do título; revista sem chamada (injetada) sem espaço sobrando |
| 3 | Ficha por tipo | passou | rótulos da tabela; ano 0 e campos vazios omitidos (livro e filme injetados); revista e documento sem ficha |
| 4 | Palavras-chave | passou | produção real com ";" e ponto final vira três etiquetas; injetada com vírgulas sobrando e termo longo: sem etiqueta vazia, termo longo quebra dentro da etiqueta |
| 5 | Ação principal e "Assistir" | passou | Tab até o botão e Enter abre o link certo em outra aba (`window.open`) em livro, revista, documento, produção acadêmica e no "Assistir" do filme (1280 e 390); clique também; sem link, botão e "Assistir" somem |
| 6 | Capa 2:3 e cartaz 16:9 | passou | capa de 180 px com sombra e cantos 6/12; cartaz em duas colunas no tablet e no desktop e na largura toda no celular; documento e produção sem imagem |
| 7 | Placeholder | passou | imagem vazia e URL quebrada (injetadas): placeholder laranja na mesma proporção; "Assistir" continua sobre o cartaz |
| 8 | Texto | passou | "Sinopse", "Descrição" e "Resumo" como `h2`; sinopse de filme não-delta mostrada como texto simples; várias linhas viram parágrafos, linhas em branco não somam; texto vazio sem subtítulo |
| 9 | Compartilhar | passou | o mesmo `PostShare` do artigo (fileira do celular com "Compartilhar pelo aparelho"; ícones e "Copiar link" no tablet e desktop), com foco visível |
| 10 | Esqueleto, 404 e erro | passou | id inexistente: 404 da 020; erro injetado: caixa "Não foi possível carregar" com "Tentar de novo" |
| 11 | Acessibilidade | passou com ressalva | `h1`/`h2`, "Capa de …"/"Cartaz de …", ficha em pares ("Direção, Christopher Nolan"), "Palavras-chave, …", "… em outra aba"; Tab: navbar → migalhas → ação → compartilhar; contraste: `inkSecondary` 7,0:1 no branco e 6,5:1 na superfície, branco no botão 4,9:1, tinta na pílula 17:1. A ordem de leitura ao lado da capa estava trocada (ver Problemas) e foi corrigida. Leitor de tela de verdade não conferido |
| 12 | Responsivo e debug | passou | 390, 768 e 1280 com `scrollWidth` igual à janela; título, nomes, selo e migalhas longos quebram linha; debug sem `overflow` |
| 13 | Outros tipos e artigo | passou | artigo, podcast, música, evento e pesquisa reais abrem sem erro no console |
| 14 | Biblioteca e Home | passou | lista da biblioteca (selo, etiquetas) e detalhe (selo, `h1`, ficha com "Categorias", "Abrir documento") iguais em 390 e 1280; vídeo da Home com "Reproduzir vídeo de apresentação", que abre o player |
| 15 | Tokens, limpeza, docs, analyze e build | passou | só tokens do tema; cinco `*_content.dart` apagados sem referência; `docs/arquitetura.md` atualizado; analyze e build sem erro; nada fora do escopo alterado |

## Problemas encontrados
- **Ordem de leitura ao lado da capa** (ajuste, corrigido em `d0d88af`): no tablet e no desktop, a árvore semântica da revista lia "Acessar revista em outra aba" antes da chamada, porque o Flutter ordenava os dados junto com a capa pela posição na tela. Os dados da obra agora são um contêiner semântico (`explicitChildNodes`, para não fundir título e chamada num só nó, o que a primeira tentativa fez). Conferido de novo nos cinco tipos em 390 e 1280: selo, título, chamada, ficha e botão na ordem da coluna; Tab e Enter sem mudança.

## Não conferido
- Anúncio por leitor de tela de verdade (árvore semântica conferida).
- Painel: sem diff e sem credenciais de teste.
