# Plano da 003. Página base (`index.html`) e tela de carregamento

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-09-26

## Abordagem
A entrega é quase toda em `web/`, sem código Dart. Três frentes:

1. **Cabeçalho do `index.html`:** `lang="pt-BR"`, título, descrição, `theme-color`, ícones novos, tags Open Graph e Twitter Card e link canônico. O bloco do Google Analytics e os scripts do `pdf.js` ficam exatamente como estão (o `pdfx` usa o `pdfjsLib` global na biblioteca).
2. **Ícones e imagem de compartilhamento:** gerados a partir de `assets/images/logo.svg` (marca da 002) por um script que usa o Chrome em modo headless para "fotografar" pequenas páginas HTML no tamanho exato. Assim os PNG podem ser refeitos se a marca mudar, sem depender de ferramentas que não estão instaladas (não há ImageMagick, rsvg nem Pillow na máquina).
3. **Tela de carregamento:** HTML e CSS **inline** no `index.html`, logo no começo do `<body>`, antes de qualquer script. Assim ela aparece com o primeiro pedaço do HTML, sem esperar JS, fonte ou imagem. Um script inline pequeno:
   - escuta o evento `flutter-first-frame`, que o motor do Flutter Web dispara na janela quando a primeira tela é desenhada (confirmado em `platform_dispatcher.dart` do Flutter 3.44). Então esmaece a tela (≈200 ms), a tira da árvore de acessibilidade na hora (`aria-hidden`) e a remove do DOM ao fim da transição;
   - liga um temporizador de 15 s que mostra a mensagem de demora e o botão "Recarregar" (`location.reload()`), cancelado se o app abrir antes.

   Como o site é uma SPA, voltar/avançar e navegação interna nunca recarregam o `index.html`, e abrir um endereço interno direto passa pelo mesmo `index.html`: os casos de borda da spec saem de graça.

O `manifest.json` é reescrito com os textos e cores da spec, sem `orientation`.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | `web/index.html` | Cabeçalho, metadados de compartilhamento, tela de carregamento, `<noscript>` |
| Alterar | `web/manifest.json` | Nome, descrição, cores, sem travar orientação |
| Criar | `web/favicon.svg` | Ícone da aba em vetor (cópia da marca, sem `width/height` fixos) |
| Substituir | `web/favicon.png` | Ícone 32×32 de reserva para navegadores sem SVG |
| Criar | `web/icons/Icon-192.png`, `Icon-512.png`, `Icon-maskable-192.png`, `Icon-maskable-512.png` | Ícones do manifesto (os nomes que o manifesto já cita e que hoje **não existem**) |
| Substituir | `web/icons/apple-touch-icon.png` | 180×180 com a marca nova, fundo branco |
| Criar | `web/og-image.png` | Imagem de compartilhamento 1200×630 |
| Remover | `web/logo.png`, `web/icons/android-chrome-192x192.png`, `web/icons/android-chrome-512x512.png` | Ícones antigos sem uso depois da troca (só o `index.html` citava `logo.png`) |
| Criar | `tool/web_icons/gerar.sh` e `tool/web_icons/*.html` | Gerador dos PNG via Chrome headless |
| Alterar | `docs/redesign/planejamento.md` | Marcar 0.7 como concluída ao final |

