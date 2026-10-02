# 013. Compartilhamento ampliado do post

- **Status:** verificada com ressalvas
- **Item do planejamento:** Fase 2: P-06
- **Protótipo:** aba "Post", linha de autoria (botões "Desktop" e "Celular") (link no CLAUDE.md)
- **Criada em:** 2026-10-01
- **Depende de:** [012-post-base](../012-post-base/spec.md) (linha de autoria do artigo, onde o compartilhar fica)

## Objetivo
Quem lê um artigo consegue copiar o link ou enviá-lo por WhatsApp, Facebook, X, LinkedIn, Telegram ou e-mail e, no celular, usar a folha de compartilhamento do próprio aparelho, sem que as opções ocupem a linha inteira em tela estreita.

## Situação atual
- [social_icons.dart](../../../lib/app/features/posts/presentation/components/social_icons.dart) (`SocialIcons`), na linha de autoria do artigo ([article_header.dart](../../../lib/app/features/posts/presentation/components/post/article_header.dart)): quatro ícones PNG (Facebook, Twitter, WhatsApp, E-mail) de 38 px, com nome acessível, dica e foco visível (desde a 012). Os links codificam o título e o e-mail leva o título no assunto ([app_strings.dart](../../../lib/app/core/utils/constants/app_strings.dart)). O compartilhado é o endereço atual da página.
- O ícone e o nome ainda são "Twitter"; o destino já é `x.com`.
- Não há copiar link, LinkedIn, Telegram nem compartilhamento nativo.
- Os outros 9 tipos de post (blocos antigos, até a Fase 5) **não têm** compartilhar. O `ArticleContent` antigo ainda usa `SocialIcons`, mas não é mais mostrado em nenhuma página.

## Comportamento

### Opções
| Opção | O que faz |
|---|---|
| Copiar link | Copia o endereço do post e confirma (ver abaixo) |
| WhatsApp | Abre `api.whatsapp.com/send` com título + link, em outra aba |
| Facebook | Abre o compartilhador do Facebook com o link, em outra aba |
| X | Abre `x.com/intent/post` com título e link, em outra aba |
| LinkedIn | Abre `linkedin.com/sharing/share-offsite` com o link, em outra aba |
| Telegram | Abre `t.me/share/url` com link e título, em outra aba |
| E-mail | Abre o programa de e-mail com o título no assunto e título + link no corpo, na mesma aba |
| Compartilhar (do aparelho) | Abre a folha de compartilhamento do sistema com título e link (só celular, só quando o navegador oferece) |

- O link compartilhado é o endereço atual do post (como hoje); o título vai codificado.
- Ícones no traço do protótipo (contorno), na cor secundária; ao passar o mouse, laranja escuro (`accentStrong`, para manter 4,5:1) sobre fundo laranja suave. Os PNGs antigos deixam de ser usados no artigo.

### Tablet e desktop (≥ 600 px)
Na linha de autoria, à direita do autor (abaixo dele se não couber): rótulo "COMPARTILHAR" (pequeno, caixa alta, cor secundária), os seis ícones na ordem WhatsApp, Facebook, X, LinkedIn, Telegram, E-mail, e o botão secundário pequeno "Copiar link" com ícone de corrente. Sem botão nativo.

### Celular (< 600 px)
Abaixo do autor, sem rótulo, numa linha que quebra se não couber (com o botão "Compartilhar", em 390 px, WhatsApp e "Mais" descem para uma segunda linha):
1. **"Compartilhar"** (botão secundário pequeno com ícone de compartilhar), só quando o navegador oferece compartilhamento nativo. Abre a folha do sistema. Se a pessoa cancelar, nada acontece; se falhar por outro motivo, as opções de "Mais" se abrem.
2. **"Copiar link"** (botão secundário pequeno).
3. **WhatsApp** (ícone), a rede mais usada no Brasil.
4. **"Mais"** (ícone de reticências, nome "Mais opções de compartilhar"): mostra ou esconde, logo abaixo, uma linha com Facebook, X, LinkedIn, Telegram e E-mail. Começa fechado. O botão informa se está aberto ou fechado; ao abrir, o foco fica no botão e o próximo Tab vai para a primeira opção revelada.

### Confirmação de "Copiar link"
- Sucesso: o texto do botão vira "Link copiado" com ícone de confirmação por cerca de 2 segundos e volta a "Copiar link". O leitor de tela anuncia "Link copiado". A largura do botão não faz a linha pular (reserva o espaço do texto maior).
- Falha (navegador bloqueou a área de transferência): o botão mostra "Erro ao copiar" pelo mesmo tempo e o leitor de tela anuncia "Não foi possível copiar o link". Cliques repetidos reiniciam a contagem, sem empilhar avisos.

