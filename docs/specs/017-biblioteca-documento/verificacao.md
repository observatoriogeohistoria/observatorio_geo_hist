# Verificação da 017. Biblioteca: detalhe do documento

- **Data:** 2026-10-02
- **Resultado:** aprovada com ressalvas (painel não conferido no app; 4 documentos de prod com arquivo JPEG caem no erro do visualizador)

Revisão do código de `c7f368b..9594082` (commits `5ea4d9f`, `b8fceb2`, `9594082`) e do app real: build `APP_ENV=prod` só leitura servido localmente num Chrome sem janela controlado por CDP, e `flutter run -d web-server` em debug com `APP_ENV=prod`, com falhas injetadas numa cópia não commitada. Nada foi escrito no banco.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas, antes e depois das correções |
| Conferência de formato do `CLAUDE.md` (cópia ASCII) | 0 arquivos a formatar |
| `fvm flutter build web --release --dart-define=APP_ENV=prod` | concluído sem erro |
| `flutter run -d web-server` (debug) em 390, 768 e 1280 | detalhe com PDF real, erro do visualizador, "Tentar de novo" e PDF de 1 página sem exceção, `overflow` nem asserção |
| Busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector`, rota solta e menção a spec/protótipo no código novo | nenhuma ocorrência |
| `git diff c7f368b..HEAD` em `library_store.dart`, `library_list_page.dart`, `library_document_card.dart`, `filters.dart`, diálogo, `filter_documents_store.dart` e `fetchDocumentBySlug` | sem diff |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Estrutura da página, coluna de 920 px, sem "Voltar", data e "Baixar" | passou | tela em 1280 (coluna de 212 a 1068 px), 768 e 390; migalhas "Início › Biblioteca › Geografia › Documento" com links |
| 2 | Ficha, campos vazios omitidos, categorias, selo | passou | tela; `library_document_header.dart` filtra valores vazios e omite o selo sem tipo |
| 3 | "Abrir documento" em outra aba, por clique e Enter | passou | clique e Enter chamam `window.open` (`noopener`) e o Chrome cria uma aba nova (`Target.targetCreated`; sem janela, o PDF é baixado e a aba fecha); nome "Abrir documento em outra aba"; foco visível; some sem arquivo (`url.isNotEmpty`) |
| 4 | Barra, botões nas pontas, página inteira até 560 px, troca por clique e teclado, anunciada | passou | "Página 1 de 145" → "Página 2 de 145" por clique e Enter, com anúncio; PDF de 1 página (injetado) com os dois botões desativados; página de 560 px na proporção dela; troca sem animação |
| 5 | Estados do visualizador | passou | folha "Carregando documento…"; falha injetada mostra o erro e "Tentar de novo" baixa de novo e exibe a página; ficha e botão continuam; sem arquivo, `_open` não roda (nenhuma requisição) |
| 6 | Esqueleto da página | passou | `LibraryDocumentSkeleton` (parado, rótulo "Carregando"); exibido na implementação por injeção |
| 7 | Erro na página com "Tentar de novo" | passou | `StateErrorBox(onRetry: _store.retry)`; repositório converte exceção em `FetchLibraryFailure`; exibido na implementação por injeção |
| 8 | 404 para área inválida e endereço sem documento | passou | `/biblioteca/xyz/documento/a` e `/biblioteca/geografia/documento/nao-existe-xyz` |
| 9 | Endereço por slug ou identificador | passou | os 12 documentos com resumo no slug abrem pelo id; a lista de Geografia gera `/documento/{id}` para eles e o clique na linha abre o detalhe; slug comum segue no endereço |
| 10 | Área trocada na URL | passou | slug de Geografia em `/biblioteca/historia/...` mostra o documento com "Geografia" nas migalhas |
| 11 | Painel sem mudança | passou no código | arquivos do painel sem diff; no app, não conferido (sem credenciais) |
| 12 | Contraste, Tab, pares, região, página anunciada | passou após correção | `inkSecondary` com 7,0:1 no branco e 6,5:1 na superfície; Tab: migalhas → "Abrir documento" → "Próxima página" (anterior desativado); pares "Autor, …" e região "Visualizador do documento" na árvore; a página não tinha nome (ver problemas) |
| 13 | 390, 768 e 1280, release e debug | passou | sem rolagem horizontal (`scrollWidth` igual à janela), ficha em 1, 3 e 4 colunas, botão na largura toda no celular, rodapé na base no erro |
| 14 | Tokens, sem `num_extension`/`GestureDetector`, `AppRoutes`, sem pacote novo, analyze e build | passou | busca no código novo; `pubspec.yaml` sem diff |

## Problemas encontrados
- **Cantos do visualizador sem borda** (ajuste, corrigido): o fundo branco da barra cobria a curva da borda nos cantos de cima. A borda passou para a `foregroundDecoration`, como no protótipo (`.viewer` com borda e `overflow:hidden`).
- **Página do PDF sem nome para leitor de tela** (ajuste, corrigido): o `Semantics` em volta do `Image.memory` não chegava ao nó da imagem (`role="img"` sem `aria-label`). Agora vai pelo `semanticLabel` da imagem: "Página 2 de 145 do documento".
- **Arquivos JPEG em prod** (detalhe, fora do escopo): 4 dos 602 documentos têm um JPEG no lugar do PDF; o visualizador mostra "Não foi possível exibir o documento", como a spec manda, e "Abrir documento" abre o arquivo. Corrigir é ajuste de dados.

## Divergências registradas na implementação
- Visualizador desenhado direto com o `pdfx` (`PdfPage.render`), sem o `PdfView`, que traz zoom e animação.
- Sem a barra nos estados de erro e sem arquivo; sem arquivo, o aviso também fica sem a moldura.
- Ícone de link externo à direita do texto, como no botão "Currículo Lattes".
- `AppButtonBase`/`PrimaryButton` ganharam `expand` (padrão `false`): com `false`, `fit` e `widthFactor` ficam como antes; o "Explorar a biblioteca" da home segue igual, e a lista da área (016) também, em 390 e 1280.

## Não conferido
- Painel administrativo no app (sem credenciais de teste); o código do painel não tem diff.
- Esqueleto, erro da página, sem arquivo e muitas categorias foram vistos pela implementação (injeção); nesta verificação, só pelo código.
