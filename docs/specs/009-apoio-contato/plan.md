# Plano da 009. Home: realização e apoio, chamada para contato

- **Spec:** [spec.md](spec.md)
- **Criado em:** 2026-09-27

## Abordagem
A lista de parceiros vira a fonte única do site: o enum `PartnersImages` passa a `Partner`, com sigla, nome completo e site, na ordem do protótipo. Um componente compartilhado em `core/components/partners/` desenha a grade (`PartnerLogoGrid`, com largura mínima de coluna configurável: 150 px ou 130 px) e cada logo (`PartnerLogo`, com o efeito de hover/foco e o link). A seção `PartnersSection` (título "Realização e apoio" + grade) substitui o antigo `Partners` na Home, na Biblioteca e em Colabore. No post, o `Support` só troca o `AlignedGridView` de 4 cartões pela `PartnerLogoGrid` de 130 px; o resto dele fica como está.

A chamada vira `ContactCallSection` (quadro `accentSoft`, título, texto e `PrimaryButton` com seta para `/contato`), no lugar do `ContactUs`, que é apagado.

Espaços: o protótipo tira o respiro de cima dos dois blocos finais (`padding-top:0`). Para o espaço não sumir quando a Equipe está escondida, o respiro de baixo da `TeamSection` passa a zero e a `PartnersSection` tem respiro em cima e embaixo; a chamada só tem respiro embaixo. O resultado com equipe é o mesmo do protótipo (um respiro entre cada bloco) e, sem equipe, Realização e apoio mantém o respiro acima do título.

A última parte do plano é a conferência da Home inteira (aceite da Fase 1) no app rodando, com dados simulados para Destaques e Equipe e com o Firebase de testes.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Criar | `lib/app/core/utils/enums/partner.dart` | Enum `Partner` na ordem do protótipo (`ufu, fapemig, cnpq, capes, faced, ppged, proexc, propp, uniube`) com `acronym`, `fullName`, `url` (`String?`: `null` se o site não abrir na conferência) e `assetPath` |
| Apagar | `lib/app/core/utils/enums/partners_images.dart` | Substituído por `partner.dart` (só `partners.dart` e `support.dart` o usam) |
| Criar | `lib/app/core/components/partners/partner_logo.dart` | Área com padding 12, raio 14; logo `Image.asset` com `fit: contain`, largura ≤ 150, proporção 280:186; repouso `ColorFiltered` em cinza + `Opacity` 0,55; hover/foco: cor, opacidade 1, `AnimatedScale` 1,05, área `AnimatedContainer`/`Transform` −3 px, fundo `page`, borda `line`, sombra `shadows.soft`; com `url`: `Semantics(link, label: fullName)` + `AppFocusRing` + `InkWell` (`openUrl`), cursor de mão; sem `url`: `Semantics(image, label: fullName)`, sem foco; `errorBuilder` com a sigla em `inkSecondary`; movimento reduzido (`MediaQuery.disableAnimationsOf`) sem deslocamento nem escala; altura ≥ `minTapTarget` |
| Criar | `lib/app/core/components/partners/partner_logo_grid.dart` | Colunas `max(1, floor((largura + 12) / (mínimo + 12)))` com `LayoutBuilder`; linhas `Row` + `Expanded`, última completada com vazios (mesmo padrão da `TeamGrid`); parâmetro `minColumnWidth` (padrão 150) |
| Criar | `lib/app/core/components/partners/partners_section.dart` | Fundo `page`, `PageContent`, respiro de seção em cima e embaixo, "Realização e apoio" `h2`/`ink` com `Semantics(header)`, `sectionHeadGap`, `PartnerLogoGrid` |
| Apagar | `lib/app/features/home/presentation/components/partners.dart` | Substituído por `PartnersSection` |
| Alterar | `lib/app/core/components/support/support.dart` | Troca o `Wrap` + `AlignedGridView` de 4 `AppCard` por `PartnerLogoGrid(minColumnWidth: partnerColumnMinWidthSmall)` com todos os `Partner.values`; redes sociais, divisória, título "APOIO" e fundo iguais; remove imports sem uso |
| Alterar | `lib/app/features/library/presentation/pages/library_page.dart` | `Partners()` → `PartnersSection()` (import novo) |
| Alterar | `lib/app/features/posts/presentation/pages/collaborate_page.dart` | `Partners()` → `PartnersSection()` (import novo) |
| Criar | `lib/app/features/home/presentation/components/contact_call/contact_call_section.dart` | `PageContent`, respiro de seção só embaixo; quadro `accentSoft`, raio 20, padding por faixa; título `ctaTitle`/`ink` com `Semantics(header)` e largura máxima em em; texto `regular` (16 px, `.cta p`)/`inkSecondary` com largura máxima; `PrimaryButton.medium('Fale com a gente', trailingIcon: seta)` → `go(AppRoutes.contact)`; `Row` no desktop (textos `Flexible`, gap ≥ 24, `center`), `Column` alinhada à esquerda abaixo de 1024 px ou com texto ampliado ≥ 130 % |
| Apagar | `lib/app/features/home/presentation/components/contact_us.dart` | Bloco cinza antigo (só a Home usa) |
| Alterar | `lib/app/features/home/presentation/components/team/team_section.dart` | Respiro de baixo = 0 (o de cima continua), para o espaço ficar na `PartnersSection` |
| Alterar | `lib/app/features/home/presentation/pages/home_page.dart` | Imports adiados de `partners_section` e `contact_call_section` no lugar de `partners` e `contact_us`; tira os comentários "redesenho na spec 009" |
| Alterar | `lib/app/core/routes/app_routes.dart` | Constante `contact = '/contato'` (a rota em `app_router.dart` não muda) |
| Alterar | `lib/app/theme/app_dimensions/app_dimensions.dart` | Em `ComponentSizes`: `partnerColumnMinWidth` 150, `partnerColumnMinWidthSmall` 130, `partnerGap` 12, `partnerPadding` 12, `partnerLogoMaxWidth` 150, `partnerLogoAspectRatio` 280/186, `partnerRestOpacity` 0,55, `partnerHoverLift` 3, `partnerHoverScale` 1,05, `partnerAnimation` 200 ms; `ctaPadding(breakpoint)` 28/46/56, `ctaTextGap` 8, `ctaButtonGap` 24, `ctaTitleMaxWidthEm` 12, `ctaTextMaxWidth` 460, `ctaStackTextScale` 1,3; em raios, usar `r14` e `r20` existentes |
| Alterar | `lib/app/theme/app_typography/app_text_styles.dart` | `ctaTitle` (display 24/32/35, 700, altura 1,12, −0,02 em), com origem `.cta h2` |
| Alterar | `docs/arquitetura.md` | Seção "Home": Realização e apoio (componente compartilhado com Biblioteca, Colabore e post) e chamada para contato; tabela de features cita os blocos novos |