### Outros 9 tipos
Continuam **sem** compartilhar nesta spec. O componente fica pronto para a Fase 5 colocá-lo no cabeçalho do layout-base de cada tipo (um só componente; ver "Perguntas em aberto").

## Estados
- **Carregando / erro / não encontrado:** o compartilhar só existe com o artigo carregado; não muda os estados da 012.
- **Sem título:** compartilha só o link (o texto e o assunto ficam vazios, como hoje).
- **Navegador sem compartilhamento nativo** (a maioria dos navegadores de computador e alguns de celular): o botão "Compartilhar" não aparece; o resto é igual.
- **Área de transferência indisponível:** mensagem de falha descrita acima.
- **Casos de borda:** linha de autoria com vários autores longos (o compartilhar quebra para baixo sem cortar); "Mais" aberto e a janela alargada para ≥ 600 px (passa ao layout largo, com todas as opções visíveis); título com acentos, aspas e "&" (chega certo no destino).

## Responsivo
- **Celular (390):** "Compartilhar" (se houver), "Copiar link", WhatsApp e "Mais" numa linha abaixo do autor; aberto, a linha de opções vem logo abaixo e quebra se precisar.
- **Tablet (768):** autor à esquerda, compartilhar à direita; se o autor ocupar demais, o compartilhar desce para baixo dele, alinhado à esquerda.
- **Desktop (1280):** autor à esquerda; rótulo, seis ícones e "Copiar link" à direita, numa linha.
- Em todas: sem rolagem horizontal, sem `overflow`.

## Acessibilidade
- Grupo com nome "Compartilhar". Cada ícone com nome ("Compartilhar no WhatsApp", "… no Facebook", "… no X", "… no LinkedIn", "… no Telegram", "Compartilhar por e-mail"), dica ao passar o mouse com o mesmo texto e foco visível. "Copiar link", "Compartilhar" e "Mais opções de compartilhar" também com dica.
- "Mais" se anuncia como botão que expande, com estado aberto/fechado.
- Confirmação da cópia anunciada pelo leitor de tela (não depende só da mudança visual).
- Ordem de Tab: migalhas → (Compartilhar) → Copiar link / ícones na ordem visual → Mais → opções reveladas → resto da página.
- Alvos de toque de pelo menos 38 px (tamanho atual) e ícones com contraste ≥ 4,5:1 (cor secundária) sobre o fundo; rótulo "COMPARTILHAR" ≥ 4,5:1.
- Movimento reduzido: sem animação ao abrir "Mais".

## Dados e regras de negócio
- Usa só o título do post e o endereço atual. Modelos, rotas, Firebase e painel não mudam.
- Nenhum pacote novo: área de transferência pelo próprio Flutter; compartilhamento nativo pela Web Share API com `package:web` e `dart:js_interop`, que já estão no projeto.

## Critérios de aceite
1. [ ] Em 768 e 1280, a linha de autoria mostra o rótulo "COMPARTILHAR", os seis ícones (WhatsApp, Facebook, X, LinkedIn, Telegram, E-mail) nessa ordem e o botão "Copiar link"; sem o botão nativo.
2. [ ] Cada rede abre o destino da tabela em outra aba, com o link do post e, onde cabe, o título codificado (conferido com título que tem acento, aspas e "&").
3. [ ] E-mail abre o programa de e-mail na mesma aba, com o título no assunto e título + link no corpo.
4. [ ] "Copiar link" coloca o endereço do post na área de transferência; o botão mostra "Link copiado" com ícone por cerca de 2 s e volta, sem a linha mudar de largura.
5. [ ] A confirmação "Link copiado" é anunciada ao leitor de tela; com a área de transferência bloqueada (falha injetada), o botão mostra "Erro ao copiar" e é anunciado "Não foi possível copiar o link".
6. [ ] Em 390, aparecem "Copiar link", WhatsApp e "Mais"; os outros cinco ficam escondidos até "Mais" ser acionado, e "Mais" os mostra e esconde por clique, Enter e Espaço, informando o estado aberto/fechado.
7. [ ] Em 390, num navegador com compartilhamento nativo, aparece "Compartilhar", que abre a folha do sistema com título e link; cancelar não muda nada; sem suporte (ou em ≥ 600 px), o botão não aparece.
8. [ ] Toda opção tem nome acessível conforme "Acessibilidade", dica ao passar o mouse e foco visível; a ordem de Tab segue a ordem visual, incluindo as opções reveladas por "Mais".
9. [ ] Ícones e rótulo com contraste ≥ 4,5:1; hover em laranja sobre laranja suave; o artigo não usa mais os PNGs antigos nem o nome "Twitter".
10. [ ] Em 390, 768 e 1280 px: sem rolagem horizontal, sem sobreposição e sem `overflow`, inclusive com "Mais" aberto e com vários autores de nome longo.
11. [ ] Os outros 9 tipos continuam abrindo como na 012 (sem compartilhar, sem erro no console).
12. [ ] O código novo usa só tokens de `lib/app/theme/`, não usa `num_extension` nem pacote novo; o compartilhar é um componente único, pronto para o layout-base da Fase 5; `fvm flutter analyze` sem problemas novos e `fvm flutter build web --release` sem erro.

