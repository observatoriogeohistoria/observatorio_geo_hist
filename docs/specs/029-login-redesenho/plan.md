# Plano da 029. Login redesenhado

- **Spec:** spec.md
- **Criado em:** 2026-10-08

## Abordagem
A `SigninPage` é reescrita como uma página de duas colunas (marca e formulário), que vira uma coluna abaixo de 600 px. As peças novas ficam em `admin/login/presentation/components/`. O formulário reaproveita o `FormTextField` do site (rótulo acima do campo, erro ligado ao campo), que já tem a cara do protótipo. Ele ganha dica, campo de senha e um ícone no fim. O `AppTextField` do painel fica como está, porque a 032 cuida dele.

A validação do login passa a usar `FormValidators` com as mensagens da spec. A senha só precisa estar preenchida. O erro do Firebase sai do `Messenger` e vira um aviso no cartão, com o texto unificado para credenciais escolhido na própria página. `AuthStore`, `AuthFailure`, rotas e redirecionamentos não mudam.

O botão "Entrar" usa um estado de carregamento novo no `AppButtonBase`. Esse estado é opcional e desligado por padrão, para não mexer nos outros botões.

## Arquivos
| Ação | Arquivo | Motivo |
|---|---|---|
| Alterar | lib/app/theme/app_dimensions/app_dimensions.dart | Tokens do login (colunas, paddings, cartão, anéis, aviso); `signinCard*` viram `login*` |
| Alterar | lib/app/theme/app_typography/app_text_styles.dart | Estilos `loginBrandTitle`, `loginCardTitle`, `loginLead`, por faixa |
| Alterar | lib/app/core/components/form/form_text_field.dart | `hintText`, `obscureText` e `suffix` opcionais |
| Alterar | lib/app/core/components/buttons/app_button_base.dart, primary_button.dart | `isLoading`: indicador, sem clique, parado com movimento reduzido |
| Alterar | lib/app/core/components/logo/app_logo.dart | `semanticLabel` opcional ("Observatório, voltar ao site") |
| Alterar | lib/app/core/components/environment/environment_banner.dart | Texto "Ambiente de testes" |
| Criar | lib/app/features/admin/login/presentation/components/login_brand_panel.dart | Coluna da marca, completa ou compacta (celular) |
| Criar | lib/app/features/admin/login/presentation/components/login_rings_painter.dart | Círculos decorativos, fora da semântica |
| Criar | lib/app/features/admin/login/presentation/components/login_error_alert.dart | Aviso vermelho anunciado (live region) |
| Criar | lib/app/features/admin/login/presentation/components/password_visibility_button.dart | Mostrar/ocultar com nome, estado e dica no foco |
| Criar | lib/app/features/admin/login/presentation/components/back_to_site_link.dart | Link "Voltar ao site" com seta |
| Alterar | lib/app/features/admin/login/presentation/signin_page.dart | Layout, formulário, envio e erro |

## Decisões técnicas
- **Campo:** estender o `FormTextField` em vez de criar um campo só do login ou mexer no `AppTextField`. Ele já tem rótulo acima, borda de 3:1 e erro na semântica. Os parâmetros novos são opcionais, então Contato e Colabore não mudam.
- **Mensagem unificada:** fica na página (`InvalidCredentials`, `UserNotFound` e `WrongPassword` → texto da spec; o resto usa `failure.message`). A spec proíbe mudar as mensagens das falhas.
- **`passwordVisible` continua no `AuthStore`:** a spec veda mudar o store, então não roda o `build_runner`.
- **Carregamento do botão:** com opacidade cheia, para "Entrando…" manter o contraste. Fica fora do clique e com `enabled: false` na semântica. Usa `reserveTexts` para a largura não pular. Com movimento reduzido, o indicador aparece parado (`value` fixo).
- **Dica no foco:** o `Tooltip` do Flutter não abre com o foco do teclado. O botão de senha chama `ensureTooltipVisible` quando recebe foco no modo de destaque de teclado. O estado vai em `Semantics(toggled:)`, e o nome muda entre "Mostrar senha" e "Ocultar senha", que já diz o estado mesmo se o leitor não anunciar o pressionado.
- **Cores da coluna escura:** `footerBackground`, `white` no título, `footerText` no texto e no pé, e `footerHighlight` no sobretítulo, todas já usadas no rodapé com contraste ≥ 4,5:1. Os anéis usam `footerHighlight` a 15 %. Não há cor nova.
- **Altura:** `LayoutBuilder` + `SingleChildScrollView` + `ConstrainedBox(minHeight)` + `IntrinsicHeight`. As colunas esticam até a altura da janela e rolam quando não cabem.
- **Autopreenchimento:** `AutofillGroup` com `AutofillHints.email` e `password`, para o gerenciador de senhas do navegador. O e-mail é aparado antes do envio; a senha, não.
- **Faixas:** a regra do projeto vale (celular < 600 em uma coluna). De 600 a 767 px são duas colunas estreitas, o que precisa ser conferido em 600 px.

## Dependências e geração de código
Nenhum pacote novo e nenhum asset. Sem `build_runner` (store e modelos intactos). Sem mudança em `app_router.dart` nem em `*_setup.dart`.

## Riscos e cuidados
- `FormTextField`, `AppButtonBase`, `AppLogo` e `EnvironmentBanner` são compartilhados: conferir Contato, Colabore, Home (botões, navbar e rodapé) e uma tela qualquer com a faixa.
- Duas colunas em 600 px podem apertar o cartão: conferir sem `overflow`.
- `IntrinsicHeight` com `TextField` dentro pode dar assert em modo debug: por isso a conferência em debug. Se der assert, troque por `minHeight` só na `Row`.
- Sem credenciais, o login real com o Firebase fica sem conferir. Sucesso, erro e sessão aberta são conferidos com repositório falso.

## Como conferir
- `fvm flutter analyze` e `fvm dart format` numa cópia em caminho ASCII (o "ó" do caminho quebra as ferramentas).
- `fvm flutter build web --release` na cópia, servido localmente: `/admin` em 390, 600, 768 e 1280 px, com dev e com `--dart-define=APP_ENV=prod`.
- App de teste só na cópia (`lib/main_harness.dart`, nunca commitado) com `AuthRepository` falso: senha "errada" devolve `InvalidCredentials`, outra senha devolve usuário após atraso, e `currentUser` opcionalmente logado.
- Uma vez com `fvm flutter run -d web-server` (debug) para ver asserts e `overflow` no console.
