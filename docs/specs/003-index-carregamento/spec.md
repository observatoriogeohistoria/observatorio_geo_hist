# 003. Página base (`index.html`) e tela de carregamento

- **Status:** aprovada
- **Item do planejamento:** Fase 0, entrega 0.7
- **Protótipo:** sem aba própria. Usa a marca e as cores da aba "Fundamentos" (link no CLAUDE.md)
- **Criada em:** 2026-09-26
- **Depende de:** [001-fundacao](../001-fundacao/spec.md) (cores) e [002-botoes-navbar-rodape](../002-botoes-navbar-rodape/spec.md) (logo em SVG)

## Objetivo
Fazer o site se apresentar direito antes mesmo do app abrir: aba do navegador com nome e ícone certos, link que aparece bem quando colado em redes sociais, e uma tela de carregamento com a marca em vez de uma tela em branco.

## Situação atual
[web/index.html](../../../web/index.html) tem `<title>observatorio_geo_hist</title>`, descrição "A new Flutter project.", sem idioma declarado, favicon `logo.png` e nenhuma tela de carregamento (a pessoa vê a página em branco até o app subir). [web/manifest.json](../../../web/manifest.json) tem nome `observatorio_geo_hist`, a mesma descrição e cor azul padrão do Flutter (`#0175C2`). O Google Analytics já está configurado e **deve continuar**.

## Comportamento

### Aba do navegador e busca
- **Título:** "Observatório do Ensino de História e Geografia | UFU".
- **Descrição:** "Pesquisas, materiais e recursos para o ensino de História e Geografia. Projeto da Faculdade de Educação da UFU."
- **Idioma:** português do Brasil declarado na página.
- **Ícone da aba:** a nova marca (círculos concêntricos em laranja). Os ícones do manifesto (192 e 512 px, comuns e "maskable") também passam a ter a marca nova.
- **Cor do tema do navegador** (barra no celular): laranja de acento `#C94400`.

### Compartilhamento em redes
Ao colar o endereço do site no WhatsApp, Facebook, X ou LinkedIn, aparece um cartão com:
- o mesmo título e a mesma descrição acima;
- uma imagem de 1200×630 px com a marca e o nome do Observatório (criada nesta entrega);
- o endereço do site como link canônico.

Só a Home usa estes textos. Títulos e imagens específicos de cada post ficam fora desta entrega.

### Manifesto do aplicativo (`manifest.json`)
Nome "Observatório do Ensino de História e Geografia", nome curto "Observatório", mesma descrição, cor de tema `#C94400` e cor de fundo branca. Orientação livre (hoje está travada em retrato).

### Tela de carregamento inicial
Aparece **antes** do app abrir e some quando a primeira tela do app está pronta.
- **Aparência:** fundo branco, a marca em SVG centralizada com o nome "Observatório" abaixo e um indicador de progresso discreto em laranja. Nenhuma fonte externa: usa a fonte do sistema, para aparecer instantaneamente.
- **Saída:** desaparece com um esmaecimento curto, sem "pulo" do layout. Quem prefere movimento reduzido vê a troca sem animação (e o indicador fica parado).
- **Demora:** se o app levar mais de 15 segundos, aparece abaixo da marca "Está demorando mais que o normal. Verifique sua conexão e recarregue a página." com o botão "Recarregar".
- **Sem JavaScript:** a pessoa vê a marca e a mensagem "Este site precisa de JavaScript para funcionar."

## Estados
- **Carregando:** é o próprio objetivo desta spec (tela de carregamento acima).
- **Vazio:** não se aplica.
- **Erro:** se o app não abrir (falha de rede, script bloqueado), a mensagem de demora e o botão "Recarregar" ficam visíveis em vez de uma tela em branco.
- **Sem imagem / imagem com falha:** marca e ícones são locais. Se a imagem de compartilhamento falhar, a rede social mostra o cartão só com título e descrição.
- **Casos de borda:**
  - Conexão lenta: a tela de carregamento permanece até o app estar pronto, sem piscar em branco.
  - Voltar/avançar no navegador não reexibe a tela de carregamento.
  - Abrir direto um endereço interno (ex.: um post) mostra a mesma tela de carregamento e depois o conteúdo.

## Responsivo
Marca, nome e mensagens ficam centralizados e legíveis em 390, 768 e 1280 px, sem rolagem. A imagem de compartilhamento é única (1200×630 px).

## Acessibilidade
- Idioma declarado para leitores de tela e tradutores.
- A tela de carregamento anuncia "Carregando" aos leitores de tela e é removida da árvore de acessibilidade quando some.
- Texto das mensagens com contraste ≥ 4,5:1 sobre o fundo branco; o botão "Recarregar" tem foco visível e nome acessível.
- Respeita movimento reduzido.

## Dados e regras de negócio
- O Google Analytics (`G-Y2QTYSME8W`) e o leitor de PDF (`pdf.js`) continuam funcionando como hoje.
- Nenhuma rota, dado ou modelo muda.
- Endereço canônico: o domínio público do site (a confirmar no plano, a partir da configuração de deploy).
- Fora do navegador (Flutter em outras plataformas) nada muda.

## Critérios de aceite
- [ ] A aba mostra "Observatório do Ensino de História e Geografia | UFU" e o ícone novo.
- [ ] A página declara idioma pt-BR, a descrição e a cor de tema `#C94400`.
- [ ] O cartão de compartilhamento mostra título, descrição e imagem 1200×630 px em um validador de Open Graph (ou nas prévias do WhatsApp/Facebook).
- [ ] `manifest.json` com nome, descrição, cores e ícones novos, e sem travar a orientação.
- [ ] A tela de carregamento aparece em menos de 1 s com rede lenta simulada e some sem piscar quando o app abre.
- [ ] Com o app bloqueado (rede desligada após a página), após 15 s aparecem a mensagem de demora e o botão "Recarregar", que recarrega a página.
- [ ] Sem JavaScript, a mensagem correspondente aparece.
- [ ] Com movimento reduzido ativo, não há animação na tela de carregamento.
- [ ] O Google Analytics segue registrando visitas (a chamada `gtag` continua na página).
- [ ] O leitor de PDF da biblioteca continua abrindo documentos.
- [ ] Nenhuma cor solta: valores da paleta da spec 001.
- [ ] `fvm flutter build web --release` conclui sem erros.

## Fora do escopo
- Títulos e imagens de compartilhamento próprios de cada post ou página interna.
- Busca, PWA offline e instalação como aplicativo.
- Mudanças no Google Analytics.
- Modo escuro.

## Perguntas em aberto
- Nenhuma. (Respondidas: incluir tags de compartilhamento e cor de tema; imagem de compartilhamento criada aqui com a marca e o nome; descrição conforme a proposta.)

## Histórico de mudanças
- 2026-09-26: criada.
- 2026-09-26: aprovada.