## Decisões técnicas
- **Enum com dados em vez de mapa solto.** `Partner` guarda sigla, nome, site e caminho; a ordem do enum é a ordem de exibição. Alternativa (manter `PartnersImages` e um mapa à parte) deixaria duas listas para manter.
- **Links conferidos antes de entrar.** Na tarefa A1, cada endereço é testado com `curl -sIL` (status final 2xx/3xx). Endereço que falhar fica `url: null` e é registrado na spec (histórico) e na verificação. Não se inventa outro endereço.
- **Cinza por `ColorFilter.matrix`** (luminância 0,2126/0,7152/0,0722), sem pacote. A matriz é constante do componente, não uma cor.
- **Efeito do hover igual ao do foco.** Um único `bool _active = _hovered || _focused` controla cor, escala, subida, fundo, borda e sombra; `InkWell.onFocusChange` dá o foco. Sem splash (como na `TeamMemberTile`).
- **Subida com `AnimatedSlide`/`Transform.translate`, sem mudar o layout:** a linha não pula quando um logo sobe.
- **Grade própria (`Row` + `Expanded`) em vez de `GridView`/`AlignedGridView`.** Colunas iguais pela largura, sem altura fixa e sem `shrinkWrap`. `flutter_staggered_grid_view` continua no projeto se ainda houver outro uso; se não houver, fica registrado para a Fase 7 (não se remove pacote aqui).
- **Sem esqueleto:** os blocos são estáticos (spec, "Estados"). Continuam `deferred` na Home, como hoje.
- **Chamada empilhada abaixo do desktop e com texto ampliado.** Mesmo critério de 1,3 usado na 004 e na 006 (`heroShortcutsStackTextScale`, `whoWeAreStackTextScale`).
- **`Support` alterado só na grade de logos.** Continua com `num_extension` no resto (sai na fase do post); a grade nova não usa.
- **Nome acessível completo, sem tooltip:** o nome vem do `Semantics`; tooltip sobre logos atrapalharia o hover.

## Dependências e geração de código
- Nenhum pacote novo, nenhum asset novo, sem `build_runner` (nenhum store ou modelo Freezed muda).
- Rotas: só a constante `AppRoutes.contact`; `app_router.dart` não muda. Nenhum `*_setup.dart` muda.

## Riscos e cuidados
- **Componente compartilhado em quatro telas** (Home, `/biblioteca`, `/colaborar`, post): conferir as quatro em 390, 768 e 1280 px (tarefa D4). O post e as duas páginas antigas mantêm o visual antigo em volta; a transição para o bloco novo deve ficar sem linha solta.
- **Post:** o `Support` usa `ScreenUtils.getPageHorizontalPadding` e fundo `lighterGray`; o fundo branco do logo em hover precisa continuar visível sobre esse cinza. Conferir que o post continua abrindo e que o bloco não gera `overflow`.
- **Sites fora do ar ou com bloqueio a `curl`:** um site pode responder mal ao `curl` e funcionar no navegador; nesse caso, abrir no navegador embutido antes de decidir por `null`.
- **Aparelhos sem mouse** veem os logos sempre em cinza (decisão da spec). Registrar na verificação.
- **Respiro da `TeamSection`:** mudar o padding dela afeta os três estados (carregando, erro, grade); conferir que o espaço até "Realização e apoio" é um só respiro em todos, e que sem membros não há vão duplo.
- **Dados reais escassos** (0 destaques e 0 membros no Firebase de testes): a conferência da Home inteira usa dados simulados só na cópia do scratchpad, como na 005 e na 008.

## Como conferir
- `fvm flutter analyze` numa cópia em caminho ASCII no scratchpad (rsync sem `build/` e `.dart_tool/`, `fvm flutter pub get`) e `fvm flutter build web --release`.
- Testes de widget temporários na cópia (`test/partners_contact_test.dart`), fora do repositório.
- Build servido por Python com fallback de SPA, no navegador embutido em 390, 768 e 1280 px: Home, `/biblioteca`, `/colaborar`, um post e `/contato`. Pré-visualização com dados simulados (`lib/main_home_preview.dart`, só na cópia) para Destaques e Equipe com dados, carregando e erro. Voltar o navegador ao preset desktop e parar os servidores no fim.