## Decisões técnicas
- **Endereço canônico:** `https://observatoriogeohistoria.net.br/`. O deploy vai para a HostGator (`.github/workflows/deploy.yml`) e o endereço responde com o mesmo `index.html` do projeto; o subdomínio `geoensine.` citado em `AppStrings` confirma o domínio. `og:url`, `og:image` e `canonical` usam URL absoluta (redes sociais exigem).
- **Saída da tela no `flutter-first-frame`.** Alternativas: usar a API `_flutter.loader.load({onEntrypointLoaded})` num `flutter_bootstrap.js` próprio, ou chamar JS a partir do Dart. Descartadas: o `onEntrypointLoaded` dispara antes do `Firebase.initializeApp` e do primeiro desenho (a tela sairia cedo e piscaria em branco), e chamar JS pelo Dart mexeria em `main.dart` sem necessidade. O evento é público, disparado pelo próprio motor, e não exige mudar o bootstrap gerado.
- **Cores:** a spec pede "nenhuma cor solta". No `index.html` as cores ficam num único bloco de variáveis CSS (`--page`, `--ink`, `--ink-secondary`, `--accent`, `--accent-strong`), com comentário apontando para `AppColors` da 001, e são as únicas cores do arquivo além das do SVG da marca (idênticas às de `logo.svg`). O mesmo vale para os HTML do gerador.
- **Fonte da tela de carregamento:** pilha do sistema (`system-ui, -apple-system, "Segoe UI", Roboto, sans-serif`), sem fonte externa. Na imagem de compartilhamento, que é gerada offline, usa-se a Bricolage Grotesque de `assets/fonts` (a fonte de títulos do redesign).
- **Indicador de progresso:** anel de 28 px girando, laranja sobre trilha clara. Com `prefers-reduced-motion: reduce`, sem rotação e sem transição de saída (a tela some de uma vez).
- **Acessibilidade:** o contêiner tem `role="status"` e um texto visualmente oculto "Carregando"; a marca é `aria-hidden`. A mensagem de demora entra na mesma região viva, então também é anunciada. O botão "Recarregar" é um `<button>` nativo com contorno de foco de 3 px, afastado 2 px, na cor de acento (igual ao `AppFocusRing`). Contraste: `ink` (#1F1B18) e `ink-secondary` (#5E5852) sobre branco passam de 7:1; botão com texto branco sobre `accent` (#C94400) ≈ 4,9:1.
- **Sem JavaScript:** `<noscript>` com a mensagem dentro da tela de carregamento e um `<style>` em `<noscript>` no `<head>` que esconde o indicador (senão ficaria girando para sempre).
- **Ícones do manifesto:** comum = marca sobre fundo transparente; maskable = fundo laranja cheio e os anéis dentro da zona segura (80% central). Apple touch = marca sobre branco (iOS não aceita transparência).
- **Imagem de compartilhamento:** fundo `surface` (#F7F5F2), marca grande à esquerda, "Observatório do Ensino de História e Geografia" em `ink` e "Faculdade de Educação · UFU" em `ink-secondary`, faixa de acento na base.

## Dependências e geração de código
- Nenhum pacote novo, nenhuma rota, nenhum `build_runner`, nada em `*_setup.dart`.
- O gerador usa o Google Chrome instalado (`/Applications/Google Chrome.app`). Os PNG gerados ficam no repositório; o script só roda de novo se a marca mudar.

## Riscos e cuidados
- **Google Analytics e `pdf.js`:** não mexer nos blocos; conferir no `git diff` que ficaram idênticos e, no navegador, que `window.gtag` e `globalThis.pdfjsLib` existem, e abrir um documento na biblioteca.
- **Tela presa:** se o evento `flutter-first-frame` não chegar (versão futura do Flutter), a tela ficaria por cima do app. Salvaguarda: ao mostrar a mensagem de 15 s, se já existir `flutter-view` com conteúdo, some com a tela em vez de mostrar a mensagem.
- **Camadas:** o Flutter insere `<flutter-view>` no `<body>`. A tela usa `position: fixed; inset: 0` com `z-index` alto para ficar por cima até sair.
- **`$FLUTTER_BASE_HREF`:** caminhos relativos (`favicon.svg`, `icons/...`) continuam funcionando com o `<base>`.
- **Cache do navegador/HostGator:** ícones antigos podem aparecer por algum tempo após o deploy. Não há o que fazer além de nomes novos onde possível.
- **Modo debug:** em `flutter run -d chrome` o carregamento é bem mais lento que no release; o limite de 15 s pode disparar em debug. A conferência do tempo é feita no build release.

## Como conferir
- `fvm flutter analyze` (deve seguir limpo, não há Dart novo) e `fvm flutter build web --release`.
- Servir `build/web` localmente com um servidor simples em Python (no scratchpad) que:
  - atrasa `main.dart.js` em alguns segundos (rede lenta): a tela aparece na hora e some sem piscar;
  - nunca responde `main.dart.js` (app bloqueado): após 15 s aparecem a mensagem e o botão, que recarrega a página.
- No navegador: título da aba, ícone, `document.documentElement.lang`, `meta[name=theme-color]`, `meta[property^=og]`, `window.gtag`, `pdfjsLib`; abrir um documento na biblioteca.
- Movimento reduzido: `matchMedia('(prefers-reduced-motion: reduce)')` emulado (ou regra conferida no CSS) sem animação.
- Sem JS: abrir o `build/web/index.html` servido com JS desligado (ou conferir o `<noscript>` e o `<style>` do head).
- Larguras 390, 768 e 1280: marca, nome e mensagens centralizados, sem rolagem.
- Open Graph: conferir as tags no HTML servido e a imagem 1200×630 (`file`/`sips -g pixelWidth`). A validação em rede social real só é possível depois do deploy; fica registrada como pendente na verificação se não der para validar antes.
