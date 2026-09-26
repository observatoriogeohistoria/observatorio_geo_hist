# Verificação da 003. Página base (`index.html`) e tela de carregamento

- **Data:** 2026-09-26
- **Resultado:** aprovada (cartão em rede social real pendente até o deploy)

## Comandos
| Comando | Resultado |
|---|---|
| `fvm flutter analyze` (cópia em caminho ASCII) | No issues found |
| `fvm flutter build web --release` (pasta original) | concluído sem erro (rodado de novo após o ajuste) |
| `build/web` servida por servidor Python local (SPA, `no-store`) em três modos: normal, `main.dart.js` com 5 s de atraso e `main.dart.js` sem resposta | ver critérios |
| Chrome headless via DevTools Protocol (390, 768 e 1280 px; movimento reduzido e JS desligado emulados) e navegador embutido | ver critérios |

Todas as tarefas do [tasks.md](tasks.md) estão marcadas.

## Critérios de aceite
| # | Critério | Situação | Evidência |
|---|---|---|---|
| 1 | Título da aba e ícone novo | passou | `document.title` igual ao da spec antes e depois do app abrir (`app_widget.dart` também mudou); `favicon.svg` e `favicon.png` servidos com 200 e marca nova conferida nos PNG |
| 2 | `lang` pt-BR, descrição e `theme-color` `#C94400` | passou | Lidos no DOM servido: `lang=pt-BR`, descrição da spec, `theme-color=#C94400` |
| 3 | Cartão de compartilhamento | passou nas tags; **pendente** em rede real | 11 metas `og:*`, 5 `twitter:*` e canônico com URL absoluta; `og-image.png` 1200×630 servido como `image/png` e conferido visualmente. Validador/WhatsApp só após o deploy |
| 4 | `manifest.json` | passou | Nome, nome curto, descrição, `#C94400`/`#FFFFFF`, sem `orientation`; quatro ícones existem nos tamanhos certos (maskable sem alfa e anéis na zona segura) |
| 5 | Tela em < 1 s com rede lenta e saída sem piscar | passou | Modo lento: primeira pintura aos 28 ms com a tela, visível aos 900 ms em `/biblioteca`; `flutter-first-frame` aos 5,6 s, esmaecimento e remoção 250 ms depois, app desenhado por baixo. Voltar/avançar não reinsere a tela |
| 6 | App bloqueado: mensagem e "Recarregar" aos 15 s | passou | Mensagem e botão visíveis, anel escondido; Tab dá foco visível (contorno 3 px laranja) e Enter recarrega a página |
| 7 | Sem JavaScript | passou | Com execução de scripts desligada: marca, nome e "Este site precisa de JavaScript para funcionar.", sem anel |
| 8 | Movimento reduzido | passou | `animation-name: none`, `transition-duration: 0s`; tela removida 1 ms após o evento |
| 9 | Google Analytics | passou | Bloco intacto no `git diff`; `typeof gtag === 'function'` e pedido ao `googletagmanager` |
| 10 | Leitor de PDF | passou | `pdfjsLib` definido; documento de Geografia aberto na biblioteca com o PDF renderizado, sem erros no console |
| 11 | Nenhuma cor solta | passou | Hex só no bloco de variáveis (valores de `AppColors`), no `theme-color` e no SVG da marca (idêntico a `logo.svg`), como previsto no plano |
| 12 | Build release | passou | Ver comandos |

Extras conferidos: sem rolagem em 390, 768 e 1280 (`scrollWidth`/`scrollHeight` iguais à janela); `role="status"` com "Carregando" oculto e `aria-hidden` ao sair; salvaguarda dos 15 s (evento bloqueado de propósito) remove a tela em vez de mostrar a mensagem; nenhum Dart além do `title`; itens de "Fora do escopo" intocados.

## Problemas encontrados
- Faltava `twitter:image:alt` (o X não usa o `og:image:alt`). Ajuste feito em `web/index.html`, com a mesma descrição do `og:image:alt`; conferido no HTML servido após novo build. Gravidade: detalhe.

## Não conferido
- Cartão em rede social real (WhatsApp, Facebook, X, LinkedIn): só depois do deploy. Pendente, não falha.
- Leitor de tela real (VoiceOver/NVDA): conferidos apenas os atributos ARIA.
