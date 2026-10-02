# Plano da 013. Compartilhamento ampliado do post

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-10-01

## Abordagem
Um componente novo, `PostShare`, substitui o `SocialIcons` na linha de autoria do artigo. Ele recebe o post e decide o layout pela faixa de largura: em tablet e desktop, rótulo + seis ícones + "Copiar link"; no celular, "Compartilhar" (nativo, se houver) + "Copiar link" + WhatsApp + "Mais", com a linha das outras cinco opções abaixo quando aberta. Os destinos ficam numa lista única de opções (nome, ícone, modelo de link, mesma aba ou não), usada pelos dois layouts, para não duplicar regras.

O compartilhamento nativo e a cópia ficam em `lib/app/core/utils/browser/`, no padrão de exportação condicional já usado (`user_activation`, `semantic_links`): na web, `navigator.share`/`navigator.canShare` via `package:web` e `dart:js_interop`; fora dela, um stub que diz "sem suporte". A cópia usa `Clipboard.setData` do Flutter, que na web já chama a API do navegador e lança erro quando bloqueada.

O `SocialIcons` continua no projeto (ainda importado pelo `ArticleContent` antigo, que some na Fase 7). Os outros 9 tipos não mudam.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `assets/icons/share_whatsapp.svg`, `share_facebook.svg`, `share_x.svg`, `share_linkedin.svg`, `share_telegram.svg`, `share_email.svg` | Ícones de traço do protótipo (`#i-whatsapp`, `#i-facebook`, `#i-xsocial`, `#i-linkedin`, `#i-telegram`, `#i-mail`), viewBox 24, traço 1.8, cor aplicada no código |
| Alterar | `lib/app/core/utils/constants/app_strings.dart` | `shareOnLinkedin` (`https://www.linkedin.com/sharing/share-offsite/?url=[URL]`), `shareOnTelegram` (`https://t.me/share/url?url=[URL]&text=[TEXT]`); `shareOnTwitter` vira `shareOnX` (mesmo destino); usos atualizados |
| Criar | `lib/app/core/utils/browser/native_share.dart`, `native_share_stub.dart`, `native_share_web.dart` | `bool canNativeShare()` e `Future<NativeShareResult> nativeShare({title, url})` com `shared`, `cancelled` (`AbortError`) e `failed` |
| Alterar | `lib/app/core/components/buttons/app_button_base.dart` | Parâmetros opcionais `leadingIcon` (ícone decorativo antes do texto) e `reserveTexts` (textos que reservam a largura do maior, com `Visibility(maintainSize)` em `Stack`) |
| Alterar | `lib/app/core/components/buttons/secondary_button.dart` | Repassa `leadingIcon` e `reserveTexts` |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Em `ComponentSizes`, junto de `share*`: `shareLabelGap` 6 (`.share-label` `margin-right`), `shareCopyGap` 6 (`#copy-btn` `margin-left`), `shareRowGap` 4 (`gap:4px 2px`), `shareFeedbackDuration` como `Duration` de 1800 ms (onde ficam outras durações; se não houver lugar, em `AppTheme.dimensions` com comentário) |
| Criar | `lib/app/features/posts/presentation/components/post/post_share.dart` | `PostShare` (grupo "Compartilhar", layout por faixa, estado de "Mais" e da cópia), `_ShareOption` (lista única de destinos) e `_ShareIconButton` (38 px, `Tooltip`, `Semantics`, `AppFocusRing`, hover laranja sobre laranja suave) |
| Alterar | `lib/app/features/posts/presentation/components/post/article_header.dart` | `_Byline` usa `PostShare`; em tablet/desktop troca `Row(Expanded…)` por `Wrap(alignment: spaceBetween)` para o compartilhar descer quando não couber |
| Alterar | `lib/app/features/posts/presentation/components/social_icons.dart` | Só o renome de `shareOnTwitter` → `shareOnX` |
| Alterar | `docs/arquitetura.md` | Uma linha: `PostShare` é o compartilhar do layout-base; a Fase 5 o usa nos outros tipos |