## Fora do escopo
- Compartilhar nos outros 9 tipos (Fase 5, com o layout-base de cada tipo).
- Compartilhar em outras páginas (categoria, Manifesto, Nossa história, Pessoa).
- Contador de compartilhamentos, metadados Open Graph (imagem e descrição na prévia do link) e encurtador de link.
- Apagar `SocialIcons`, `ArticleContent` ou os PNGs antigos (Fase 7).
- Mudar modelos, regras do Firebase, painel ou rotas; Geoensine e modo escuro.

## Perguntas em aberto
- Nenhuma. Respondidas no modo autônomo:
  - **Outros 9 tipos.** Decidido no modo autônomo: ficam sem compartilhar até a Fase 5, porque hoje eles não têm compartilhar algum (a 012 os descreveu com "compartilhar próprio", mas não há), encaixar o componente nos blocos antigos seria trabalho jogado fora na Fase 5, e o componente é único, então a Fase 5 só o posiciona.
  - **Celular e "Mais".** Decidido no modo autônomo: "Compartilhar" (nativo, se houver), "Copiar link", WhatsApp e "Mais" com as outras cinco, porque o planejamento pede o nativo "também" e os menos usados em "Mais"; o protótipo esconde todas as redes atrás do nativo, o que as deixaria inalcançáveis no celular.
  - **"Mais" como linha que se abre, não menu flutuante.** Decidido no modo autônomo: como no protótipo (a linha se expande abaixo), porque é mais simples para teclado e leitor de tela e não cobre o texto.
  - **Nativo só no celular.** Decidido no modo autônomo: só abaixo de 600 px e só quando o navegador oferece, porque o planejamento o restringe ao celular e no computador ele duplicaria as redes.
  - **Confirmação da cópia.** Decidido no modo autônomo: no próprio botão ("Link copiado" por ~2 s, como no protótipo) e anunciada ao leitor de tela, em vez de aviso flutuante, porque o protótipo faz assim e o aviso flutuante do projeto (`Messenger`) usa cores antigas.
  - **Twitter → X.** Decidido no modo autônomo: nome e ícone "X", porque o destino já é `x.com` e o protótipo usa "X".
  - **Ícones.** Decidido no modo autônomo: traço do protótipo, em SVG (o `flutter_svg` já está no projeto), porque faltam ícones de LinkedIn e Telegram e os PNGs têm cores e estilos diferentes.
  - **Pacotes.** Decidido no modo autônomo: nenhum novo, porque a área de transferência é do Flutter e `package:web`/`dart:js_interop` já estão no projeto (usados em `lib/app/core/utils/browser/`).

## Histórico de mudanças
- 2026-10-01: criada e aprovada no modo autônomo (execução da Fase 2).
- 2026-10-01: plano e tarefas criados (`plan.md`, `tasks.md`).
- 2026-10-01: ajustes na implementação (modo autônomo). Texto de falha no botão passa a "Erro ao copiar" (o anúncio mantém a frase completa, "Não foi possível copiar o link"), porque a largura reservada para "Não foi possível copiar" deixava o botão com ~200 px e jogava o compartilhar para baixo do autor mesmo com nome curto. No celular, a linha deixa de ser "uma só": com o botão nativo, "Compartilhar" + "Copiar link" já ocupam os 350 px úteis de 390, e WhatsApp e "Mais" quebram para a linha seguinte.
- 2026-10-01: implementada. Conferência em build `APP_ENV=prod` só leitura.
- 2026-10-01: verificada com ressalvas ([verificacao.md](verificacao.md)). Hover dos ícones em `accentStrong` (o `accent` sobre `accentSoft` dava 4,4:1); no celular, WhatsApp e "Mais" quebram juntos. Divergências da implementação aceitas no modo autônomo.
- 2026-10-01: celular reestruturado após revisão da pessoa: saem os botões com texto e o "Mais". Fica o rótulo "Compartilhar" (com "Link copiado" ou "Erro ao copiar" ao lado depois da cópia) e uma fileira só de ícones: compartilhar do aparelho (se houver), copiar link, WhatsApp, Facebook, X, LinkedIn, Telegram e e-mail. Oito ícones ocupam 332 px e cabem nos 350 px úteis de 390.
