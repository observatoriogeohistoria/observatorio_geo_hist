# Verificação da 001. Fundação visual

- **Data:** 2026-09-26 (segunda rodada, com o app rodando)
- **Resultado:** aprovada com ressalvas

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found |
| `fvm flutter build web --release` (cópia ASCII) | concluído sem erro |
| Build release servida localmente e aberta no navegador | abre em 390, 768, 1024 e 1280 px |
| `fvm flutter run -d web-server` (debug) | abre; nenhum `overflow` nem exceção do Flutter no console |

> O `analyze` segue travando na pasta original por causa do "ó" do caminho; por isso a cópia ASCII.

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | App compila e roda; `analyze` sem avisos novos | passou | analyze limpo; build release ok; app aberto no navegador (release e debug) |
| 2 | Telas atuais e painel idênticos | passou (no escopo da 001) | `git diff` em `lib/app/theme`: só adições. Na tela, Home, manifesto, biblioteca, lista da biblioteca, contato, colaborar e login do admin seguem em Dosis com as cores de antes. As mudanças visíveis de navbar, rodapé e botões são da 002 |
| 3 | Cores da tabela no tema | passou | [app_colors.dart](../../../lib/app/theme/app_colors/app_colors.dart) linhas 23-40, valores conferidos um a um |
| 4 | Espaçamentos, raios, sombras e foco no tema | passou | [app_dimensions.dart](../../../lib/app/theme/app_dimensions/app_dimensions.dart): `SpacingScale`, `RadiiScale`, `ShadowStyle`, `FocusStyle`. Anel de foco (3 px, acento) visto em tela na navbar e nos botões |
| 5 | Fontes em `assets/fonts`, declaradas, offline | passou | Rede do navegador: as 7 fontes novas vêm de `assets/assets/fonts/*.ttf` (200) e **nenhuma** requisição a `fonts.gstatic.com`. O teste com a rede desligada foi feito pela pessoa (F2) |
| 6 | Tela de teste mostra cada estilo em 390, 768 e 1280 | não conferido | A tela foi removida na F5. Tamanhos conferidos no código; em tela, os títulos e textos da navbar/rodapé mudam de faixa como esperado |
| 7 | Estilos novos sem `google_fonts` nem `num_extension` | passou | `grep` em [app_text_styles.dart](../../../lib/app/theme/app_typography/app_text_styles.dart): só em comentário |
| 8 | Faixas certas em 390, 599, 600, 768, 1023, 1024, 1280 | passou | Código de `Breakpoint.fromWidth`. Em tela: 390 (celular, só "Observatório"), 768 (tablet, menu em painel, rodapé 2 colunas), 1024 e 1280 (desktop, itens em linha). 599/600/1023 só por leitura de código |
| 9 | Conteúdo respeita 1120 px e margens 20/32 | passou | [page_content.dart](../../../lib/app/core/components/page_content/page_content.dart); em 1280 px navbar e rodapé centralizados; em 390 px margem de 20 |
| 10 | Contraste ≥ 4,5:1 nos pares listados | passou | Tabela abaixo |
| 11 | Licenças OFL no repositório | passou | `assets/fonts/licenses/OFL-BricolageGrotesque.txt` e `OFL-Figtree.txt` |

### Contraste (WCAG)
| Par | Razão |
|---|---|
| principal / branco | 17,10 |
| secundário / branco | 7,01 |
| acento / branco | 4,87 |
| secundário / superfície | 6,45 |
| acento / superfície | 4,48 (abaixo; regra da spec: usar acento forte) |
| acento forte / superfície | 6,26 |
| acento / acento suave | 4,38 (abaixo; usar acento forte) |
| acento forte / acento suave | 6,11 |
| rodapé texto / fundo | 11,65 |
| rodapé destaque / fundo | 8,37 |
| erro / branco | 6,54 |
| sucesso / fundo de sucesso | 5,71 |

## Problemas encontrados
- **Detalhe:** o acento normal sobre superfície e sobre acento suave fica abaixo de 4,5:1, como a spec já previa. Quem usa essas cores precisa seguir a regra do acento forte.

## Não conferido
- A tela de teste (critério 6), porque foi removida. Recriá-la só para isso não compensa: os estilos já estão em uso na navbar e no rodapé.
- As larguras exatas 599, 600 e 1023 em tela (só por código).
