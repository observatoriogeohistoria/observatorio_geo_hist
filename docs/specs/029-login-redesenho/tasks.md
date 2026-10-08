# Tarefas da 029. Login redesenhado

Legenda: `- [ ]` a fazer, `- [x]` feita.

Critérios de aceite da spec, na ordem: 1 telas do protótipo sem overflow · 2 rótulos e sem regra de senha · 3 envio vazio · 4 senha curta aceita · 5 credencial errada · 6 "Entrando…" · 7 sucesso e sessão aberta · 8 Voltar ao site e logo · 9 mostrar/ocultar senha · 10 faixa de ambiente · 11 contraste · 12 sem valores soltos · 13 analyze.

## Grupo A: tema e peças compartilhadas
- [ ] **A1.** Tokens do login: colunas (5:6), paddings por faixa da marca (40/24) e da área do formulário (48×32 / 28×16), cartão (largura máxima 400, padding 32 e 24×20, raio `r18`, sombra), anéis (passo, 15 %, centro no canto inferior direito), espaços (sobretítulo→título, título→texto, voltar ao site) e aviso. Renomear `signinCard*` para `login*`. Estilos `loginBrandTitle` (26/36/44), `loginCardTitle` (28) e `loginLead`. Arquivos: `app_dimensions.dart`, `app_text_styles.dart`. Atende: 12.
- [x] **A2.** `FormTextField` com `hintText`, `obscureText` (força uma linha) e `suffix` opcionais. Arquivo: `core/components/form/form_text_field.dart`. Atende: 2, 9. Conferir: Contato e Colabore iguais (A6). Feito. Sem `suffix`, a árvore do campo fica igual à de antes.
- [x] **A3.** `isLoading` no `AppButtonBase` e no `PrimaryButton`: indicador branco antes do texto, opacidade cheia, sem `onTap`, semântica desabilitada e indicador parado com `MediaQuery.disableAnimations`. Arquivos: `app_button_base.dart`, `primary_button.dart`. Atende: 6. Feito. O `PrimaryButton` repassa só `isLoading`: o botão do login ocupa a largura do cartão, então `reserveTexts` não fez falta.
- [x] **A4.** `AppLogo(semanticLabel:)` opcional, mantendo o padrão atual. Arquivo: `core/components/logo/app_logo.dart`. Atende: 8. Feito.
- [x] **A5.** Faixa com "Ambiente de testes". Arquivo: `environment_banner.dart`. Atende: 10. Feito.
- [x] **A6.** Conferir as telas que usam as peças de A2 a A5: Contato e Colabore (campos e erro), Home (botões, logo na navbar e no rodapé) e uma página com a faixa, em 390 e 1280. Sem regressão visual. Conferido no build de release: Home (botões, logo, faixa), Contato e Colabore em 390 e 1280, sem diferença visível.

## Grupo B: componentes do login
- [ ] **B1.** `LoginRingsPainter` e `LoginBrandPanel` (`compact` no celular: só logo, sobretítulo e título menor). Os anéis ficam em `ExcludeSemantics` + `IgnorePointer`. O logo usa `onDark` e `semanticLabel: 'Observatório, voltar ao site'`. Arquivos: `login/presentation/components/login_rings_painter.dart`, `login_brand_panel.dart`. Atende: 1, 8, 11.
- [ ] **B2.** `LoginErrorAlert`: fundo `errorSurface`, texto e ícone `error`, quebra de linha, `Semantics(liveRegion: true)`. Arquivo: `components/login_error_alert.dart`. Atende: 5.
- [ ] **B3.** `PasswordVisibilityButton`: alvo de 44 px, nome "Mostrar senha"/"Ocultar senha", `toggled`, dica "Mostrar a senha digitada"/"Ocultar a senha" no hover e no foco do teclado (`ensureTooltipVisible`), anel de foco. Arquivo: `components/password_visibility_button.dart`. Atende: 9.
- [ ] **B4.** `BackToSiteLink`: seta e "Voltar ao site" em `inkSecondary`, `accentStrong` no hover, anel de foco, semântica de link, `context.go(AppRoutes.root)`. Arquivo: `components/back_to_site_link.dart`. Atende: 8.

## Grupo C: página
- [ ] **C1.** Reescrever o layout da `SigninPage`: duas colunas a partir de 600 px e uma no celular. Altura mínima da janela, com rolagem. Cartão com título, subtítulo, aviso, campos, botão na largura do cartão e "Voltar ao site". Ordem de Tab: logo, e-mail, senha, olho, Entrar, Voltar. Arquivo: `signin_page.dart`. Atende: 1, 2, 8.
- [ ] **C2.** Formulário: e-mail com `FormValidators.email('Informe o e-mail, como nome@exemplo.com.')`, dica `nome@exemplo.com`, teclado de e-mail e autopreenchimento. Senha com `FormValidators.required('Informe a senha.')`. Enter em qualquer campo envia; validação sempre ativa depois da primeira tentativa; foco no primeiro campo com erro. Sem `Validators.isValidPassword`. Arquivo: `signin_page.dart`. Atende: 2, 3, 4.
- [ ] **C3.** Envio: ignora o envio se já estiver carregando, apara o e-mail e passa `isLoading` e o texto "Entrando…" ao botão. Arquivo: `signin_page.dart`. Atende: 6.
- [ ] **C4.** Erro: a reação a `LoginStateError` deixa de chamar o `Messenger`. O aviso mostra o texto unificado para `InvalidCredentials`, `UserNotFound` e `WrongPassword` e `failure.message` nos outros erros. Nos três primeiros, apaga a senha e põe o foco nela. O aviso some quando o estado sai de erro. A reação a `user` → `AppRoutes.panel` fica como está. Arquivo: `signin_page.dart`. Atende: 5, 7.

## Grupo D: conferência
- [ ] **D1.** `fvm dart format` nos `.dart` alterados e `fvm flutter analyze` sem erros novos, na cópia ASCII. Copiar a formatação de volta. Atende: 13.
- [ ] **D2.** Varredura de valores soltos: `grep` por `Color(`, `fontSize:`, `EdgeInsets` com número e `SizedBox` com número nos arquivos tocados. Atende: 12.
- [ ] **D3.** Contraste: calcular as razões dos textos da coluna escura, do subtítulo, do aviso, do link e do botão em carregamento. Todas ≥ 4,5:1. Atende: 11.
- [ ] **D4.** App de teste na cópia ASCII (`lib/main_harness.dart`, fora do repositório) com `AuthRepository` falso. Conferir num Chrome headless em 390, 600, 768 e 1280 px, comparando com a aba "Login" do protótipo: envio vazio (duas mensagens, foco no e-mail), senha de 3 caracteres chega ao repositório, senha "errada" (aviso, senha vazia e focada, sem aviso flutuante), "Entrando…" sem duplo envio, sucesso e sessão aberta indo ao painel, Tab na ordem da spec, olho por mouse e teclado (nome, estado, dica) e movimento reduzido. Atende: 1 a 9.
- [ ] **D5.** Build web release na cópia, servido localmente: `/admin` com a faixa no dev e sem ela com `--dart-define=APP_ENV=prod`. Logo e "Voltar ao site" levam à Home, em 390, 768 e 1280. O login real com o Firebase fica registrado como não conferido. Atende: 1, 8, 10.
- [ ] **D6.** Uma vez em modo debug (`fvm flutter run -d web-server`) com o app de teste: sem asserts nem `overflow` no console em 390, 768 e 1280. Parar todos os servidores no fim. Atende: 1.
