# Verificação da 019. Colabore

- **Data:** 2026-10-05
- **Resultado:** aprovada com ressalvas (não conferidos no app: categoria sem "Colabore com esta categoria", leitor de tela de verdade, sugestão de autopreenchimento e painel)

Revisão do código de `f3e5992` e `f840017` e do app real: build release servido localmente e `flutter run -d web-server` (debug), num Chrome headless controlado por CDP (o navegador embutido não repassava a digitação aos campos do Flutter), com `window.open` e `navigator.clipboard.writeText` interceptados.

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | sem problemas |
| Conferência de formato do `CLAUDE.md` | 0 arquivos a formatar |
| `fvm flutter build web --release` | concluído sem erro |
| `flutter run -d web-server` (debug) em 390, 768 e 1280 | vazio, com erros, com textos longos e confirmação, sem `overflow`, exceção nem asserção no log ou no console (só o erro conhecido do `client.js` do webdev) |
| Busca por cor, fonte e espaço soltos, `num_extension`, `GestureDetector`, rota solta e comentário fora das regras no código novo | nenhuma ocorrência |
| `git diff 0746da5..HEAD --stat` | só `mail_aside_card.dart`, `contact_info_card.dart`, `collaborate_guide_card.dart`, `collaborate_page.dart` e docs; rotas, `posts_page.dart`, modelos, formulário compartilhado, painel e `pubspec.yaml` sem diff |

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Estrutura da página | passou | 390, 768 e 1280: migalhas "Você está em" com "Início" (link) e "Colabore, página atual", `h1` "Colabore", lead da spec, formulário, "Antes de enviar", "Realização e apoio" e rodapé; sem foto, "COLABORE" ou botão com o e-mail |
| 2 | Campos, botão, apoio, autofill, Enter | passou | cinco rótulos acima; botão com envelope; texto sobre anexos com **Enviar** em negrito; `autofillHints` nome, e-mail e organização (`collaborate_page.dart`); Enter é o do `MailForm` da 018 (próximo campo; quebra de linha em "Sobre a contribuição", conferida no app) |
| 3 | Validação | passou | envio vazio: quatro erros com as mensagens da tabela em `aria-description`, `aria-invalid="false"` em Instituição, foco em Nome completo, nenhum `mailto:`; erros somem ao preencher |
| 4 | Abertura do e-mail | passou | `window.open(..., '_self')`: `mailto:contato@…?subject=Colabora%C3%A7%C3%A3o%3A%20Mapas%20%26%20rios%3F%20%231%20100%25&body=Relato%20%C3%A7%C3%A3o%20%F0%9F%98%80%0Alinha%202%0A%0AAna%20J%C3%BAlia%0Aana%40ex.com`; nome aparado; Instituição só com espaços some; com "UFU" entra entre nome e e-mail; título "Colaboração: Mapas" vira "Colaboração: Colaboração: Mapas" |
| 5 | Confirmação | passou | substitui o formulário com "Seu e-mail está pronto", o texto sobre anexos, link `mailto:` e os dois botões; foco no título; texto copiado "Para / Assunto / corpo" com a assinatura; "Voltar" mantém os campos, foco em Nome completo, e novo envio abre o `mailto:` |
| 6 | Antes de enviar | passou | `h2` e os seis itens com os textos da spec; link "Conheça as licenças Creative Commons, abre em outra aba" para `https://br.creativecommons.net/licencas/` e `mailto:` no E-mail; anel de foco visível nos dois |
| 7 | Conteúdo atual preservado | passou | o que enviar, tipos e formatos, obras de terceiros, avaliação, licença e link estão na caixa; a identificação (nome completo, e-mail, instituição) virou os campos |
| 8 | Acessibilidade | passou | Tab: Sobre a contribuição → "Abrir no meu e-mail" → licenças → e-mail, com anel visível; campos com rótulo, "(opcional)" e erro; mesmos tokens de cor da 018 (texto secundário 6,5:1, links `accentStrong` 6,3:1 na superfície); troca sem animação |
| 9 | Responsivo, release e debug | passou | 390: uma coluna, botão na largura toda; 768: uma coluna, botão no tamanho do texto; 1280: 3/5 e 2/5 alinhados no topo; `scrollWidth` igual à janela em todos os estados; textos longos rolam nas linhas simples e quebram na descrição; rodapé na base |
| 10 | Botão da categoria | passou com ressalva | "Teste" (História e Geografia) tem a opção e o botão leva a `/colaborar`; o ambiente não tem categoria sem a opção (`posts_page.dart` sem diff) |
| 11 | Contato, rota, modelo e painel | passou | `/contato` em 390 e 1280 igual ao da 018 ("Outros meios" com e-mail, dois telefones e endereço, `h2`); envio abre o mesmo `mailto:`; rota, modelo e painel sem diff (painel não aberto) |
| 12 | Tokens, analyze e build | passou | só tokens de `AppTheme`; sem `num_extension`, `GestureDetector` nem rota solta; nenhum pacote novo; analyze e build sem erro |

## Problemas encontrados
- Nenhum que peça correção.
- Detalhe, sem mudança: Colabore e Fale com a gente repetem o mesmo arranjo de duas colunas. Só vale extrair se surgir um terceiro formulário.

## Não conferido
- Categoria sem `hasCollaborateOption`: o ambiente de testes não tem nenhuma.
- Anúncio por leitor de tela de verdade e a sugestão de autopreenchimento do navegador (atributos conferidos, comportamento não).
- Painel: sem credenciais de teste; sem diff.