## Decisões técnicas
- **Componente novo em vez de reescrever `SocialIcons` no lugar:** o `ArticleContent` antigo ainda o usa; criar `PostShare` evita mexer em código que vai ser apagado e deixa o nome certo para a Fase 5. Não há duplicação de uso: o artigo passa a usar só o novo.
- **Detecção do nativo:** `canNativeShare()` verifica se `navigator.share` existe (`hasProperty` de `dart:js_interop_unsafe`) e, se houver `canShare`, se aceita `{title, url}`. Mostrado só com `Breakpoint.mobile`. Alternativa (sempre mostrar e cair em "Mais") descartada: botão que não faz nada no computador.
- **Resultado do nativo:** `AbortError` = cancelado (nada acontece); outro erro abre "Mais". `navigator.share` exige gesto da pessoa: a chamada sai direto do `onTap`, sem `await` antes.
- **Cópia:** `Clipboard.setData(ClipboardData(text: Uri.base.toString()))` dentro de `try`; sucesso ou falha muda o texto do botão por `shareFeedbackDuration` com um `Timer` cancelado a cada clique e no `dispose`.
- **Anúncio:** `SemanticsService.sendAnnouncement(View.of(context), texto, TextDirection.ltr)` (API do Flutter 3.44; se o analisador indicar outra, usar a equivalente não depreciada). Também o rótulo do botão muda, então quem volta ao botão ouve o estado.
- **Largura estável:** `reserveTexts: ['Copiar link', 'Link copiado', 'Erro ao copiar']` no botão. Alternativa (largura fixa em token) descartada: quebra com fonte ampliada.
- **"Mais":** `_ShareIconButton` com ícone `Icons.more_horiz`, `Semantics(expanded: aberto)`; a linha revelada fica num `Wrap` logo abaixo, dentro do mesmo grupo e na ordem de foco natural (sem `FocusTraversalOrder` manual). Abrir/fechar sem animação.
- **Ícones de botão com texto:** `Icons.link`, `Icons.ios_share`/`Icons.share_outlined` e `Icons.check` do Material (decorativos); ícones das redes em SVG com `ColorFilter` na cor `muted` (ou `accent` no hover).
- **Montagem dos links:** a mesma de hoje (`[TEXT]`, `[SUBJECT]`, `[URL]` com `encodeUrlComponent`/`getEncodedCurrentUrl`); e-mail com `sameTab: true`.

## Dependências e geração de código
- Nenhum pacote novo (`web`, `flutter_svg` e `url_launcher` já estão no `pubspec.yaml`; `dart:js_interop`/`dart:js_interop_unsafe` são do SDK).
- Assets: os SVGs entram em `assets/icons/`, já declarado.
- Sem `build_runner`, sem rotas, sem `*_setup.dart`.

## Riscos e cuidados
- **`AppButtonBase` é compartilhado** (Home, contato, estados de erro, Manifesto etc.): os parâmetros novos são opcionais e o caminho sem eles não muda. Conferir dois botões existentes (Home e caixa de erro) depois.
- **Web Share no navegador embutido:** pode não existir ou exigir HTTPS; servido em `localhost` conta como contexto seguro. Se não houver suporte, conferir a ausência do botão e testar o caminho com suporte só pelo código ou por um stub temporário (não commitado).
- **Clipboard bloqueado:** a falha é conferida com erro injetado temporariamente (não commitado).
- **Linha de autoria em 768:** com vários autores longos, o `Wrap` deve descer o compartilhar sem `overflow`; conferir com dados injetados ou o artigo de autoria mais longa do banco.
- **Firebase dev sem artigos:** conferir em build `APP_ENV=prod` só leitura, como na 012.

## Como conferir
- `fvm flutter analyze` numa cópia em caminho ASCII (o "ó" do caminho quebra o analisador) e `fvm flutter build web --release`.
- Build servido por servidor Python próprio com fallback de SPA, no navegador embutido em 390, 768 e 1280 px: um artigo real (opções, ordem, links gerados lidos pelo `href`/`window.open` interceptado, cópia e anúncio, "Mais", Tab, contraste, `scrollWidth`), um post de outro tipo, um botão da Home e a caixa de erro. Console sem `overflow`. Voltar o navegador ao preset desktop e parar os servidores no fim.
